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
THERMAL_INFO="$(python3 -c '
import glob, os, subprocess

lines = []
for path in sorted(glob.glob("/sys/class/hwmon/hwmon*")):
    name_file = os.path.join(path, "name")
    if not os.path.exists(name_file): continue
    name = open(name_file).read().strip()
    if name in ("k10temp", "coretemp"):
        for f in sorted(glob.glob(os.path.join(path, "temp*_input"))):
            lbl_file = f[:-6] + "_label"
            lbl = open(lbl_file).read().strip() if os.path.exists(lbl_file) else os.path.basename(f[:-6])
            try:
                c = int(open(f).read().strip()) / 1000.0
                lines.append(f"CPU ({lbl}): {c:.1f} °C")
            except: pass
    elif name == "nvme":
        dev_link = os.path.realpath(os.path.join(path, "device"))
        model = "NVMe"
        for m in [os.path.join(dev_link, "model"), *glob.glob(os.path.join(dev_link, "nvme*", "model"))]:
            if os.path.exists(m):
                model = open(m).read().strip()
                break
        for f in sorted(glob.glob(os.path.join(path, "temp*_input"))):
            lbl_file = f[:-6] + "_label"
            lbl = open(lbl_file).read().strip() if os.path.exists(lbl_file) else os.path.basename(f[:-6])
            try:
                c = int(open(f).read().strip()) / 1000.0
                lines.append(f"NVMe [{model}] ({lbl}): {c:.1f} °C")
            except: pass
    elif "wmi" in name or name in ("it87", "nct6775"):
        for f in sorted(glob.glob(os.path.join(path, "temp*_input"))):
            lbl_file = f[:-6] + "_label"
            lbl = open(lbl_file).read().strip() if os.path.exists(lbl_file) else os.path.basename(f[:-6])
            try:
                c = int(open(f).read().strip()) / 1000.0
                lines.append(f"Motherboard ({lbl}): {c:.1f} °C")
            except: pass

try:
    gpu = subprocess.check_output(["nvidia-smi", "--query-gpu=name,temperature.gpu", "--format=csv,noheader"], stderr=subprocess.DEVNULL, text=True).strip()
    if gpu:
        parts = [p.strip() for p in gpu.split(",")]
        lines.append(f"GPU [{parts[0]}]: {parts[1]} °C")
except: pass

print("\n".join(lines) if lines else "No thermal sensors detected")
' 2>/dev/null || echo 'Thermal telemetry unavailable')"

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
- Thermal Vitals:
$THERMAL_INFO
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
2. Status Banner: 🟢 Healthy, 🟡 Warning, or 🔴 Action Needed based on cron errors, low disk space, high thermal warnings, or failed services.
3. Section 'Cron & Maintenance Scorecard': Summary of all weekly and daily tasks executed, noting pass/fail status and durations.
4. Section 'System Vitals': Concise table or bullet points for Disk, RAM, Uptime, and Reboot flags.
5. Section 'Thermal Vitals': Table summarizing CPU, GPU, NVMe, and Motherboard temperatures with health status indicators (🟢 Nominal, 🟡 Elevated, 🔴 Throttle/Critical).
6. Section 'Development Repositories': Status of ~/Documents/omnigent (active branch, sync state).
7. Section 'Action Items': Any manual follow-ups required (or 'None - all systems nominal').
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
