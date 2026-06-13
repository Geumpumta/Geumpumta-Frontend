#!/usr/bin/env bash
set -euo pipefail

BASE_BRANCH="${BASE_BRANCH:-}"
REMOTE="${REMOTE:-origin}"
PUSH_BEFORE_CREATE=1
TITLE=""

usage() {
  cat <<'USAGE'
Usage: scripts/create-pr.sh [--base <branch>] [--remote <remote>] [--no-push] [title]

Creates a GitHub pull request for the current branch using
.github/PULL_REQUEST_TEMPLATE as the PR body.

Environment:
  BASE_BRANCH  Base branch to open the PR against. Defaults to origin/HEAD or main.
  REMOTE       Git remote to push to. Defaults to origin.

Examples:
  scripts/create-pr.sh
  scripts/create-pr.sh "로그인 API 연동"
  BASE_BRANCH=develop scripts/create-pr.sh
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base)
      BASE_BRANCH="${2:-}"
      shift 2
      ;;
    --remote)
      REMOTE="${2:-}"
      shift 2
      ;;
    --no-push)
      PUSH_BEFORE_CREATE=0
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      TITLE="$1"
      shift
      ;;
  esac
done

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "error: '$1' command is required." >&2
    exit 1
  fi
}

repo_root="$(git rev-parse --show-toplevel)"
template_file="$repo_root/.github/PULL_REQUEST_TEMPLATE"

require_command git
require_command gh

if [[ ! -f "$template_file" ]]; then
  echo "error: PR template not found: $template_file" >&2
  exit 1
fi

branch="$(git -C "$repo_root" branch --show-current)"
if [[ -z "$branch" ]]; then
  echo "error: cannot create a PR from a detached HEAD." >&2
  exit 1
fi

case "$branch" in
  main|master|develop|dev)
    echo "error: refusing to create a PR from protected branch '$branch'." >&2
    exit 1
    ;;
esac

if [[ -z "$BASE_BRANCH" ]]; then
  BASE_BRANCH="$(git -C "$repo_root" remote show "$REMOTE" 2>/dev/null | awk '/HEAD branch/ { print $NF }')"
  BASE_BRANCH="${BASE_BRANCH:-main}"
fi

if [[ -z "$TITLE" ]]; then
  TITLE="$(git -C "$repo_root" log -1 --pretty=%s)"
fi

if [[ "$PUSH_BEFORE_CREATE" -eq 1 ]]; then
  if git -C "$repo_root" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' >/dev/null 2>&1; then
    git -C "$repo_root" push
  else
    git -C "$repo_root" push --set-upstream "$REMOTE" "$branch"
  fi
fi

existing_pr_url="$(gh pr view "$branch" --json url --jq .url 2>/dev/null || true)"
if [[ -n "$existing_pr_url" ]]; then
  echo "PR already exists: $existing_pr_url"
  exit 0
fi

gh pr create \
  --base "$BASE_BRANCH" \
  --head "$branch" \
  --title "$TITLE" \
  --body-file "$template_file"
