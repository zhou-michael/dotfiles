#!/usr/bin/env bash
# ==============================================================================
# Michael Zhou's Dotfiles Setup Script
# Unified cross-platform dotfiles installer for macOS, Pop!_OS, and Ubuntu / WSL
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
BACKUP_ROOT="$HOME/.dotfiles_backup/$(date '+%Y%m%d_%H%M%S')"
BACKUP_ENABLED=true
DRY_RUN=false
INSTALL_PACKAGES=false
TARGET_ENV=""

# Terminal formatting
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
  macos        macOS workstation profile (skhd, Homebrew environment)
  popos        Pop!_OS Linux profile (systemd user cron, zathura, Linux paths)
  ubuntu       Ubuntu / WSL profile (WSL interop helpers, wsl.conf reference)

If ENVIRONMENT is omitted, the script automatically detects the host OS.

Options:
  -p, --install-packages  Install core packages and binaries (nvim, tmux, starship, fish, etc.)
  -d, --dry-run           Show what actions would be taken without modifying anything
  --no-backup             Do not create backups of existing files before replacing
  -h, --help              Display this help message and exit
USAGE
    exit 0
}

# Parse CLI options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--install-packages|--packages|--deps)
            INSTALL_PACKAGES=true
            shift
            ;;
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

# Detect environment if not explicitly provided
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
                    TARGET_ENV="popos"
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
if [ "$INSTALL_PACKAGES" = true ]; then
    echo -e "  Packages:    ${BOLD}${GREEN}Enabled (CLI binaries will be installed)${RESET}"
fi
if [ "$DRY_RUN" = true ]; then
    echo -e "  Mode:        ${YELLOW}DRY RUN (no changes will be applied)${RESET}"
fi
echo -e "${BOLD}======================================================${RESET}"

# ==============================================================================
# Helper Functions
# ==============================================================================

link_path() {
    local src="$1"
    local dest="$2"

    if [ ! -e "$src" ]; then
        log_warn "Source does not exist, skipping: $src"
        return 0
    fi

    # Check if dest is already a valid symlink to src
    if [ -L "$dest" ]; then
        local current_target
        current_target="$(readlink "$dest" || true)"
        if [ "$current_target" = "$src" ]; then
            log_info "Already linked: $dest -> $src"
            return 0
        fi
    fi

    # Handle existing target
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

install_packages() {
    log_step "Installing System Packages & Binaries"
    mkdir -p "$HOME/.local/bin"

    if [ "$TARGET_ENV" = "macos" ]; then
        if ! command -v brew >/dev/null 2>&1; then
            log_warn "Homebrew is not installed. Installing Homebrew..."
            if [ "$DRY_RUN" = false ]; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || true)"
            fi
        fi

        log_info "Installing macOS CLI utilities via Homebrew..."
        local BREW_PACKAGES=(
            neovim
            tmux
            starship
            fish
            ripgrep
            fd
            fzf
            uv
        )
        if [ "$DRY_RUN" = false ]; then
            brew install "${BREW_PACKAGES[@]}" || log_warn "Some brew packages may have failed"
        else
            log_info "[Dry-Run] Would run: brew install ${BREW_PACKAGES[*]}"
        fi

    elif [ "$TARGET_ENV" = "popos" ] || [ "$TARGET_ENV" = "ubuntu" ]; then
        log_info "Installing Linux apt packages..."
        local APT_PACKAGES=(
            tmux
            zsh
            fish
            ripgrep
            fd-find
            fzf
            curl
            wget
            git
            build-essential
            wl-clipboard
            xclip
        )
        if [ "$TARGET_ENV" = "popos" ]; then
            APT_PACKAGES+=(zathura zathura-pdf-poppler)
        fi

        if [ "$DRY_RUN" = false ]; then
            if command -v sudo >/dev/null 2>&1; then
                sudo apt-get update
                sudo apt-get install -y "${APT_PACKAGES[@]}" || log_warn "Some apt packages failed to install"
            else
                log_warn "sudo not available; skipping apt installation."
            fi

            # Ensure fd command is available if package was installed as fdfind
            if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
                ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
                log_success "Aliased fdfind -> ~/.local/bin/fd"
            fi
        else
            log_info "[Dry-Run] Would run: sudo apt-get update && sudo apt-get install -y ${APT_PACKAGES[*]}"
        fi

        # Modern Neovim (v0.10+): Ubuntu/Pop!_OS apt provides outdated nvim (0.6), so install official release directly into ~/.local/
        log_info "Installing latest official Neovim release to ~/.local/..."
        if [ "$DRY_RUN" = false ]; then
            local NVIM_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
            local TEMP_NVIM="/tmp/nvim-linux-x86_64.tar.gz"
            if curl -sSL "$NVIM_URL" -o "$TEMP_NVIM"; then
                tar -xzf "$TEMP_NVIM" --strip-components=1 -C "$HOME/.local"
                rm -f "$TEMP_NVIM"
                log_success "Installed Neovim $("$HOME/.local/bin/nvim" --version | head -n 1)"
            else
                log_warn "Failed to download Neovim from GitHub release"
            fi
        else
            log_info "[Dry-Run] Would download and extract latest Neovim tarball to ~/.local"
        fi

        # Starship cross-shell prompt
        if ! command -v starship >/dev/null 2>&1 && [ ! -f "$HOME/.local/bin/starship" ]; then
            log_info "Installing Starship prompt to ~/.local/bin..."
            if [ "$DRY_RUN" = false ]; then
                curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
                log_success "Installed Starship"
            else
                log_info "[Dry-Run] Would install Starship to ~/.local/bin"
            fi
        fi

        # Astral uv
        if ! command -v uv >/dev/null 2>&1 && [ ! -f "$HOME/.local/bin/uv" ]; then
            log_info "Installing Astral uv..."
            if [ "$DRY_RUN" = false ]; then
                curl -LsSf https://astral.sh/uv/install.sh | sh
                log_success "Installed uv"
            else
                log_info "[Dry-Run] Would install uv via official install script"
            fi
        fi
    fi
}

