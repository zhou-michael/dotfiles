#!/usr/bin/env bash
# ==============================================================================
# dotfiles setup script
# Unified cross-platform dotfiles installer for macOS, Pop!_OS, and Ubuntu / WSL
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
BACKUP_ROOT="$HOME/.dotfiles_backup/$(date '+%Y%m%d_%H%M%S')"
BACKUP_ENABLED=true
DRY_RUN=false
TARGET_ENV=""

# Colors for terminal output
BOLD="\033[1m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
RED="\033[0;31m"
RESET="\033[0m"

log_info()    { echo -e "${CYAN}[INFO]${RESET} $*"; }
log_success() { echo -e "${GREEN}[OK]${RESET}   $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${RESET} $*"; }
log_error()   { echo -e "${RED}[ERR]${RESET}  $*"; }
log_step()    { echo -e "\n${BOLD}${BLUE}==>${RESET} ${BOLD}$*${RESET}"; }

usage() {
    cat << USAGE
Usage: $0 [OPTIONS] [ENVIRONMENT]

Environments:
  macos        macOS workstation setup (skhd, yabai, sketchybar, homebrew paths)
  popos        Pop!_OS Linux setup (systemd user cron timers, local runner, Linux paths)
  ubuntu       Ubuntu / WSL setup (WSL interop helpers, wsl.conf reference)

If ENVIRONMENT is omitted, the script automatically detects the host OS.

Options:
  -d, --dry-run      Show what actions would be taken without modifying anything
  --no-backup        Do not create backups of existing files before replacing
  -h, --help         Display this help message and exit
USAGE
    exit 0
}

# Parse options and arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        --no-backup)
            BACKUP_ENABLED=false
            shift
            ;;
        -h|--help)
            usage
            ;;
        macos|popos|ubuntu)
            TARGET_ENV="$1"
            shift
            ;;
        *)
            log_error "Unknown option or environment: $1"
            usage
            ;;
    esac
done

# Detect environment if not explicitly set
if [ -z "$TARGET_ENV" ]; then
    OS="$(uname -s)"
    case "$OS" in
        Darwin)
            TARGET_ENV="macos"
            ;;
        Linux)
            if [ -f /etc/os-release ]; then
                # shellcheck source=/dev/null
                . /etc/os-release
                if [[ "${ID:-}" == "pop" ]] || [[ "${NAME:-}" =~ Pop ]]; then
                    TARGET_ENV="popos"
                elif [[ "${ID:-}" == "ubuntu" ]] || grep -qi microsoft /proc/version 2>/dev/null; then
                    TARGET_ENV="ubuntu"
                else
                    TARGET_ENV="popos" # Default Linux profile
                fi
            elif grep -qi microsoft /proc/version 2>/dev/null; then
                TARGET_ENV="ubuntu"
            else
                TARGET_ENV="popos"
            fi
            ;;
        *)
            log_error "Unsupported OS kernel: $OS. Please specify macos, popos, or ubuntu."
            exit 1
            ;;
    esac
fi

echo -e "${BOLD}======================================================${RESET}"
echo -e "${BOLD}  Michael Zhou's Dotfiles Installer${RESET}"
echo -e "  Repository:  ${DOTFILES_DIR}"
echo -e "  Environment: ${BOLD}${CYAN}${TARGET_ENV}${RESET}"
if [ "$DRY_RUN" = true ]; then
    echo -e "  Mode:        ${YELLOW}DRY RUN (no changes will be applied)${RESET}"
fi
echo -e "${BOLD}======================================================${RESET}"

# Safe symlink function: handles backups and skips existing valid symlinks
link_path() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        log_warn "Source does not exist, skipping: $src"
        return 0
    fi

    # Check if dest is already symlinked to src
    if [ -L "$dest" ]; then
        local current_target
        current_target="$(readlink "$dest" || true)"
        if [ "$current_target" = "$src" ]; then
            log_info "Already linked: $dest -> $src"
            return 0
        fi
    fi

    # Handle existing file/directory/symlink at destination
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ "$BACKUP_ENABLED" = true ]; then
            local rel_dest="${dest#$HOME/}"
            local backup_target="$BACKUP_ROOT/$rel_dest"
            if [ "$DRY_RUN" = true ]; then
                log_warn "[Dry-Run] Would back up: $dest -> $backup_target"
            else
                mkdir -p "$(dirname "$backup_target")"
                mv "$dest" "$backup_target"
                log_warn "Backed up: $dest -> $backup_target"
            fi
        else
            if [ "$DRY_RUN" = true ]; then
                log_warn "[Dry-Run] Would overwrite: $dest"
            else
                rm -rf "$dest"
            fi
        fi
    fi

    # Create destination symlink
    if [ "$DRY_RUN" = true ]; then
        log_success "[Dry-Run] Would link: $dest -> $src"
    else
        mkdir -p "$(dirname "$dest")"
        ln -sfn "$src" "$dest"
        log_success "Linked: $dest -> $src"
    fi
}

# 1. Common Configurations
log_step "Installing Common Configurations (All Platforms)"

# Shell
link_path "$DOTFILES_DIR/common/zshrc" "$HOME/.zshrc"

