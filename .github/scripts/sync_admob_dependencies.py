#!/usr/bin/env python3
# MIT License
#
# Copyright (c) 2026-present Poing Studios
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

from dataclasses import dataclass
import json
import os
from pathlib import Path
import re
import sys
import urllib.request
import xml.etree.ElementTree as ET
from typing import Dict, List, Optional


@dataclass(frozen=True)
class DependencyUpdate:
    platform: str
    dependency: str
    old_version: str
    new_version: str
    file_path: str


class MavenClient:
    """Queries Maven metadata repositories (Google Maven & Maven Central) for artifact versions."""

    USER_AGENT = "PoingStudios-AdMobSync/1.0"
    REPOSITORIES = [
        "https://dl.google.com/android/maven2",
        "https://repo1.maven.org/maven2"
    ]

    def get_latest_version(self, group_id: str, artifact_id: str) -> str:
        for repo_base in self.REPOSITORIES:
            version = self._fetch_version_from_repo(repo_base, group_id, artifact_id)
            if version:
                return version
        return ""

    def _fetch_version_from_repo(self, repo_base: str, group_id: str, artifact_id: str) -> str:
        group_path = group_id.replace(".", "/")
        url = f"{repo_base}/{group_path}/{artifact_id}/maven-metadata.xml"
        try:
            req = urllib.request.Request(url, headers={"User-Agent": self.USER_AGENT})
            with urllib.request.urlopen(req, timeout=10) as resp:
                if resp.status == 200:
                    root = ET.fromstring(resp.read())
                    return root.findtext("./versioning/release") or root.findtext("./versioning/latest") or ""
        except Exception:
            pass
        return ""


class GitHubTagsClient:
    """Queries GitHub REST API for release tags."""

    USER_AGENT = "PoingStudios-AdMobSync/1.0"

    def __init__(self, token: str = ""):
        self._token = token

    def get_latest_tag(self, repo_path: str) -> str:
        return self._fetch_latest_release(repo_path) or self._fetch_first_tag(repo_path)

    def _get_headers(self) -> Dict[str, str]:
        headers = {"User-Agent": self.USER_AGENT}
        if self._token:
            headers["Authorization"] = f"token {self._token}"
        return headers

    def _fetch_latest_release(self, repo_path: str) -> str:
        url = f"https://api.github.com/repos/{repo_path}/releases/latest"
        try:
            req = urllib.request.Request(url, headers=self._get_headers())
            with urllib.request.urlopen(req, timeout=10) as resp:
                if resp.status == 200:
                    data = json.loads(resp.read().decode())
                    return data.get("tag_name", "").lstrip("v")
        except Exception:
            pass
        return ""

    def _fetch_first_tag(self, repo_path: str) -> str:
        url = f"https://api.github.com/repos/{repo_path}/tags?per_page=5"
        try:
            req = urllib.request.Request(url, headers=self._get_headers())
            with urllib.request.urlopen(req, timeout=10) as resp:
                if resp.status == 200:
                    tags = json.loads(resp.read().decode())
                    if tags:
                        return tags[0].get("name", "").lstrip("v")
        except Exception:
            pass
        return ""


class AndroidDependencySync:
    """Synchronizes Android AdMob and mediation dependencies in GDScript configs."""

    PATTERN = re.compile(r'"([a-zA-Z0-9._-]+:[a-zA-Z0-9._-]+):([a-zA-Z0-9._+-]+)"')

    def __init__(self, base_dir: Path, maven_client: MavenClient):
        self._base_dir = base_dir
        self._maven_client = maven_client

    def sync(self) -> List[DependencyUpdate]:
        updates: List[DependencyUpdate] = []
        for gd_file in self._base_dir.glob("platforms/android/src/**/config/*.gd"):
            file_updates = self._process_file(gd_file)
            updates.extend(file_updates)
        return updates

    def _process_file(self, gd_file: Path) -> List[DependencyUpdate]:
        content = gd_file.read_text(encoding="utf-8")
        updates: List[DependencyUpdate] = []
        modified = False

        def _replace_dependency(match: re.Match) -> str:
            nonlocal modified
            coord = match.group(1)
            current_ver = match.group(2)

            group_id, artifact_id = coord.split(":", 1)
            if not self._is_target_library(group_id):
                return match.group(0)

            latest_ver = self._maven_client.get_latest_version(group_id, artifact_id)
            if latest_ver and latest_ver != current_ver:
                print(f"[Android] {coord}: {current_ver} -> {latest_ver}")
                updates.append(DependencyUpdate(
                    platform="Android",
                    dependency=coord,
                    old_version=current_ver,
                    new_version=latest_ver,
                    file_path=str(gd_file.relative_to(self._base_dir))
                ))
                modified = True
                return f'"{coord}:{latest_ver}"'
            return match.group(0)

        new_content = self.PATTERN.sub(_replace_dependency, content)
        if modified:
            gd_file.write_text(new_content, encoding="utf-8")
        return updates

    @staticmethod
    def _is_target_library(group_id: str) -> bool:
        return (
            group_id.startswith("com.google.android.libraries.ads")
            or group_id.startswith("com.google.ads.mediation")
            or group_id.startswith("com.inmobi")
            or group_id.startswith("com.unity3d.ads")
        )


