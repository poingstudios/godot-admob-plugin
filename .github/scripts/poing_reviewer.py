import os
import requests
import subprocess
import json
import sys


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
            except (ValueError, IndexError):
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


def load_guidelines():
    paths = ["AGENTS.md", ".github/AGENTS.md"]
    for path in paths:
        try:
            with open(path) as f:
                return f.read()
        except FileNotFoundError:
            continue
    return None


def get_env(key):
    value = os.environ.get(key)
    if value is None:
        print(f"Missing required environment variable: {key}", file=sys.stderr)
        sys.exit(1)
    return value


def main():
    gemma_key = get_env("GEMMA_API_KEY")
    github_token = get_env("GITHUB_TOKEN")
    repo = get_env("REPO")
    pr_number = get_env("PR_NUMBER")
    base_ref = get_env("BASE_REF")
    pr_title = get_env("PR_TITLE")
    model_name = os.environ.get("MODEL_NAME", "gemma-4-31b-it")
    max_chars = int(os.environ.get("MAX_CHARS", "100000"))

    try:
        diff = subprocess.check_output(["git", "diff", f"origin/{base_ref}...HEAD"]).decode("utf-8")
    except Exception as e:
        print(f"Failed to get git diff: {e}", file=sys.stderr)
        sys.exit(1)

    try:
        head_sha = subprocess.check_output(["git", "rev-parse", "HEAD"]).decode("utf-8").strip()
    except Exception as e:
        print(f"Failed to get HEAD SHA: {e}", file=sys.stderr)
        sys.exit(1)

    headers = {"Authorization": f"Bearer {github_token}", "Accept": "application/vnd.github.v3+json"}
    existing_reviews = requests.get(
        f"https://api.github.com/repos/{repo}/pulls/{pr_number}/reviews",
        headers=headers
    )
    if existing_reviews.status_code == 200:
        for review in existing_reviews.json():
            if review.get("commit_id") == head_sha and review.get("state") != "PENDING":
                print(f"Review already exists for commit {head_sha[:8]}. Skipping.")
                sys.exit(0)

    file_diffs = split_diff_by_file(diff)
    truncated_diff = ""
    truncated = False
    if file_diffs:
        truncated_diff += file_diffs[0]
    for fd in file_diffs[1:]:
        if len(truncated_diff) + len(fd) < max_chars:
            truncated_diff += fd
        else:
            truncated = True
            truncated_diff += "\n\n# ⚠️ DIFF TRUNCATED — remaining files omitted due to size limit. Review is based on a partial diff."
            break
    diff = truncated_diff

    annotated_diff, valid_lines = annotate_diff(diff)

    safe_title = json.dumps(pr_title)[1:-1]

    guidelines = load_guidelines()
    guidelines_section = ""
    if guidelines:
        guidelines_section = f"""
## Repository Guidelines

The repository has an AGENTS.md file with project-specific rules. Follow these guidelines when reviewing:

{json.dumps(guidelines)[1:-1]}
"""

    prompt = f"""You are Poing Reviewer, a senior code reviewer.
Analyze the pull request diff below and return a structured JSON response.

PR Title: {safe_title}

## What to focus on

1. **Logic errors and bugs** - Race conditions, null pointers, incorrect API usage
2. **Security issues** - Hardcoded secrets, injection vulnerabilities, permission problems
3. **Architecture violations** - Breaking cross-platform patterns, incorrect abstraction layers
4. **Project conventions** - GDScript/C# style, naming, type annotations, signal patterns
5. **API compatibility** - Breaking changes to the public API, missing signal parity
6. **Reliability** - Error handling, edge cases, resource cleanup

Do NOT comment on:
- Code style that already matches project conventions
- Minor formatting differences
- Comments or documentation formatting
- Changes outside the diff

## Output format

Return valid JSON with:
- `verdict`: APPROVED | APPROVED_WITH_SUGGESTIONS | CHANGES_REQUESTED
- `summary`: 1-2 sentence summary of what the PR does
- `findings`: array of {{severity: "🔴"|"🟡"|"🟢", file: "path", finding: "description"}}
- `comments`: array of {{path, line, body}} for inline review notes

In the annotated diff, each code line is prefixed like [path/to/file L12].
Match line numbers exactly when adding inline comments.
Only comment on lines that exist in the diff.
{guidelines_section}
## Annotated Diff

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
    except json.JSONDecodeError as e:
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
