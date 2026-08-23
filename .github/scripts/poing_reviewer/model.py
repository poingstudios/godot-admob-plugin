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

import json
import sys
import time
import requests
from poing_reviewer.config import VERDICT_PRIORITY


REVIEW_SCHEMA = {
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


def load_guidelines():
    paths = ["AGENTS.md", ".github/AGENTS.md"]
    for path in paths:
        try:
            with open(path) as f:
                return f.read()
        except FileNotFoundError:
            continue
    return None


def build_prompt(pr_title, annotated_diff, guidelines, batch_label, verified_actions=None, file_contents=None):
    action_info = ""
    if verified_actions:
        valid_list = [f"- `{k}`: VALID (Verified live release/tag on GitHub)" for k, v in verified_actions.items() if v]
        invalid_list = [f"- `{k}`: INVALID (Not found on GitHub)" for k, v in verified_actions.items() if not v]
        lines = []
        if valid_list:
            lines.append("### Verified Action Versions (Live GitHub API Check):")
            lines.extend(valid_list)
            lines.append("\nCRITICAL: The actions marked VALID above have been confirmed to exist on GitHub. Do NOT claim they do not exist, and do NOT request changes for these valid versions.")
        if invalid_list:
            lines.append("### Unverified/Non-Existent Actions:")
            lines.extend(invalid_list)
        if lines:
            action_info = "\n## GitHub Actions Ground Truth\n" + "\n".join(lines) + "\n"

    files_context = ""
    if file_contents:
        files_blocks = []
        for fpath, content in file_contents.items():
            files_blocks.append(f"### Full File: `{fpath}`\n```\n{content}\n```")
        if files_blocks:
            files_context = "\n## Full Source Code of Modified Files (Ground Truth)\nUse the full file contents below to verify class declarations, method implementations, and symbol references across the whole file. Never speculate about code you cannot see in the diff—verify against this full file source.\n\n" + "\n\n".join(files_blocks) + "\n"

    prompt = f"""You are Poing Reviewer, a senior code reviewer.
Analyze the pull request diff and full file context below, and return a structured JSON response.

PR Title: {pr_title}

## Review Focus

1. **Logic errors and bugs** - Null dereferences, broken state machines, resource leaks, incorrect API usage
2. **Security vulnerabilities** - Secret leaks, injection, insecure permissions
3. **Architecture & parity** - GDScript/C# API parity, platform bridge integrity
4. **Reliability & error handling** - Unhandled exception paths, failed async states

{batch_label}

## Strict Quality Rules (No Nitpicks, No Speculation)

1. **GROUND TRUTH FIRST**: You are provided with both the `Annotated Diff` (what changed) and `Full Source Code of Modified Files` (the entire current file). Use the full file content to verify whether functions, variables, or constants are used before making any claims.
2. **NO SPECULATION**: NEVER post speculative comments such as "Please ensure other parts of the file/codebase don't use this", "make sure this doesn't break unseen code", or "not shown in this diff". If you do not see a definite bug in the provided context, do NOT comment.
3. **NO NITPICKS**: Do NOT comment on personal style preferences, trivial formatting, or comments.
4. **EMPTY IS FINE**: If the changes are clean and correct, return `{{"findings": [], "comments": []}}`. Do NOT invent issues.
5. **EXACT LINE MATCHING**: Inline comments must specify the exact line number from the `Annotated Diff` prefixed with `[<file> L<number>]`.

## Output format

Return valid JSON with:
- `verdict`: APPROVED | APPROVED_WITH_SUGGESTIONS | CHANGES_REQUESTED
- `summary`: 1-2 sentence summary of what the PR does
- `findings`: array of {{severity: "🔴"|"🟡"|"🟢", file: "path", finding: "description"}} (can be empty)
- `comments`: array of {{path, line, body}} for inline review notes (can be empty)

{guidelines}
{action_info}
{files_context}
## Annotated Diff

```diff
{annotated_diff}
```"""
    return prompt


def call_review_model(prompt, model_name, gemini_key):
    feedback = call_model(
        prompt,
        model_name,
        gemini_key,
        generation_config={"temperature": 0.2},
        response_schema=REVIEW_SCHEMA,
    )
    if feedback is None:
        return None
    return parse_json_response(feedback)


def pick_verdict(verdicts):
    best = "APPROVED"
    best_score = 0
    for v in verdicts:
        score = VERDICT_PRIORITY.get(v, 0)
        if score > best_score:
            best_score = score
            best = v
    return best


TRIAGE_PROMPT = """You are an issue triage assistant for a Godot AdMob plugin repository.

Analyze the following GitHub issue and provide:
1. A list of applicable labels from the available labels
2. A priority level (high, medium, low)
3. A brief summary of the issue (1-2 sentences)
4. Whether this is a duplicate or related to existing issues (if detectable)

## Issue Title
{title}

## Issue Body
{body}

## Available Labels
{labels}

## Response Format
Respond with a JSON object containing:
- "labels": array of label strings to apply
- "priority": one of "high", "medium", "low"
- "summary": brief summary string
- "is_duplicate": boolean indicating if this might be a duplicate

Only include labels that are clearly applicable based on the issue content.
Always include exactly one priority level.
"""


def build_triage_prompt(title, body, available_labels):
    from poing_reviewer.config import AVAILABLE_LABELS
    labels_str = "\n".join(f"- {label}" for label in available_labels)
    return TRIAGE_PROMPT.format(
        title=title,
        body=body[:3000],
        labels=labels_str,
    )


def call_triage_model(prompt, model, api_key):
    feedback = call_model(
        prompt,
        model,
        api_key,
        generation_config={"temperature": 0.1, "maxOutputTokens": 1024},
    )
    if feedback is None:
        return None
    return parse_json_response(feedback)


def parse_triage_response(data):
    if data is None:
        return None

    if "labels" not in data or "priority" not in data:
        print(f"Missing required fields in response: {data}", file=sys.stderr)
        return None

    if data["priority"] not in ("high", "medium", "low"):
        print(f"Invalid priority level: {data['priority']}", file=sys.stderr)
        data["priority"] = "medium"

    return {
        "labels": data.get("labels", []),
        "priority": data.get("priority", "medium"),
        "summary": data.get("summary", ""),
        "is_duplicate": data.get("is_duplicate", False),
    }


GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent"


def call_model(prompt, model_name, api_key, generation_config=None, response_schema=None):
    url = GEMINI_API_URL.format(model=model_name) + f"?key={api_key}"

    config = {
        "temperature": 0.2,
    }
    if generation_config:
        config.update(generation_config)

    payload = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": config,
    }

    if response_schema:
        payload["generationConfig"]["responseMimeType"] = "application/json"
        payload["generationConfig"]["responseSchema"] = response_schema

    for attempt in range(4):
        try:
            resp = requests.post(
                url,
                json=payload,
                headers={"Content-Type": "application/json"},
                timeout=60,
            )
            if resp.status_code == 200:
                break
            if resp.status_code == 503 and attempt < 3:
                wait = 2 ** attempt * 10
                import sys
                print(f"Model {model_name} busy (503), retry {attempt + 1}/3 in {wait}s...", file=sys.stderr)
                time.sleep(wait)
                continue
            import sys
            print(f"API error ({model_name}): {resp.status_code} {resp.text}", file=sys.stderr)
            return None
        except requests.exceptions.RequestException as e:
            import sys
            print(f"Request failed for {model_name}: {e}", file=sys.stderr)
            if attempt < 3:
                wait = 2 ** attempt * 5
                time.sleep(wait)
                continue
            return None

    data = resp.json()
    if "candidates" not in data:
        import sys
        print(f"Unexpected response ({model_name}): {json.dumps(data, indent=2)}", file=sys.stderr)
        return None

    parts = data["candidates"][0]["content"]["parts"]
    feedback = ""
    for part in parts:
        if not part.get("thought", False):
            feedback += part.get("text", "")

    if not feedback.strip():
        import sys
        print(f"No content generated ({model_name})", file=sys.stderr)
        return None

    return feedback.strip()


def parse_json_response(text):
    try:
        raw = text.strip()
        if raw.startswith("```"):
            raw = raw.split("\n", 1)[-1]
        if raw.endswith("```"):
            raw = raw.rsplit("```", 1)[0]
        return json.loads(raw.strip())
    except json.JSONDecodeError as e:
        import sys
        print(f"Failed to parse JSON response: {e}\nResponse: {text[:500]}", file=sys.stderr)
        return None