class IosDependencySync:
    """Synchronizes iOS SPM AdMob and mediation dependencies in GDScript configs."""

    PATTERN = re.compile(
        r'("url"\s*:\s*"https://github\.com/([^/]+/[^/.]+?)(?:\.git)?"\s*,\s*"version"\s*:\s*")([^"]+)(")'
    )

    def __init__(self, base_dir: Path, github_client: GitHubTagsClient):
        self._base_dir = base_dir
        self._github_client = github_client

    def sync(self) -> List[DependencyUpdate]:
        updates: List[DependencyUpdate] = []
        for gd_file in self._base_dir.glob("platforms/ios/src/**/config/*.gd"):
            file_updates = self._process_file(gd_file)
            updates.extend(file_updates)
        return updates

    def _process_file(self, gd_file: Path) -> List[DependencyUpdate]:
        content = gd_file.read_text(encoding="utf-8")
        updates: List[DependencyUpdate] = []
        modified = False

        def _replace_dependency(match: re.Match) -> str:
            nonlocal modified
            prefix = match.group(1)
            repo_path = match.group(2)
            current_ver = match.group(3)
            suffix = match.group(4)

            latest_ver = self._github_client.get_latest_tag(repo_path)
            if latest_ver and latest_ver != current_ver:
                print(f"[iOS] {repo_path}: {current_ver} -> {latest_ver}")
                updates.append(DependencyUpdate(
                    platform="iOS",
                    dependency=repo_path,
                    old_version=current_ver,
                    new_version=latest_ver,
                    file_path=str(gd_file.relative_to(self._base_dir))
                ))
                modified = True
                return f'{prefix}{latest_ver}{suffix}'
            return match.group(0)

        new_content = self.PATTERN.sub(_replace_dependency, content)
        if modified:
            gd_file.write_text(new_content, encoding="utf-8")
        return updates


class DependencySyncOrchestrator:
    """Coordinates multi-platform dependency synchronization and reporting."""

    def __init__(self, repo_root: Path, github_token: str = ""):
        self._repo_root = repo_root
        self._android_sync = AndroidDependencySync(repo_root, MavenClient())
        self._ios_sync = IosDependencySync(repo_root, GitHubTagsClient(github_token))

    def run(self) -> None:
        print("Checking for AdMob & Mediation SDK updates...")
        android_updates = self._android_sync.sync()
        ios_updates = self._ios_sync.sync()

        all_updates = android_updates + ios_updates
        if not all_updates:
            print("All dependencies are up to date! ✅")
            self._write_github_output(has_updates=False)
            return

        print(f"\nFound {len(all_updates)} update(s).")
        summary_table = self._build_markdown_table(all_updates)
        print("\n" + summary_table)
        self._write_github_output(has_updates=True, summary_table=summary_table)

    @staticmethod
    def _build_markdown_table(updates: List[DependencyUpdate]) -> str:
        table = "| Platform | Dependency | Current | Latest | File |\n| :---: | :--- | :---: | :---: | :--- |\n"
        for u in updates:
            table += f"| {u.platform} | `{u.dependency}` | `{u.old_version}` | **`{u.new_version}`** | `{u.file_path}` |\n"
        return table

    @staticmethod
    def _write_github_output(has_updates: bool, summary_table: str = "") -> None:
        output_file = os.environ.get("GITHUB_OUTPUT")
        if not output_file:
            return

        with open(output_file, "a", encoding="utf-8") as f:
            f.write(f"has_updates={'true' if has_updates else 'false'}\n")
            if summary_table:
                delimiter = "EOF_SUMMARY"
                f.write(f"summary_table<<{delimiter}\n{summary_table}\n{delimiter}\n")


def main():
    repo_root = Path(__file__).resolve().parent.parent.parent
    token = os.environ.get("GITHUB_TOKEN", "")
    orchestrator = DependencySyncOrchestrator(repo_root, token)
    orchestrator.run()


if __name__ == "__main__":
    main()
