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
from poing_reviewer.model import load_guidelines, build_prompt, call_review_model, pick_verdict
from poing_reviewer.github_api import (
    fetch_existing_reviews,
    dismiss_review,
    submit_review_with_retry,
    fetch_bot_login,
    fetch_review_threads,
    resolve_thread,
    post_thread_comment,
)
from poing_reviewer.false_positive import (
    fetch_thumbs_down_fingerprints,
    add_footer_hint,
)
from poing_reviewer.thread_resolver import collect_thread_fingerprints, resolve_fixed_threads


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

    # Check if already reviewed
    is_re_request = (
        cfg.TRIGGER_ACTION in ("review_requested", "workflow_dispatch") or
        "/review" in cfg.COMMENT_BODY.lower()
    )
    bot_reviews = [
        r for r in existing_reviews
        if r.get("user", {}).get("login") == cfg.BOT_LOGIN and r.get("state") != "PENDING"
    ]

    if bot_reviews:
        if is_re_request:
            print("Re-review requested. Dismissing existing reviews by the bot.", file=sys.stderr)
            for review in bot_reviews:
                dismiss_review(
                    cfg.REPO, cfg.PR_NUMBER, review["id"], cfg.GITHUB_TOKEN,
                    f"Re-review triggered on commit {cfg.HEAD_SHA[:8]}",
                )
        else:
            print("PR has already been reviewed by the bot. Skipping.")
            sys.exit(0)

    stale_reviews = [
        r for r in existing_reviews
        if r.get("state") == "CHANGES_REQUESTED" and r.get("commit_id") != cfg.HEAD_SHA
    ]
    stale_review_ids = {r["id"] for r in stale_reviews}

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
            result = call_review_model(prompt, model, cfg.GEMINI_API_KEY)
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

    reviewed_paths = {p for p, _ in all_valid_lines}

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

    if unique_findings:
        findings_section = "| Severity | File | Finding |\n| :---: | :--- | :--- |\n"
        for f in unique_findings:
            findings_section += f"| {f['severity']} | `{f['file']}` | {f['finding']} |\n"
    else:
        findings_section = "No issues found. ✅"

    combined_summary = " | ".join(s for s in summaries if s)
    verdict_str = VERDICT_MAP.get(combined_verdict, "**🟡 Comment**")

    body_markdown = f"""## 📋 Summary

{combined_summary}

## 🔍 Findings

{findings_section}

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

    # Fetch review threads (1 GraphQL call — includes reactions for FP suppression)
    threads = []
    try:
        threads = fetch_review_threads(cfg.owner, cfg.repo_name, cfg.PR_NUMBER, cfg.GITHUB_TOKEN)
    except Exception as e:
        print(f"Failed to fetch review threads: {e}", file=sys.stderr)

    # Extract thumbs-down fingerprints from the same thread data (no N+1)
    suppressed_fingerprints = fetch_thumbs_down_fingerprints(threads, cfg.BOT_LOGIN)

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

    # After posting, dismiss stale reviews and resolve their threads
    if stale_review_ids:
        try:
            threads = fetch_review_threads(cfg.owner, cfg.repo_name, cfg.PR_NUMBER, cfg.GITHUB_TOKEN)
        except Exception as e:
            print(f"Failed to fetch review threads: {e}", file=sys.stderr)
            threads = []

        if threads:
            for t in threads:
                if not t or t.get("isResolved", False):
                    continue
                review_node = t.get("pullRequestReview") or {}
                thread_review_id = review_node.get("databaseId")
                if thread_review_id and thread_review_id in stale_review_ids:
                    try:
                        resolve_thread(t["id"], cfg.GITHUB_TOKEN)
                    except Exception as exc:
                        print(f"Failed to resolve thread {t['id']}: {exc}", file=sys.stderr)

        for review in [r for r in existing_reviews if r["id"] in stale_review_ids]:
            dismissed = dismiss_review(
                cfg.REPO, cfg.PR_NUMBER, review["id"], cfg.GITHUB_TOKEN,
                f"Superseded by review on commit {cfg.HEAD_SHA[:8]}",
            )
            if dismissed:
                print(f"Dismissed stale review #{review['id']}", file=sys.stderr)

    # Resolve bot threads for issues fixed in this push
    resolve_fixed_threads(
        cfg,
        current_comment_fingerprints,
        reviewed_paths,
        {
            "resolve_thread": resolve_thread,
            "post_thread_comment": post_thread_comment,
        },
    )


if __name__ == "__main__":
    main()
