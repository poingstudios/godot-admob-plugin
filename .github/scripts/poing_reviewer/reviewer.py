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
    VERDICT_MAP,
    GITHUB_EVENT_MAP,
    FP_KEYWORDS,
    fingerprint,
)
from poing_reviewer.diff import get_git_diff, annotate_diff, split_diff_by_file, split_batches
from poing_reviewer.model import load_guidelines, build_prompt, call_model, pick_verdict
from poing_reviewer.github_api import (
    fetch_existing_reviews,
    dismiss_review,
    submit_review_with_retry,
    fetch_bot_login,
    fetch_review_threads,
)
from poing_reviewer.false_positive import (
    fetch_thumbs_down_fingerprints,
    add_footer_hint,
)
from poing_reviewer.thread_resolver import (
    collect_thread_fingerprints,
    resolve_fixed_threads,
)


def _filter_model_false_positives(findings):
    filtered = []
    for f in findings:
        finding_lower = f.get("finding", "").lower()
        file_lower = f.get("file", "").lower()
        text = finding_lower + file_lower
        has_fp_keyword = any(kw in finding_lower for kw in FP_KEYWORDS)
        has_model_ref = any(m in text for m in ["model", "gemini", "gemma"])
        if has_fp_keyword and has_model_ref:
            print(f"Filtering false positive finding: {f['finding'][:80]}", file=sys.stderr)
            continue
        filtered.append(f)
    return filtered


def main():
    cfg = Config()

    if not cfg.BOT_LOGIN:
        cfg.BOT_LOGIN = fetch_bot_login(cfg.GITHUB_TOKEN)

    diff = get_git_diff(cfg.BASE_REF)

    existing_reviews = fetch_existing_reviews(cfg.REPO, cfg.PR_NUMBER, cfg.GITHUB_TOKEN)
    for review in existing_reviews:
        if review.get("commit_id") == cfg.HEAD_SHA and review.get("state") != "PENDING":
            print(f"Review already exists for commit {cfg.HEAD_SHA[:8]}. Skipping.")
            sys.exit(0)

    for review in existing_reviews:
        if (
            review.get("state") == "CHANGES_REQUESTED"
            and review.get("commit_id") != cfg.HEAD_SHA
        ):
            dismissed = dismiss_review(
                cfg.REPO,
                cfg.PR_NUMBER,
                review["id"],
                cfg.GITHUB_TOKEN,
                f"Superseded by review on commit {cfg.HEAD_SHA[:8]}",
            )
            if dismissed:
                print(f"Dismissed stale review #{review['id']}", file=sys.stderr)

    file_blocks = split_diff_by_file(diff)
    batches = split_batches(file_blocks, cfg.MAX_CHARS)[:cfg.MAX_BATCHES]
    total = len(batches)

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
        prompt = build_prompt(cfg.PR_TITLE, annotated, guidelines, batch_label)
        result = None
        for model in cfg.MODELS_TO_TRY:
            print(f"Request {i + 1}/{total} ({len(batch)} file(s)) using {model}...")
            result = call_model(prompt, model, cfg.GEMINI_API_KEY)
            if result is not None:
                break
            print(
                f"  {model} failed, trying next model..."
                if model != cfg.MODELS_TO_TRY[-1]
                else f"  All models exhausted for batch {i + 1}.",
                file=sys.stderr,
            )
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

    filtered_findings = _filter_model_false_positives(all_findings)

    has_red = any(f.get("severity") == "🔴" for f in filtered_findings)
    has_yellow = any(f.get("severity") in ("🟡", "🟢") for f in filtered_findings)
    if not has_red:
        if has_yellow:
            combined_verdict = "APPROVED_WITH_SUGGESTIONS"
        else:
            combined_verdict = "APPROVED"

    seen = set()
    unique_findings = []
    for f in filtered_findings:
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
    verdict_str = VERDICT_MAP.get(combined_verdict, "**🟡 Comment**")

    body_markdown = f"""## 📋 Summary

{combined_summary}

## 🔍 Findings

| | File | Finding |
|---|---|---|
{findings_rows}
## 📌 Verdict

{verdict_str}
"""

    # Build raw comments (without footer hint yet)
    raw_comments = []
    for c in all_comments:
        path = c.get("path")
        line = c.get("line")
        body = c.get("body")
        if path and line and body:
            if (path, int(line)) in all_valid_lines:
                raw_comments.append({
                    "path": path,
                    "line": int(line),
                    "side": "RIGHT",
                    "body": body,
                })
            else:
                print(f"Skipping comment on invalid line: {path} L{line}", file=sys.stderr)

    # Fetch thumbs-down fingerprints for false positive suppression
    suppressed_fingerprints = fetch_thumbs_down_fingerprints(
        cfg.REPO, cfg.PR_NUMBER, cfg.BOT_LOGIN, cfg.GITHUB_TOKEN
    )

    # Fetch review threads for dedup + resolution
    threads = []
    try:
        threads = fetch_review_threads(cfg.owner, cfg.repo_name, cfg.PR_NUMBER, cfg.GITHUB_TOKEN)
    except Exception as e:
        print(f"Failed to fetch review threads: {e}", file=sys.stderr)

    unresolved_fingerprints, fp_to_thread = collect_thread_fingerprints(threads, cfg.BOT_LOGIN)

    # Build current run's comment fingerprints (used for both dedup and thread resolution)
    current_comment_fingerprints = set()
    for c in raw_comments:
        fp = fingerprint(c["path"], c["body"], c["line"])
        current_comment_fingerprints.add(fp)

    # Filter comments: dedup against existing unresolved threads + suppress 👎'd comments
    filtered_comments = []
    for c in raw_comments:
        fp = fingerprint(c["path"], c["body"], c["line"])

        if fp in unresolved_fingerprints:
            print(
                f"Skipping duplicate comment on {c['path']} L{c['line']}",
                file=sys.stderr,
            )
            continue

        if fp in suppressed_fingerprints:
            print(
                f"Skipping suppressed comment on {c['path']} L{c['line']}",
                file=sys.stderr,
            )
            continue

        # Add footer hint before posting
        c["body"] = add_footer_hint(c["body"])
        filtered_comments.append(c)

    github_event = GITHUB_EVENT_MAP.get(combined_verdict, "COMMENT")

    # Downgrade APPROVE to COMMENT if there are unresolved bot threads
    if github_event == "APPROVE" and unresolved_fingerprints:
        print(
            "Unresolved bot comments found. Downgrading APPROVE to COMMENT.",
            file=sys.stderr,
        )
        github_event = "COMMENT"
        body_markdown += (
            "\n\n--- \n"
            "⚠️ **Note:** Unresolved discussions found above. "
            "Downgrading to COMMENT to avoid auto-approving the PR."
        )

    submit_review_with_retry(
        cfg.REPO,
        cfg.PR_NUMBER,
        cfg.GITHUB_TOKEN,
        body_markdown,
        github_event,
        filtered_comments,
    )

    # After posting, attempt to resolve fixed threads
    if threads:
        try:
            resolved = resolve_fixed_threads(cfg, current_comment_fingerprints, {})
            if resolved:
                print(f"Auto-resolved {resolved} thread(s).", file=sys.stderr)
        except Exception as e:
            print(f"Failed to resolve threads: {e}", file=sys.stderr)


if __name__ == "__main__":
    main()
