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

from poing_reviewer.config import fingerprint
from poing_reviewer.false_positive import strip_footer
from poing_reviewer.github_api import (
    fetch_review_threads,
    resolve_thread,
    post_thread_comment,
)


def collect_thread_fingerprints(threads, bot_login):
    """Build lookup dict: fingerprint -> thread_id for bot-created threads.

    Returns (unresolved_fingerprints, fingerprint_to_thread_map) where:
      - unresolved_fingerprints: set of fingerprints for unresolved bot threads
      - fingerprint_to_thread_map: dict mapping fingerprint -> thread info dict
    """
    unresolved_fp = set()
    fp_to_thread = {}

    for thread in threads:
        if not thread:
            continue
        comments = (thread.get("comments") or {}).get("nodes") or []
        if not comments:
            continue

        first = comments[0]
        if not first:
            continue
        author_login = (first.get("author") or {}).get("login", "")
        is_bot = "bot" in author_login.lower() or (
            bot_login and author_login.lower() == bot_login.lower()
        )
        if not is_bot:
            continue

        body = strip_footer(first.get("body", ""))
        path = thread.get("path", "")
        line = thread.get("line")
        fp = fingerprint(path, body, line)

        if not thread.get("isResolved", False):
            unresolved_fp.add(fp)

        fp_to_thread[fp] = {
            "id": thread.get("id"),
            "comment_id": first.get("databaseId"),
            "path": path,
            "line": line,
            "body": body,
            "is_resolved": thread.get("isResolved", False),
        }

    return unresolved_fp, fp_to_thread


def resolve_fixed_threads(cfg, current_fingerprints, github_api_funcs):
    """Resolve bot threads whose finding is no longer present.

    github_api_funcs is a dict with keys: resolve_thread, post_thread_comment
    to allow dependency injection for testing.
    """
    resolve = github_api_funcs.get("resolve_thread", resolve_thread)
    post_reply = github_api_funcs.get("post_thread_comment", post_thread_comment)

    threads = fetch_review_threads(cfg.owner, cfg.repo_name, cfg.PR_NUMBER, cfg.GITHUB_TOKEN)
    if not threads:
        print("No review threads found.", file=sys.stderr)
        return 0

    _, fp_to_thread = collect_thread_fingerprints(threads, cfg.BOT_LOGIN)

    resolved_count = 0
    for fp, info in fp_to_thread.items():
        if info["is_resolved"]:
            continue
        if fp not in current_fingerprints:
            thread_id = info["id"]
            comment_id = info["comment_id"]

            resolved = resolve(thread_id, cfg.GITHUB_TOKEN)
            if resolved:
                print(
                    f"Resolved thread for {info['path']} L{info['line']} — "
                    f"finding no longer present: {info['body'][:80]}",
                    file=sys.stderr,
                )
                resolved_count += 1
            else:
                if comment_id:
                    post_reply(
                        cfg.REPO,
                        comment_id,
                        cfg.GITHUB_TOKEN,
                        "✅ This issue appears to be resolved in the latest push.",
                    )
                    print(
                        f"Posted 'resolved' reply for thread {thread_id} "
                        f"(could not auto-resolve, may lack permissions)",
                        file=sys.stderr,
                    )
                    resolved_count += 1
                else:
                    print(
                        f"Cannot resolve thread {thread_id} — "
                        f"no comment_id available for fallback reply",
                        file=sys.stderr,
                    )

    return resolved_count