# Terminal and CLI Tools
link_path "$DOTFILES_DIR/common/starship.toml" "$HOME/.config/starship.toml"
link_path "$DOTFILES_DIR/common/nvim" "$HOME/.config/nvim"
link_path "$DOTFILES_DIR/common/tmux" "$HOME/.config/tmux"
link_path "$DOTFILES_DIR/common/tmux/tmux.conf" "$HOME/.tmux.conf"
link_path "$DOTFILES_DIR/common/git/config" "$HOME/.gitconfig"
link_path "$DOTFILES_DIR/common/git" "$HOME/.config/git"
link_path "$DOTFILES_DIR/common/kitty" "$HOME/.config/kitty"
link_path "$DOTFILES_DIR/common/alacritty" "$HOME/.config/alacritty"
link_path "$DOTFILES_DIR/common/fish" "$HOME/.config/fish"
link_path "$DOTFILES_DIR/common/neofetch" "$HOME/.config/neofetch"
link_path "$DOTFILES_DIR/common/emacs" "$HOME/.emacs.d"

# LaTeX Macros
link_path "$DOTFILES_DIR/common/michael.sty" "$HOME/texmf/tex/latex/common/michael.sty"

# 2. Environment-Specific Configurations
case "$TARGET_ENV" in
    macos)
        log_step "Installing macOS Configurations"
        link_path "$DOTFILES_DIR/macos/zshrc.local" "$HOME/.zshrc.local"
        link_path "$DOTFILES_DIR/macos/skhd" "$HOME/.config/skhd"
        ;;

    popos)
        log_step "Installing Pop!_OS / Linux Configurations"
        link_path "$DOTFILES_DIR/popos/zshrc.local" "$HOME/.zshrc.local"
        link_path "$DOTFILES_DIR/popos/zathura" "$HOME/.config/zathura"

        # Task runner binary
        link_path "$DOTFILES_DIR/popos/bin/run-user-cron" "$HOME/.local/bin/run-user-cron"
        if [ "$DRY_RUN" = false ]; then
            chmod +x "$DOTFILES_DIR/popos/bin/run-user-cron"
        fi

        # User Cron task directories and scripts
        mkdir -p "$HOME/.config/cron/daily" "$HOME/.config/cron/weekly"
        for task in "$DOTFILES_DIR/popos/cron/weekly"/*; do
            [ -f "$task" ] || continue
            filename="$(basename "$task")"
            [ "$filename" = ".gitkeep" ] && continue
            chmod +x "$task" 2>/dev/null || true
            link_path "$task" "$HOME/.config/cron/weekly/$filename"
        done

        for task in "$DOTFILES_DIR/popos/cron/daily"/*; do
            [ -f "$task" ] || continue
            filename="$(basename "$task")"
            [ "$filename" = ".gitkeep" ] && continue
            chmod +x "$task" 2>/dev/null || true
            link_path "$task" "$HOME/.config/cron/daily/$filename"
        done

        # Systemd user services and timers
        link_path "$DOTFILES_DIR/popos/systemd/user-cron@.service" "$HOME/.config/systemd/user/user-cron@.service"
        link_path "$DOTFILES_DIR/popos/systemd/user-cron-daily.timer" "$HOME/.config/systemd/user/user-cron-daily.timer"
        link_path "$DOTFILES_DIR/popos/systemd/user-cron-weekly.timer" "$HOME/.config/systemd/user/user-cron-weekly.timer"

        if command -v systemctl >/dev/null 2>&1; then
            if [ "$DRY_RUN" = true ]; then
                log_info "[Dry-Run] Would reload user systemd daemon and enable user-cron timers"
            else
                log_info "Reloading systemd user daemon and enabling user-cron timers..."
                systemctl --user daemon-reload || log_warn "Failed to reload systemd user daemon"
                systemctl --user enable --now user-cron-daily.timer user-cron-weekly.timer || log_warn "Failed to enable user cron timers"
                log_success "Systemd user timers activated"
            fi
        fi
        ;;

    ubuntu)
        log_step "Installing Ubuntu / WSL Configurations"
        link_path "$DOTFILES_DIR/ubuntu/zshrc.local" "$HOME/.zshrc.local"
        if [ -f "$DOTFILES_DIR/ubuntu/wsl.conf" ]; then
            log_info "WSL config reference available at: $DOTFILES_DIR/ubuntu/wsl.conf"
            log_info "To apply system-wide WSL configuration in Windows Subsystem for Linux:"
            log_info "  sudo cp \"$DOTFILES_DIR/ubuntu/wsl.conf\" /etc/wsl.conf"
        fi
        ;;
esac

log_step "Installation Summary"
if [ "$BACKUP_ENABLED" = true ] && [ -d "$BACKUP_ROOT" ]; then
    log_warn "Backups of replaced files were saved to: $BACKUP_ROOT"
fi
log_success "Dotfiles setup completed for [${TARGET_ENV}]!"
echo -e "\nTo activate your new shell environment, run:"
echo -e "  ${BOLD}exec zsh${RESET}  or  ${BOLD}source ~/.zshrc${RESET}\n"
