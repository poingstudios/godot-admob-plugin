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
from pathlib import Path
import re
from typing import List, Protocol


@dataclass(frozen=True)
class VersionRule:
    pattern: str
    replacement: str


class VersionExtractor(Protocol):
    def extract_rules(self, root_dir: Path) -> List[VersionRule]:
        ...


class AndroidAdsExtractor:
    CONFIG_PATH = Path("platforms/android/src/ads/config/poing_godot_admob_ads.gd")
    VERSION_REGEX = re.compile(
        r"com\.google\.android\.libraries\.ads\.mobile\.sdk:ads-mobile-sdk:([0-9.]+)"
    )

    def extract_rules(self, root_dir: Path) -> List[VersionRule]:
        file_path = root_dir / self.CONFIG_PATH
        if not file_path.is_file():
            return []

        match = self.VERSION_REGEX.search(file_path.read_text(encoding="utf-8"))
        if not match:
            return []

        version = match.group(1)
        return [
            VersionRule(
                pattern=r"(com\.google\.android\.libraries\.ads\.mobile\.sdk:ads-mobile-sdk:)\d+\.\d+\.\d+",
                replacement=rf"\g<1>{version}",
            ),
            VersionRule(
                pattern=r"(com\.google\.android\.libraries\.ads\.mobile\.sdk/ads-mobile-sdk/)\d+\.\d+\.\d+",
                replacement=rf"\g<1>{version}",
            ),
        ]


class IOSAdsExtractor:
    CONFIG_PATH = Path("platforms/ios/src/ads/config/poing_godot_admob_ads.gd")
    PACKAGES = {
        "swift-package-manager-google-mobile-ads": re.compile(
            r'swift-package-manager-google-mobile-ads\.git",\s*"version":\s*"([^"]+)"'
        ),
        "swift-package-manager-google-user-messaging-platform": re.compile(
            r'swift-package-manager-google-user-messaging-platform\.git",\s*"version":\s*"([^"]+)"'
        ),
    }

    def extract_rules(self, root_dir: Path) -> List[VersionRule]:
        file_path = root_dir / self.CONFIG_PATH
        if not file_path.is_file():
            return []

        content = file_path.read_text(encoding="utf-8")
        rules: List[VersionRule] = []

        for repo_name, pattern in self.PACKAGES.items():
            match = pattern.search(content)
            if not match:
                continue
            version = match.group(1)
            rules.append(
                VersionRule(
                    pattern=rf"({re.escape(repo_name)}/releases/tag/)\d+\.\d+\.\d+(\) [^`]+ `)\d+\.\d+\.\d+(`)",
                    replacement=rf"\g<1>{version}\g<2>{version}\g<3>",
                )
            )

        return rules


class DocSyncService:
    def __init__(self, root_dir: Path, extractors: List[VersionExtractor]):
        self.root_dir = root_dir
        self.extractors = extractors

    def sync(self, doc_patterns: List[str]) -> bool:
        rules: List[VersionRule] = []
        for extractor in self.extractors:
            rules.extend(extractor.extract_rules(self.root_dir))

        if not rules:
            return False

        any_changed = False
        target_files: List[Path] = []
        for pattern in doc_patterns:
            target_files.extend(self.root_dir.glob(pattern))

        for file_path in sorted(set(target_files)):
            if not file_path.is_file():
                continue

            content = file_path.read_text(encoding="utf-8")
            updated = content

            for rule in rules:
                updated = re.sub(rule.pattern, rule.replacement, updated)

            if updated != content:
                file_path.write_text(updated, encoding="utf-8")
                any_changed = True

        return any_changed


def main() -> None:
    root_dir = Path(__file__).resolve().parent.parent.parent
    service = DocSyncService(
        root_dir=root_dir,
        extractors=[
            AndroidAdsExtractor(),
            IOSAdsExtractor(),
        ],
    )
    service.sync(["docs/index*.md"])


if __name__ == "__main__":
    main()
