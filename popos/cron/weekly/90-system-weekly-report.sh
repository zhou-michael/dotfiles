#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

STATUS_REPO="$HOME/Documents/status"
HOST_DIR="$STATUS_REPO/pop"
REPORT_DATE="$(date '+%Y-%m-%d')"
REPORT_FILE="$HOST_DIR/${REPORT_DATE}.md"
LATEST_FILE="$HOST_DIR/latest.md"

if [ ! -d "$STATUS_REPO/.git" ]; then
    echo "Error: $STATUS_REPO is not a git repository" >&2
    exit 1
fi

mkdir -p "$HOST_DIR"

# 1. Gather System Metrics
echo "Gathering system telemetry..."

UPTIME_INFO="$(uptime)"
DISK_INFO="$(df -h /)"
MEM_INFO="$(free -h)"
SYSTEMD_FAILED="$(systemctl --failed --no-pager 2>&1 || true)"
USER_SYSTEMD_FAILED="$(systemctl --user --failed --no-pager 2>&1 || true)"
REBOOT_REQUIRED="No"
if [ -f /var/run/reboot-required ]; then
    REBOOT_REQUIRED="Yes ($(cat /var/run/reboot-required.pkgs 2>/dev/null | tr '\n' ' ' || true))"
fi

# 2. Gather Dev Repository Status (Omnigent)
OMNIGENT_STATUS="N/A"
if [ -d "$HOME/Documents/omnigent/.git" ]; then
    OMNIGENT_BRANCH="$(git -C "$HOME/Documents/omnigent" rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
    OMNIGENT_LAST_COMMIT="$(git -C "$HOME/Documents/omnigent" log -1 --oneline 2>/dev/null || echo 'none')"
    OMNIGENT_DIRTY="$(git -C "$HOME/Documents/omnigent" status --porcelain 2>/dev/null | wc -l)"
    OMNIGENT_STATUS="Branch: $OMNIGENT_BRANCH | Last Commit: $OMNIGENT_LAST_COMMIT | Uncommitted changes: $OMNIGENT_DIRTY files"
fi

# 3. Gather Recent Cron Logs
CRON_LOGS=""
for logfile in "$HOME"/.local/state/cron/*/*.log; do
    if [ -f "$logfile" ]; then
        CRON_LOGS+="$(printf "\n--- Task Log: %s ---\n" "$(basename "$logfile")")"
        CRON_LOGS+="$(tail -n 30 "$logfile")"
        CRON_LOGS+=$'\n'
    fi
done

# 4. Synthesize with Antigravity (agy)
echo "Summarizing system status with agy..."

PROMPT="You are generating an executive weekly health report for the host 'pop' (Pop!_OS Linux) on $REPORT_DATE.
Analyze the following telemetry and produce a clean, beautifully formatted GitHub-flavored Markdown report.

Raw Telemetry:
- Date: $REPORT_DATE
- Uptime: $UPTIME_INFO
- Disk Usage (/):
$DISK_INFO
- Memory:
$MEM_INFO
- Reboot Required: $REBOOT_REQUIRED
- Failed System Services:
$SYSTEMD_FAILED
- Failed User Services:
$USER_SYSTEMD_FAILED
- Omnigent Dev Repo Status: $OMNIGENT_STATUS

Cron Task Logs:
$CRON_LOGS

Report Requirements:
1. Title: # Weekly Status Report: pop ($REPORT_DATE)
2. Status Banner: 🟢 Healthy, 🟡 Warning, or 🔴 Action Needed based on cron errors, low disk space, or failed services.
3. Section 'Cron & Maintenance Scorecard': Summary of all weekly and daily tasks executed, noting pass/fail status and durations.
4. Section 'System Vitals': Concise table or bullet points for Disk, RAM, Uptime, and Reboot flags.
5. Section 'Development Repositories': Status of ~/Documents/omnigent (active branch, sync state).
6. Section 'Action Items': Any manual follow-ups required (or 'None - all systems nominal').
Output ONLY the Markdown document, with no conversational filler."

REPORT_CONTENT="$(agy -p "$PROMPT" --print-timeout 5m0s --dangerously-skip-permissions)"

# 5. Write Report Files
echo "$REPORT_CONTENT" > "$REPORT_FILE"
cp -f "$REPORT_FILE" "$LATEST_FILE"

# 6. Commit and Push to Status Repository
cd "$STATUS_REPO"
git pull --rebase origin main 2>/dev/null || true
git add .
if ! git diff --cached --quiet; then
    git commit -m "chore(pop): weekly status report for $REPORT_DATE"
    git push origin main
    echo "Status report pushed to GitHub successfully."
else
    echo "No changes to commit in status repository."
fi

# 7. Notify Desktop
if command -v notify-send >/dev/null 2>&1; then
    notify-send -a "System Status" "Weekly Report Generated" "Published to GitHub for $REPORT_DATE"
fi
