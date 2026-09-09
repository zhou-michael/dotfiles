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
4. For active topic branches (fix/agy-linux-keyring-auth, fix/agy-native-session-persistence):
   - Checkout the branch and rebase onto upstream/main (git checkout <branch> && git rebase upstream/main).
   - If upstream merged our PR or an equivalent patch, git rebase automatically drops the commit (git rev-list --count upstream/main..<branch> == 0).
   - If there is a merge conflict, inspect upstream's changes. If upstream fixed the issue differently and supersedes our patch, skip our commit (git rebase --skip). Otherwise resolve the conflict cleanly and verify with pytest. If ambiguous, abort rebase and report.
   - Push rebased topic branch to origin with --force-with-lease.
5. Rebuild integration branch 'dev':
   - Checkout dev and reset to upstream/main (git checkout dev && git reset --hard upstream/main).
   - For each active topic branch that is still ahead of upstream/main (rev-list > 0), merge it into dev: git merge <branch> -m \"Merge branch '<branch>' into dev\".
   - If all topic branches were merged upstream, dev remains cleanly identical to upstream/main.
   - Push dev to origin with --force-with-lease.
6. Verify all tests pass: run 'OMNIGENT_SKIP_WEB_UI=true uv run --group test pytest tests/onboarding/test_gemini_auth.py tests/test_antigravity_native_bridge.py tests/runner/test_delete_session_bridge_cleanup.py'.
7. Re-run 'OMNIGENT_SKIP_WEB_UI=true uv tool install --force --editable .' to ensure entrypoints and dependencies match upstream pyproject.toml.
8. Print a concise final summary starting with 'MAINTENANCE_STATUS: '."

# Run agy headlessly with timeout of 10m
agy -p "$PROMPT" --print-timeout 10m0s --dangerously-skip-permissions
