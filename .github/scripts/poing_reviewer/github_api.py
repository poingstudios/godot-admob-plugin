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

import requests


BASE_URL = "https://api.github.com"
GRAPHQL_URL = "https://api.github.com/graphql"


def _headers(token):
    return {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github.v3+json",
    }


def _graphql_headers(token):
    return {
        "Authorization": f"Bearer {token}",
    }


def fetch_bot_login(token):
    resp = requests.get(f"{BASE_URL}/user", headers=_headers(token))
    if resp.status_code == 200:
        return resp.json().get("login", "")
    return ""


def fetch_existing_reviews(repo, pr_number, token):
    resp = requests.get(
        f"{BASE_URL}/repos/{repo}/pulls/{pr_number}/reviews",
        headers=_headers(token),
    )
    if resp.status_code == 200:
        return resp.json()
    return []


def dismiss_review(repo, pr_number, review_id, token, message):
    resp = requests.put(
        f"{BASE_URL}/repos/{repo}/pulls/{pr_number}/reviews/{review_id}/dismissals",
        headers=_headers(token),
        json={"message": message},
    )
    return resp.status_code == 200


def submit_review(repo, pr_number, token, body, event, comments=None):
    payload = {"body": body.strip(), "event": event}
    if comments:
        payload["comments"] = comments
    resp = requests.post(
        f"{BASE_URL}/repos/{repo}/pulls/{pr_number}/reviews",
        headers=_headers(token),
        json=payload,
    )
    return resp


def submit_review_with_retry(repo, pr_number, token, body, event, comments):
    resp = submit_review(repo, pr_number, token, body, event, comments)
    if resp.status_code == 422 and comments:
        print(
            "GitHub rejected 422 with comments. Retrying without inline comments...",
            file=sys.stderr,
        )
        resp = submit_review(repo, pr_number, token, body, event, comments=None)
    if resp.status_code >= 400:
        print(f"GitHub API error: {resp.status_code} {resp.text}", file=sys.stderr)
        sys.exit(1)
    print("Review posted successfully!")
    return resp


def fetch_review_threads(owner, repo_name, pr_number, token):
    query = """
    query($owner: String!, $repo: String!, $pr: Int!) {
      repository(owner: $owner, name: $repo) {
        pullRequest(number: $pr) {
          reviewThreads(first: 100) {
            nodes {
              id
              isResolved
              path
              line
              pullRequestReview { databaseId }
              comments(first: 50) {
                nodes {
                  author { login }
                  body
                  databaseId
                  reactions(first: 10) {
                    nodes { content }
                  }
                }
              }
            }
          }
        }
      }
    }
    """
    payload = {
        "query": query,
        "variables": {
            "owner": owner,
            "repo": repo_name,
            "pr": pr_number,
        },
    }
    resp = requests.post(GRAPHQL_URL, headers=_graphql_headers(token), json=payload)
    if resp.status_code != 200:
        print(f"GraphQL error (fetch_review_threads): {resp.status_code} {resp.text}", file=sys.stderr)
        return []
    data = resp.json()
    if "errors" in data:
        print(f"GraphQL errors (fetch_review_threads): {json.dumps(data['errors'])}", file=sys.stderr)
        return []
    return (
        data.get("data", {})
        .get("repository", {})
        .get("pullRequest", {})
        .get("reviewThreads", {})
        .get("nodes", [])
    )


def resolve_thread(thread_id, token):
    mutation = """
    mutation($threadId: ID!) {
      resolveReviewThread(input: { threadId: $threadId }) {
        thread { id }
      }
    }
    """
    payload = {"query": mutation, "variables": {"threadId": thread_id}}
    resp = requests.post(GRAPHQL_URL, headers=_graphql_headers(token), json=payload)
    if resp.status_code != 200:
        print(f"GraphQL error (resolve_thread): {resp.status_code} {resp.text}", file=sys.stderr)
        return False
    data = resp.json()
    if "errors" in data:
        print(f"GraphQL errors (resolve_thread): {json.dumps(data['errors'])}", file=sys.stderr)
        return False
    return True


def post_thread_comment(repo, comment_id, token, body):
    """Post a reply to an existing review comment (fallback when resolve fails)."""
    resp = requests.post(
        f"{BASE_URL}/repos/{repo}/pulls/comments/{comment_id}/replies",
        headers=_headers(token),
        json={"body": body},
    )
    return resp.status_code == 201