# Run package installation if requested
if [ "$INSTALL_PACKAGES" = true ]; then
    install_packages
fi

# ==============================================================================
# Symlink Dotfiles
# ==============================================================================

# 1. Common Configurations
log_step "Installing Common Configurations (All Platforms)"

# Unified Shell Configs
link_path "$DOTFILES_DIR/common/zshrc" "$HOME/.zshrc"
link_path "$DOTFILES_DIR/common/fish" "$HOME/.config/fish"

# Terminal and CLI Tools
link_path "$DOTFILES_DIR/common/starship.toml" "$HOME/.config/starship.toml"
link_path "$DOTFILES_DIR/common/nvim" "$HOME/.config/nvim"
link_path "$DOTFILES_DIR/common/tmux" "$HOME/.config/tmux"
link_path "$DOTFILES_DIR/common/tmux/tmux.conf" "$HOME/.tmux.conf"
link_path "$DOTFILES_DIR/common/git/config" "$HOME/.gitconfig"
link_path "$DOTFILES_DIR/common/git" "$HOME/.config/git"
link_path "$DOTFILES_DIR/common/kitty" "$HOME/.config/kitty"
link_path "$DOTFILES_DIR/common/alacritty" "$HOME/.config/alacritty"
link_path "$DOTFILES_DIR/common/neofetch" "$HOME/.config/neofetch"
link_path "$DOTFILES_DIR/common/emacs" "$HOME/.emacs.d"

# LaTeX Macros
link_path "$DOTFILES_DIR/common/michael.sty" "$HOME/texmf/tex/latex/common/michael.sty"

# 2. Environment-Specific Configurations
case "$TARGET_ENV" in
    macos)
        log_step "Installing macOS Configurations"
        link_path "$DOTFILES_DIR/macos/skhd" "$HOME/.config/skhd"
        ;;

    popos)
        log_step "Installing Pop!_OS / Linux Configurations"
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

# Shell reload recommendations
CURRENT_SHELL="$(basename "${SHELL:-bash}")"
echo -e "\nTo activate your shell environment:"
if [ "$CURRENT_SHELL" = "fish" ] || command -v fish >/dev/null 2>&1; then
    echo -e "  Fish: ${BOLD}exec fish${RESET} or ${BOLD}source ~/.config/fish/config.fish${RESET}"
fi
if [ "$CURRENT_SHELL" = "zsh" ] || command -v zsh >/dev/null 2>&1; then
    echo -e "  Zsh:  ${BOLD}exec zsh${RESET}  or ${BOLD}source ~/.zshrc${RESET}"
fi
if [ "$INSTALL_PACKAGES" = false ]; then
    echo -e "\n${CYAN}Tip:${RESET} Run ${BOLD}./setup.sh --install-packages${RESET} to automatically install Neovim, Starship, and CLI tools."
fi
