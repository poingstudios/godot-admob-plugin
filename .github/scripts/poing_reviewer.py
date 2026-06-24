import os
import re
import requests
import subprocess
import json
import sys


def sanitize_text(text):
    escaped = text.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ")
    return re.sub(r'\s+', ' ', escaped).strip()


def annotate_diff(diff_text):
    lines = diff_text.splitlines()
    annotated = []
    current_file = None
    new_line_num = 0
    valid_lines = set()

    for line in lines:
        if line.startswith("diff --git"):
            parts = line.split(" ")
            if len(parts) >= 4:
                current_file = parts[3][2:]
            annotated.append(line)
        elif line.startswith("+++ b/"):
            current_file = line[6:]
            annotated.append(line)
        elif line.startswith("--- a/") or line.startswith("index "):
            annotated.append(line)
        elif line.startswith("@@"):
            annotated.append(line)
            try:
                header = line.split("@@")[1].strip()
                new_part = header.split(" ")[1]
                new_start = int(new_part.split(",")[0][1:])
                new_line_num = new_start
            except Exception:
                pass
        elif current_file:
            if line.startswith("+"):
                annotated.append(f"[{current_file} L{new_line_num}] {line}")
                valid_lines.add((current_file, new_line_num))
                new_line_num += 1
            elif line.startswith("-"):
                annotated.append(f"[{current_file} DELETED] {line}")
            else:
                annotated.append(f"[{current_file} L{new_line_num}] {line}")
                valid_lines.add((current_file, new_line_num))
                new_line_num += 1
        else:
            annotated.append(line)

    return "\n".join(annotated), valid_lines


def split_diff_by_file(diff_text):
    """Split diff into per-file blocks by detecting 'diff --git' at line start."""
    lines = diff_text.splitlines(keepends=True)
    blocks = []
    current = []
    for line in lines:
        if line.startswith("diff --git") and current:
            blocks.append("".join(current))
            current = [line]
        else:
            current.append(line)
    if current:
        blocks.append("".join(current))
    return blocks


