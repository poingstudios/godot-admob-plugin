# MIT License
#
# Copyright (c) 2026 Poing Studios
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import requests
import subprocess
import json
import sys
import time


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
        elif line.startswith("\\ No newline at end of file"):
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


def build_prompt(pr_title, annotated_diff, guidelines, batch_label):
    prompt = f"""You are Poing Reviewer, a senior code reviewer.
Analyze the pull request diff below and return a structured JSON response.

PR Title: {pr_title}

## What to focus on

1. **Logic errors and bugs** - Race conditions, null pointers, incorrect API usage
2. **Security issues** - Hardcoded secrets, injection vulnerabilities, permission problems
3. **Architecture violations** - Breaking cross-platform patterns, incorrect abstraction layers
4. **Project conventions** - GDScript/C# style, naming, type annotations, signal patterns
5. **API compatibility** - Breaking changes to the public API, missing signal parity
6. **Reliability** - Error handling, edge cases, resource cleanup

{batch_label}
Examine every changed file carefully. Identify ALL issues you find.
Cover bugs, logic errors, and potential improvements in every file touched.

Do NOT comment on:
- Code style that already matches project conventions
- Minor formatting differences
- Comments or documentation formatting
- Changes outside the diff

CRITICAL: Do NOT suggest changes for code that already exists in the diff.
Only report findings that are clearly present. If you are unsure whether an
issue exists, err on the side of not commenting. False positives waste
reviewer time.

## Output format

Return valid JSON with:
- `verdict`: APPROVED | APPROVED_WITH_SUGGESTIONS | CHANGES_REQUESTED
- `summary`: 1-2 sentence summary of what the PR does
- `findings`: array of {{severity: "🔴"|"🟡"|"🟢", file: "path", finding: "description"}}
- `comments`: array of {{path, line, body}} for inline review notes

In the annotated diff, each code line is prefixed like [path/to/file L12].
Match line numbers exactly when adding inline comments.
Only comment on lines that exist in the diff.
{guidelines}
## Annotated Diff

```diff
{annotated_diff}
```"""
    return prompt


