---
trigger: always_on
description: "Verify GitHub Actions versions against official repositories"
---

# GitHub Actions Version Verification

Whenever modifying, upgrading, or authoring GitHub Actions workflows (`.github/workflows/*.yml` or `action.yml`):
1. **Verify Action Versions**: Always verify the actual, existing latest stable release or tag of any GitHub Action by checking official repository releases (e.g. `gh release list --repo <owner>/<repo>` or official docs) before editing.
2. **No Speculative Version Numbers**: Never assume or increment major version numbers without validating that the release exists on GitHub.
