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

from poing_reviewer.config import fingerprint, COMMENT_FOOTER_HINT


def strip_footer(body):
    """Remove the standard footer hint from a comment body."""
    idx = body.rfind("\n\n---\n>")
    if idx != -1:
        return body[:idx].strip()
    return body.strip()


def add_footer_hint(body):
    """Append the standard footer hint to a comment body."""
    return body.rstrip() + COMMENT_FOOTER_HINT


def _is_bot_comment_by_login(author_login, bot_login):
    if not author_login:
        return False
    if bot_login and author_login.lower() == bot_login.lower():
        return True
    return "bot" in author_login.lower()


def fetch_thumbs_down_fingerprints(threads, bot_login):
    """Extract fingerprints of bot thread comments that have a 👎 reaction.

    Uses already-fetched GraphQL thread data (single call) instead of
    N+1 REST calls per comment.
    """
    suppressed = set()

    for thread in threads:
        if not thread:
            continue
        comments = (thread.get("comments") or {}).get("nodes") or []
        for comment in comments:
            if not comment:
                continue
            author_login = (comment.get("author") or {}).get("login", "")
            if not _is_bot_comment_by_login(author_login, bot_login):
                continue

            reactions = (comment.get("reactions") or {}).get("nodes") or []
            has_thumbs_down = any(
                r.get("content") == "THUMBS_DOWN" for r in reactions
            )
            if not has_thumbs_down:
                continue

            body = strip_footer(comment.get("body", ""))
            path = thread.get("path", "")
            line = thread.get("line")
            fp = fingerprint(path, body, line)
            suppressed.add(fp)

    if suppressed:
        print(
            f"Found {len(suppressed)} previously 👎'd comment(s) to suppress",
            file=sys.stderr,
        )

    return suppressed


def is_suppressed(comment_body, path, line, suppressed_fingerprints):
    """Check if a proposed comment's fingerprint is in the suppressed set."""
    clean_body = strip_footer(comment_body)
    fp = fingerprint(path, clean_body, line)
    return fp in suppressed_fingerprints


def filter_action_version_false_positives(findings, comments, verified_actions):
    """Filters out false-positive findings and comments on verified-valid GitHub Actions."""
    if not verified_actions:
        return findings, comments

    valid_actions = {k for k, v in verified_actions.items() if v}
    if not valid_actions:
        return findings, comments

    fp_action_phrases = [
        "non-existent",
        "does not exist",
        "latest version is",
        "not exist",
        "invalid version",
        "unrecognized",
        "conflicts with",
    ]

    filtered_findings = []
    for f in findings:
        finding_text = f.get("finding", "").lower()
        is_fp = False
        for action in valid_actions:
            action_name = action.split("@")[0].lower()
            tag = action.split("@")[-1].lower()
            if (action_name in finding_text or tag in finding_text) and any(
                kw in finding_text for kw in fp_action_phrases
            ):
                print(
                    f"Suppressing false-positive action finding for verified [{action}]: {f['finding']}",
                    file=sys.stderr,
                )
                is_fp = True
                break
        if not is_fp:
            filtered_findings.append(f)

    filtered_comments = []
    for c in comments:
        comment_text = c.get("body", "").lower()
        is_fp = False
        for action in valid_actions:
            action_name = action.split("@")[0].lower()
            tag = action.split("@")[-1].lower()
            if (action_name in comment_text or tag in comment_text) and any(
                kw in comment_text for kw in fp_action_phrases
            ):
                print(
                    f"Suppressing false-positive action comment for verified [{action}]: {c['body']}",
                    file=sys.stderr,
                )
                is_fp = True
                break
        if not is_fp:
            filtered_comments.append(c)

    return filtered_findings, filtered_comments
