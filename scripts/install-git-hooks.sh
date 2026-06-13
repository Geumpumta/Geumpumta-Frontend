#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"

git -C "$repo_root" config core.hooksPath .githooks
echo "Git hooks installed: core.hooksPath=.githooks"
echo "Use CREATE_PR_ON_PUSH=1 git push to create a PR from an existing upstream branch."
