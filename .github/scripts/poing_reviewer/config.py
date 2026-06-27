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

import hashlib
import os
import sys

FALLBACK_MODELS = [
    "gemini-3.5-flash",
    "gemini-3.1-flash-lite",
    "gemini-3-flash-preview",
    "gemma-4-31b-it",
]


def get_env(key):
    value = os.environ.get(key)
    if value is None:
        print(f"Missing required environment variable: {key}", file=sys.stderr)
        sys.exit(1)
    return value


def get_env_optional(key, default=""):
    return os.environ.get(key, default)


def build_model_list(primary, fallback_env=""):
    fallback = [m.strip() for m in fallback_env.split(",") if m.strip()]
    models = [primary] + fallback + FALLBACK_MODELS
    seen = set()
    return [m for m in models if not (m in seen or seen.add(m))]


def parse_repo(repo):
    parts = repo.split("/")
    if len(parts) != 2:
        print(f"Invalid repo format: {repo}. Expected 'owner/repo'.", file=sys.stderr)
        sys.exit(1)
    return parts[0], parts[1]


VERDICT_PRIORITY = {
    "CHANGES_REQUESTED": 2,
    "APPROVED_WITH_SUGGESTIONS": 1,
    "APPROVED": 0,
}

VERDICT_MAP = {
    "APPROVED": "**✅ Approved**",
    "APPROVED_WITH_SUGGESTIONS": "**🟡 Approved with suggestions**",
    "CHANGES_REQUESTED": "**🔴 Changes requested**",
}

GITHUB_EVENT_MAP = {
    "APPROVED": "APPROVE",
    "APPROVED_WITH_SUGGESTIONS": "APPROVE",
    "CHANGES_REQUESTED": "REQUEST_CHANGES",
}

FP_KEYWORDS = [
    "invalid", "non-existent", "not found", "does not exist",
    "fictional", "not a valid",
]

COMMENT_FOOTER_HINT = (
    "\n\n---\n"
    "> 👍 helpful \u00b7 👎 false positive"
)

TRIAGE_FOOTER = (
    "\n\n---\n"
    "*🤖 This issue has been automatically triaged by Poing Reviewer.*"
)

AVAILABLE_LABELS = [
    "bug",
    "enhancement",
    "documentation",
    "question",
    "help wanted",
    "ios",
    "android",
    "wontfix",
]

PRIORITY_LABELS = {
    "high": "high priority",
    "medium": "medium priority",
    "low": "low priority",
}


def fingerprint(path, body, line=None):
    raw = f"{path}:{line}:{body[:120]}" if line is not None else f"{path}:{body[:120]}"
    return hashlib.sha256(raw.encode()).hexdigest()


class Config:
    def __init__(self):
        self.GEMINI_API_KEY = get_env("GEMINI_API_KEY")
        self.GITHUB_TOKEN = get_env("GITHUB_TOKEN")
        self.REPO = get_env("REPO")
        self.owner, self.repo_name = parse_repo(self.REPO)

        self.MODE = get_env_optional("MODE", "review")

        self.PR_NUMBER = get_env_optional("PR_NUMBER", "")
        self.BASE_REF = get_env_optional("BASE_REF", "")
        self.PR_TITLE = get_env_optional("PR_TITLE", "")
        self.HEAD_SHA = get_env_optional("PR_HEAD_SHA", "")

        self.ISSUE_NUMBER = get_env_optional("ISSUE_NUMBER", "")
        self.ISSUE_TITLE = get_env_optional("ISSUE_TITLE", "")
        self.ISSUE_BODY = get_env_optional("ISSUE_BODY", "")
        self.ISSUE_ACTION = get_env_optional("ISSUE_ACTION", "opened")
        self.COMMENT_BODY = get_env_optional("COMMENT_BODY", "")
        self.IS_MAINTAINER = get_env_optional("IS_MAINTAINER", "false").lower() == "true"

        self.PRIMARY_MODEL = get_env_optional("MODEL_NAME", "gemini-3.5-flash")
        self.MODELS_TO_TRY = build_model_list(
            self.PRIMARY_MODEL, get_env_optional("FALLBACK_MODELS", "")
        )
        self.MAX_CHARS = int(get_env_optional("MAX_CHARS", "100000"))
        self.MAX_BATCHES = 5
        self.BOT_LOGIN = get_env_optional("BOT_LOGIN", "")
        self.TRIGGER_ACTION = get_env_optional("TRIGGER_ACTION", "")
