# Michael Zhou's Dotfiles

Unified, cross-platform configuration monorepo supporting **macOS**, **Pop!_OS (Linux)**, and **Ubuntu (WSL2)**.

All configurations are organized into a modular monorepo and symlinked to their target home/config directories via an automated installer (`setup.sh`).

---

## 📁 Repository Structure

```text
dotfiles/
├── setup.sh                 # Unified installer with OS auto-detection & package installer
├── README.md                # Documentation & architecture overview
├── AGENT.md                 # Universal AI agent instructions (source of truth)
├── CLAUDE.md                # -> AGENT.md (symlink for Claude Code)
├── GEMINI.md                # -> AGENT.md (symlink for Gemini / Antigravity)
│
├── common/                  # Cross-platform configurations (all environments)
│   ├── zshrc                # Unified cross-platform zshrc ($OSTYPE branching for macOS/Linux)
│   ├── fish/                # Cross-platform Fish config with safe prompts and dynamic PATH
│   ├── starship.toml        # Starship cross-shell prompt
│   ├── nvim/                # Modern Neovim (Lazy.nvim, Blink.cmp, Conform, LuaSnip)
│   ├── tmux/                # Tmux configuration (Catppuccin theme, vim navigation)
│   ├── git/                 # Git user configuration (nvim editor default)
│   ├── kitty/               # Kitty terminal emulator configuration
│   ├── neofetch/            # Neofetch system info display
│   ├── emacs/               # Emacs configuration
│   └── michael.sty          # LaTeX macros package for academic math & probability
│
├── macos/                   # macOS workstation specific
│   └── skhd/                # Modal hotkey daemon configuration
│
├── popos/                   # Pop!_OS / Linux workstation specific
│   ├── zathura/             # Zathura document viewer configuration
│   ├── bin/
│   │   └── run-user-cron    # Modular user-level cron task runner with notifications
│   ├── systemd/
│   │   ├── user-cron@.service      # Templated systemd user service
│   │   ├── user-cron-daily.timer   # Daily wake-catchup timer (04:00)
│   │   └── user-cron-weekly.timer  # Weekly wake-catchup timer (Sun 03:00)
│   └── cron/
│       ├── daily/           # Drop-in daily executable cron scripts
│       └── weekly/          # Drop-in weekly executable cron scripts
│           ├── 10-omnigent-sync.sh        # Autonomous dev branch rebase & maintenance
│           └── 90-system-weekly-report.sh # System telemetry & weekly report publisher
│
├── ubuntu/                  # Ubuntu / WSL2 specific
│   └── wsl.conf             # WSL2 configuration (systemd=true, interop, automount)
│
└── archive/                 # Archived configurations
    ├── alacritty/           # Alacritty terminal emulator configuration
    ├── sketchybar/          # macOS status bar orchestration and shell plugins
    └── yabai/               # Tiling window manager configuration
```

---

## 🚀 Quickstart & Installation

Clone the repository to your machine:

```bash
git clone git@github.com:zhou-michael/dotfiles.git ~/Documents/dotfiles
cd ~/Documents/dotfiles
```

Run the automated installer:

```bash
# Auto-detects macOS, Pop!_OS, or Ubuntu / WSL and deploys symlinks
./setup.sh

# Automatically install CLI binaries (modern Neovim, Starship, tmux, fish, ripgrep, uv)
./setup.sh --install-packages
```

### Explicit Environments

You can explicitly target a specific profile regardless of the host OS:

```bash
./setup.sh macos     # Deploy macOS profile
./setup.sh popos     # Deploy Pop!_OS profile (zathura, systemd timers, user cron)
./setup.sh ubuntu    # Deploy Ubuntu / WSL profile
```

### Installer Options

- `-p`, `--install-packages`: Automatically installs CLI binaries:
  - **macOS**: Installs `neovim`, `tmux`, `starship`, `fish`, `ripgrep`, `fd`, `fzf`, `uv` via Homebrew.
  - **Linux (Pop!_OS / Ubuntu)**: Installs official release Neovim (v0.10+ without root into `~/.local/`), Starship, uv, and core apt packages (`tmux`, `fish`, `zsh`, `ripgrep`, `fzf`, `zathura`).
- `-d`, `--dry-run`: Preview all symlinks, backups, and commands without modifying anything.
- `--no-backup`: Overwrite existing files directly without creating a backup archive.
- `-h`, `--help`: Display the usage manual.

> **Safe Deployments:** If a destination file or directory already exists and is not already linked to this repository, `setup.sh` safely moves it to a timestamped backup directory at `~/.dotfiles_backup/<timestamp>/` before creating the symlink.

---

## ⚙️ Unified Shell Architecture (Zsh & Fish)

### Zsh (`common/zshrc` &rarr; `~/.zshrc`)
- **Shared Base**: Oh-My-Zsh bootstrapping, plugins (`git`, `zsh-autosuggestions`, `zsh-syntax-highlighting`), Starship prompt, vi mode, and portable aliases (`mkcd`, `rm="rm -i"`).
- **Dynamic `$OSTYPE` Branching**:
  - `darwin*`: Automatically adds `/opt/homebrew`, Postgres 16 variables, Jupyter path, and Juliaup.
  - `linux*`: Automatically configures WSL2 clipboard (`clip.exe`) and explorer shortcuts when running under WSL.
- **Local Hook**: Optionally sources `~/.zshrc.local` if present for private, machine-specific keys or tokens.

### Fish (`common/fish` &rarr; `~/.config/fish`)
- Fully cross-platform interactive shell configuration.
- Uses `fish_add_path` to dynamically discover `/opt/homebrew/bin`, `~/.local/bin`, and Juliaup.
- Defensively checks tool existence before sourcing hooks (`starship init fish`, `direnv hook fish`).

---

## ⏱️ Linux Systemd User Cron Framework (Pop!_OS)

The Pop!_OS profile includes a user-level cron runner that executes without root permissions and automatically handles machine sleep/wake catch-up using systemd user timers (`Persistent=true`).

- **Runner**: `~/.local/bin/run-user-cron <interval>` executes each script in order, logs to `~/.local/state/cron/<interval>/<task>.log`, and sends desktop alerts on failure via `notify-send`.
- **Systemd Units**:
  - `user-cron@.service`: Templated oneshot service using `%h` home directory expansion.
  - `user-cron-daily.timer`: Fires daily at 04:00.
  - `user-cron-weekly.timer`: Fires Sundays at 03:00.
- **Active Tasks**:
  - `10-omnigent-sync.sh`: Headless AI agent maintenance that rebases active branches, resolves conflicts, runs unit tests, and refreshes dependencies.
  - `90-system-weekly-report.sh`: Telemetry scraper that compiles system health and pushes executive weekly Markdown reports to [`zhou-michael/status`](https://github.com/zhou-michael/status).

---

## ⌨️ Neovim Configuration

The Neovim config in `common/nvim` uses `lazy.nvim` with lazy-loading enabled by default:
- **Completion**: `blink.cmp` (opt-out on `.tex` to let LuaSnip autosnippets take precedence)
- **Formatting**: `conform.nvim` with LSP fallback and format-on-save
- **LSP**: `mason.nvim`, `mason-lspconfig`, and `nvim-lspconfig`
- **Syntax**: `nvim-treesitter` and `treesitter-context`
- **UI & Theme**: Catppuccin Mocha, `lualine`, `bufferline`, `noice.nvim`, `which-key`
- **LaTeX**: `vimtex`, `knap`, and custom math snippets in `nvim/luasnippets/tex.lua`
