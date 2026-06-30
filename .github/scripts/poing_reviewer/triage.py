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

import sys

from poing_reviewer.config import (
    Config,
    AVAILABLE_LABELS,
    PRIORITY_LABELS,
    TRIAGE_FOOTER,
)
from poing_reviewer.model import build_triage_prompt, call_triage_model, parse_triage_response
from poing_reviewer.github_api import (
    fetch_issue,
    fetch_issue_labels,
    create_label,
    add_labels_to_issue,
    remove_label_from_issue,
    add_comment,
)


def _normalize_label(label):
    return label.lower().strip()


def _ensure_labels_exist(repo, labels_to_ensure, existing_labels, token):
    label_colors = {
        "bug": ("d73a4a", "Something isn't working"),
        "enhancement": ("a2eeef", "New feature or request"),
        "documentation": ("0075ca", "Improvements or additions to documentation"),
        "question": ("d876e3", "Further information is requested"),
        "help wanted": ("008672", "Extra attention is needed"),
        "ios": ("C5DEF5", "iOS platform"),
        "android": ("1FD539", "Android platform"),
        "wontfix": ("ffffff", "This will not be worked on"),
        "high priority": ("b60205", "High priority issue"),
        "medium priority": ("fbca04", "Medium priority issue"),
        "low priority": ("0e8a16", "Low priority issue"),
        "duplicate": ("cfd3d7", "This issue or pull request already exists"),
    }

    for label in labels_to_ensure:
        normalized = _normalize_label(label)
        if normalized not in [_normalize_label(l["name"]) for l in existing_labels]:
            if normalized in label_colors:
                color, desc = label_colors[normalized]
                create_label(repo, normalized, token, color=color, description=desc)
            else:
                create_label(repo, normalized, token)


def _parse_triage_result(result, available_labels):
    if not result:
        return [], "medium"

    labels = []
    for label in result.get("labels", []):
        normalized = _normalize_label(label)
        for available in available_labels:
            if _normalize_label(available) == normalized:
                labels.append(available)
                break

    priority = result.get("priority", "medium")
    if priority in PRIORITY_LABELS:
        labels.append(PRIORITY_LABELS[priority])

    return labels, priority


def run_triage(cfg):
    print(f"Triaging issue #{cfg.ISSUE_NUMBER} ({cfg.ISSUE_ACTION})...", file=sys.stderr)

    if cfg.ISSUE_ACTION in ("edited", "reopened"):
        print(f"Skipping automatic triage for issue action '{cfg.ISSUE_ACTION}'.", file=sys.stderr)
        return

    if cfg.ISSUE_ACTION == "comment" and cfg.COMMENT_BODY:
        if not cfg.IS_MAINTAINER:
            print("Comment not from maintainer, skipping triage.", file=sys.stderr)
            return

        if "/triage" not in cfg.COMMENT_BODY.lower():
            print("Comment does not contain /triage command, skipping.", file=sys.stderr)
            return

        print("Manual triage triggered by maintainer via /triage command.", file=sys.stderr)

    issue = fetch_issue(cfg.REPO, cfg.ISSUE_NUMBER, cfg.GITHUB_TOKEN)
    if not issue:
        print("Failed to fetch issue. Aborting.", file=sys.stderr)
        sys.exit(1)

    title = issue.get("title", cfg.ISSUE_TITLE)
    body = issue.get("body", cfg.ISSUE_BODY) or ""

    if not body.strip():
        print("Issue body is empty, using title only.", file=sys.stderr)
        body = f"(No description provided. Title: {title})"

    existing_labels = fetch_issue_labels(cfg.REPO, cfg.GITHUB_TOKEN)

    prompt = build_triage_prompt(title, body, AVAILABLE_LABELS)

    result = None
    for model in cfg.MODELS_TO_TRY:
        print(f"Triaging with {model}...", file=sys.stderr)
        raw = call_triage_model(prompt, model, cfg.GEMINI_API_KEY)
        if raw is not None:
            result = parse_triage_response(raw)
            if result is not None:
                break
        print(
            f"  {model} failed, trying next model..."
            if model != cfg.MODELS_TO_TRY[-1]
            else "  All models exhausted.",
            file=sys.stderr,
        )

    if result is None:
        print("All models failed. Aborting.", file=sys.stderr)
        sys.exit(1)

    print(f"Triage result: {result}", file=sys.stderr)

    labels_to_add, priority = _parse_triage_result(result, AVAILABLE_LABELS)

    if not labels_to_add:
        print("No labels determined. Skipping label update.", file=sys.stderr)
        return

    _ensure_labels_exist(cfg.REPO, labels_to_add, existing_labels, cfg.GITHUB_TOKEN)

    current_labels = [l["name"] for l in issue.get("labels", [])]
    labels_to_remove = [
        l for l in current_labels
        if l in [PRIORITY_LABELS["high"], PRIORITY_LABELS["medium"], PRIORITY_LABELS["low"]]
        and l not in labels_to_add
    ]

    for label in labels_to_remove:
        remove_label_from_issue(cfg.REPO, cfg.ISSUE_NUMBER, label, cfg.GITHUB_TOKEN)

    new_labels = [l for l in labels_to_add if l not in current_labels]
    if new_labels:
        add_labels_to_issue(cfg.REPO, cfg.ISSUE_NUMBER, new_labels, cfg.GITHUB_TOKEN)



    print(f"Issue #{cfg.ISSUE_NUMBER} triaged successfully.", file=sys.stderr)
