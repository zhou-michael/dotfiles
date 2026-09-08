#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$HOME/Documents/omnigent"
if [ ! -d "$REPO_DIR/.git" ]; then
    echo "Error: $REPO_DIR is not a git repository" >&2
    exit 1
fi

cd "$REPO_DIR"

PROMPT="You are running automated weekly maintenance on $REPO_DIR.
Instructions:
1. Ensure the working directory is clean. If there are uncommitted files, inspect them: if they are generated artifacts, clean or stash them; if they are active user code, abort with a warning message.
2. Fetch upstream main (git fetch upstream main).
3. Fast-forward local main to upstream/main if behind.
4. For active dev branches (including current branch like fix/agy-linux-keyring-auth):
   - Rebase onto upstream/main (git rebase upstream/main).
   - If there are merge conflicts, inspect the conflicting files, understand the context of both upstream and branch changes, resolve the conflicts cleanly, and run 'OMNIGENT_SKIP_WEB_UI=true uv run --group test pytest tests/onboarding/test_gemini_auth.py' to ensure tests pass. Then continue rebase.
   - If a conflict requires human design decisions, abort rebase and report what happened.
5. Re-run 'OMNIGENT_SKIP_WEB_UI=true uv tool install --force --editable .' to ensure entrypoints and dependencies match upstream pyproject.toml.
6. Print a concise final summary starting with 'MAINTENANCE_STATUS: '."

# Run agy headlessly with timeout of 10m
agy -p "$PROMPT" --print-timeout 10m0s --dangerously-skip-permissions