def call_model(prompt, model_name, gemini_key):
    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model_name}:generateContent?key={gemini_key}"

    payload = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {
            "temperature": 0.2,
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

    for attempt in range(4):
        resp = requests.post(url, json=payload)
        if resp.status_code == 200:
            break
        if resp.status_code == 503 and attempt < 3:
            wait = 2 ** attempt * 10
            print(f"Model {model_name} busy (503), retry {attempt + 1}/3 in {wait}s...", file=sys.stderr)
            time.sleep(wait)
            continue
        print(f"API error ({model_name}): {resp.status_code} {resp.text}", file=sys.stderr)
        return None

    data = resp.json()
    if "candidates" not in data:
        print(f"Unexpected response ({model_name}): {json.dumps(data, indent=2)}", file=sys.stderr)
        return None

    parts = data["candidates"][0]["content"]["parts"]
    feedback = ""
    for part in parts:
        if not part.get("thought", False):
            feedback += part.get("text", "")

    if not feedback.strip():
        print(f"No review content generated ({model_name})", file=sys.stderr)
        return None

    try:
        raw = feedback.strip()
        if raw.startswith("```"):
            raw = raw.split("\n", 1)[-1]
        if raw.endswith("```"):
            raw = raw.rsplit("```", 1)[0]
        return json.loads(raw.strip())
    except json.JSONDecodeError as e:
        print(f"Failed to parse model response as JSON ({model_name}): {e}\nResponse: {feedback}", file=sys.stderr)
        return None


FALLBACK_MODELS = ["gemini-3.5-flash", "gemini-3-flash", "gemma-4-31b-it"]

VERDICT_PRIORITY = {"CHANGES_REQUESTED": 2, "APPROVED_WITH_SUGGESTIONS": 1, "APPROVED": 0}


def pick_verdict(verdicts):
    best = "APPROVED"
    best_score = 0
    for v in verdicts:
        score = VERDICT_PRIORITY.get(v, 0)
        if score > best_score:
            best_score = score
            best = v
    return best


def split_batches(file_blocks, max_chars):
    batches = []
    current = []
    current_size = 0
    for block in file_blocks:
        if current and current_size + len(block) > max_chars:
            batches.append(current)
            current = []
            current_size = 0
        current.append(block)
        current_size += len(block)
    if current:
        batches.append(current)
    return batches


def main():
    gemma_key = get_env("GEMMA_API_KEY")
    github_token = get_env("GITHUB_TOKEN")
    repo = get_env("REPO")
    pr_number = get_env("PR_NUMBER")
    base_ref = get_env("BASE_REF")
    pr_title = get_env("PR_TITLE")
    head_sha = get_env("PR_HEAD_SHA")
    primary_model = os.environ.get("MODEL_NAME", "gemini-3.5-flash")
    fallback_env = os.environ.get("FALLBACK_MODELS", "")
    models_to_try = [primary_model] + [m.strip() for m in fallback_env.split(",") if m.strip()] + FALLBACK_MODELS
    seen = set()
    models_to_try = [m for m in models_to_try if not (m in seen or seen.add(m))]
    max_chars = int(os.environ.get("MAX_CHARS", "100000"))
    max_batches = 5

    try:
        diff = subprocess.check_output(["git", "diff", f"origin/{base_ref}...HEAD"]).decode("utf-8")
    except Exception as e:
        print(f"Failed to get git diff: {e}", file=sys.stderr)
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

    file_blocks = split_diff_by_file(diff)
    batches = split_batches(file_blocks, max_chars)[:max_batches]

    total = len(batches)
    truncated = total > 1 or (total == 1 and len(diff) > max_chars and len(batches) > len(split_batches(file_blocks, max_chars)))

    if total == 1:
        banner = ""
    else:
        banner = f"(Review split into {total} parts — this is part 1 of {total})"

    guidelines_raw = load_guidelines()
    guidelines = ""
    if guidelines_raw:
        guidelines = f"""
## Repository Guidelines

The repository has an AGENTS.md file with project-specific rules. Follow these guidelines when reviewing:

{guidelines_raw}
"""

    all_results = []
    all_valid_lines = set()

    for i, batch in enumerate(batches):
        batch_label = f"You are reviewing part {i + 1} of {total}." if total > 1 else ""
        batch_diff = "".join(batch)
        annotated, valid_lines = annotate_diff(batch_diff)
        all_valid_lines.update(valid_lines)
        prompt = build_prompt(pr_title, annotated, guidelines, batch_label)
        result = None
        for model in models_to_try:
            print(f"Request {i + 1}/{total} ({len(batch)} file(s)) using {model}...")
            result = call_model(prompt, model, gemma_key)
            if result is not None:
                break
            print(f"  {model} failed, trying next model..." if model != models_to_try[-1] else f"  All models exhausted for batch {i + 1}.", file=sys.stderr)
        if result is None:
            print(f"All models failed for batch {i + 1}. Aborting.", file=sys.stderr)
            sys.exit(1)
        all_results.append(result)

    all_findings = []
    all_comments = []
    all_verdicts = []
    summaries = []

    for r in all_results:
        all_findings.extend(r.get("findings", []))
        all_comments.extend(r.get("comments", []))
        all_verdicts.append(r.get("verdict", "APPROVED"))
        summaries.append(r.get("summary", ""))

    combined_verdict = pick_verdict(all_verdicts)

    seen = set()
    unique_findings = []
    for f in all_findings:
        key = (f.get("file", ""), f.get("finding", ""))
        if key not in seen:
            seen.add(key)
            unique_findings.append(f)

    findings_rows = ""
    for f in unique_findings:
        findings_rows += f"| {f['severity']} | `{f['file']}` | {f['finding']} |\n"

    if not findings_rows:
        findings_rows = "| | | No issues found. ✅ |\n"

    combined_summary = " | ".join(s for s in summaries if s)

    verdict_map = {
        "APPROVED": "**✅ Approved**",
        "APPROVED_WITH_SUGGESTIONS": "**🟡 Approved with suggestions**",
        "CHANGES_REQUESTED": "**🔴 Changes requested**"
    }
    verdict_str = verdict_map.get(combined_verdict, "**🟡 Comment**")

    body_markdown = f"""## 📋 Summary

{combined_summary}

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
    github_event = github_event_map.get(combined_verdict, "COMMENT")

    comments_list = []
    for c in all_comments:
        path = c.get("path")
        line = c.get("line")
        body = c.get("body")
        if path and line and body:
            if (path, int(line)) in all_valid_lines:
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
