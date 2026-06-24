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


def load_guidelines():
    paths = ["AGENTS.md", ".github/AGENTS.md"]
    for path in paths:
        try:
            with open(path) as f:
                return f.read()
        except FileNotFoundError:
            continue
    return None


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
Examine the diff and identify any real issues.

Do NOT comment on:
- Code style that already matches project conventions
- Minor formatting differences
- Comments or documentation formatting
- Changes outside the diff

CRITICAL: Only report findings that are clearly present. If you are unsure
whether an issue exists, err on the side of not commenting. False positives
waste reviewer time.

CRITICAL: It is perfectly fine to return empty arrays. If the code looks
correct, return `{{"findings": [], "comments": []}}`. Do NOT fabricate issues
just to populate the arrays.

## Output format

Return valid JSON with:
- `verdict`: APPROVED | APPROVED_WITH_SUGGESTIONS | CHANGES_REQUESTED
- `summary`: 1-2 sentence summary of what the PR does
- `findings`: array of {{severity: "🔴"|"🟡"|"🟢", file: "path", finding: "description"}} (can be empty)
- `comments`: array of {{path, line, body}} for inline review notes (can be empty)

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


def pick_verdict(verdicts):
    best = "APPROVED"
    best_score = 0
    for v in verdicts:
        score = VERDICT_PRIORITY.get(v, 0)
        if score > best_score:
            best_score = score
            best = v
    return best
