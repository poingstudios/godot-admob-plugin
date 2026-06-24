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
from poing_reviewer.github_api import fetch_pr_comments, fetch_comment_reactions


def strip_footer(body):
    """Remove the standard footer hint from a comment body."""
    idx = body.rfind("\n\n---\n>")
    if idx != -1:
        return body[:idx].strip()
    return body.strip()


def add_footer_hint(body):
    """Append the standard footer hint to a comment body."""
    return body.rstrip() + COMMENT_FOOTER_HINT


def _is_bot_comment(comment, bot_login):
    user = comment.get("user") or {}
    login = user.get("login", "")
    if not login:
        return False
    if bot_login and login.lower() == bot_login.lower():
        return True
    return "bot" in login.lower() and login != bot_login


def fetch_thumbs_down_fingerprints(repo, pr_number, bot_login, token):
    """Collect fingerprints of bot comments that have a 👎 reaction."""
    comments = fetch_pr_comments(repo, pr_number, token)
    suppressed = set()

    for comment in comments:
        if not _is_bot_comment(comment, bot_login):
            continue

        reactions = fetch_comment_reactions(repo, comment["id"], token)
        has_thumbs_down = any(
            r.get("content") == "-1" for r in reactions
        )
        if not has_thumbs_down:
            continue

        body = strip_footer(comment.get("body", ""))
        path = comment.get("path", "")
        line = comment.get("line")
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