def main():
    gemma_key = os.environ["GEMMA_API_KEY"]
    github_token = os.environ["GITHUB_TOKEN"]
    repo = os.environ["REPO"]
    pr_number = os.environ["PR_NUMBER"]
    base_ref = os.environ["BASE_REF"]
    pr_title = os.environ["PR_TITLE"]
    model_name = os.environ.get("MODEL_NAME", "gemma-4-31b-it")
    max_chars = int(os.environ.get("MAX_CHARS", "100000"))

    try:
        diff = subprocess.check_output(["git", "diff", f"origin/{base_ref}...HEAD"]).decode("utf-8")
    except Exception as e:
        print(f"Failed to get git diff: {e}", file=sys.stderr)
        sys.exit(1)

    file_diffs = split_diff_by_file(diff)
    truncated_diff = ""
    if file_diffs:
        truncated_diff += file_diffs[0]
    for fd in file_diffs[1:]:
        if len(truncated_diff) + len(fd) < max_chars:
            truncated_diff += fd
        else:
            truncated_diff += "\n\n... (remaining files truncated due to size limit)"
            break
    diff = truncated_diff

    annotated_diff, valid_lines = annotate_diff(diff)

    safe_title = sanitize_text(pr_title)

    prompt = f"""You are Poing Reviewer, an AI code reviewer.
Analyze the annotated diff of a pull request and return a structured JSON response matching the schema.

PR Title: {safe_title}

In the annotated diff, each line of code is prefixed with its file path and new line number like: [path/to/file L12].
If you want to leave an inline comment on a specific line, add it to the 'comments' array in the JSON response.
Only comment on lines that exist in the diff. Ensure the 'line' number matches the number after the 'L' in the prefix exactly.

Annotated Diff:
```diff
{annotated_diff}
```"""

    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model_name}:generateContent?key={gemma_key}"

    payload = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {
            "responseMimeType": "application/json",
            "responseSchema": {
                "type": "OBJECT",
                "properties": {
                    "verdict": {
                        "type": "STRING",
                        "enum": ["APPROVED", "APPROVED_WITH_SUGGESTIONS", "CHANGES_REQUESTED"]
                    },
                    "summary": {
                        "type": "STRING",
                        "description": "One or two sentences describing what this PR changes."
                    },
                    "findings": {
                        "type": "ARRAY",
                        "items": {
                            "type": "OBJECT",
                            "properties": {
                                "severity": {
                                    "type": "STRING",
                                    "enum": ["🔴", "🟡", "🟢"]
                                },
                                "file": {
                                    "type": "STRING"
                                },
                                "finding": {
                                    "type": "STRING"
                                }
                            },
                            "required": ["severity", "file", "finding"]
                        }
                    },
                    "comments": {
                        "type": "ARRAY",
                        "items": {
                            "type": "OBJECT",
                            "properties": {
                                "path": {
                                    "type": "STRING",
                                    "description": "Relative file path of the code line"
                                },
                                "line": {
                                    "type": "INTEGER",
                                    "description": "Line number in the new version of the file"
                                },
                                "body": {
                                    "type": "STRING",
                                    "description": "The review comment for this specific line of code"
                                }
                            },
                            "required": ["path", "line", "body"]
                        }
                    }
                },
                "required": ["verdict", "summary", "findings", "comments"]
            }
        }
    }

    resp = requests.post(url, json=payload)
    if resp.status_code != 200:
        print(f"API error: {resp.status_code} {resp.text}", file=sys.stderr)
        sys.exit(1)

    data = resp.json()
    if "candidates" not in data:
        print(f"Unexpected response: {json.dumps(data, indent=2)}", file=sys.stderr)
        sys.exit(1)

    parts = data["candidates"][0]["content"]["parts"]
    feedback = ""
    for part in parts:
        if not part.get("thought", False):
            feedback += part.get("text", "")

    if not feedback.strip():
        print("No review content generated", file=sys.stderr)
        sys.exit(1)

    try:
        raw = feedback.strip()
        if raw.startswith("```"):
            raw = raw.split("\n", 1)[-1]
        if raw.endswith("```"):
            raw = raw.rsplit("```", 1)[0]
        review_data = json.loads(raw.strip())
    except Exception as e:
        print(f"Failed to parse model response as JSON: {e}\nResponse: {feedback}", file=sys.stderr)
        sys.exit(1)

    findings_rows = ""
    for f in review_data.get("findings", []):
        findings_rows += f"| {f['severity']} | `{f['file']}` | {f['finding']} |\n"

    if not findings_rows:
        findings_rows = "| | | No issues found. ✅ |\n"

    verdict_map = {
        "APPROVED": "**✅ Approved**",
        "APPROVED_WITH_SUGGESTIONS": "**🟡 Approved with suggestions**",
        "CHANGES_REQUESTED": "**🔴 Changes requested**"
    }
    verdict_str = verdict_map.get(review_data.get("verdict"), "**🟡 Comment**")

    body_markdown = f"""## 📋 Summary

{review_data.get('summary', '')}

## 🔍 Findings

| | File | Finding |
|---|---|---|
{findings_rows}
## 📌 Verdict

{verdict_str}
"""

    github_event_map = {
        "APPROVED": "APPROVE",
        "APPROVED_WITH_SUGGESTIONS": "APPROVE",
        "CHANGES_REQUESTED": "REQUEST_CHANGES"
    }
    github_event = github_event_map.get(review_data.get("verdict"), "COMMENT")

    comments_list = []
    for c in review_data.get("comments", []):
        path = c.get("path")
        line = c.get("line")
        body = c.get("body")
        if path and line and body:
            if (path, int(line)) in valid_lines:
                comments_list.append({
                    "path": path,
                    "line": int(line),
                    "side": "RIGHT",
                    "body": body
                })
            else:
                print(f"Skipping comment on invalid line: {path} L{line}", file=sys.stderr)

    headers = {"Authorization": f"Bearer {github_token}", "Accept": "application/vnd.github.v3+json"}
    review_payload = {
        "body": body_markdown.strip(),
        "event": github_event
    }
    if comments_list:
        review_payload["comments"] = comments_list

    r = requests.post(
        f"https://api.github.com/repos/{repo}/pulls/{pr_number}/reviews",
        headers=headers,
        json=review_payload
    )
    if r.status_code >= 400:
        print(f"GitHub API error: {r.status_code} {r.text}", file=sys.stderr)
        sys.exit(1)

    print("Review posted successfully!")


if __name__ == "__main__":
    main()
