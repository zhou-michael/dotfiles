# Michael Zhou's Dotfiles

Unified, cross-platform configuration monorepo supporting **macOS**, **Pop!_OS (Linux)**, and **Ubuntu (WSL2)**.

All configurations are organized into a modular monorepo and symlinked to their target home/config directories via an automated installer (`setup.sh`).

---

## 📁 Repository Structure

```text
dotfiles/
├── setup.sh                 # Unified installer with OS auto-detection & safe backups
├── README.md                # Documentation & architecture overview
├── CLAUDE.md                # Agent instructions and configuration reference
│
├── common/                  # Cross-platform configurations (all environments)
│   ├── zshrc                # Modular base zshrc (oh-my-zsh, starship, vi mode, local hook)
│   ├── starship.toml        # Starship cross-shell prompt
│   ├── nvim/                # Modern Neovim (Lazy.nvim, Blink.cmp, Conform, LuaSnip)
│   ├── tmux/                # Tmux configuration (Catppuccin theme, vim navigation)
│   ├── git/                 # Git user configuration (nvim editor default)
│   ├── kitty/               # Kitty terminal emulator configuration
│   ├── alacritty/           # Alacritty terminal emulator configuration
│   ├── fish/                # Fish shell functions, completions, and config
│   ├── neofetch/            # Neofetch system info display
│   ├── emacs/               # Emacs configuration
│   └── michael.sty          # LaTeX macros package for academic math & probability
│
├── macos/                   # macOS workstation specific
│   ├── zshrc.local          # Homebrew paths, Postgres 16, Juliaup environment
│   └── skhd/                # Modal hotkey daemon configuration
│
├── popos/                   # Pop!_OS / Linux workstation specific
│   ├── zshrc.local          # Linux PATH and local environment hooks
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
│   ├── wsl.conf             # WSL2 configuration (systemd=true, interop, automount)
│   └── zshrc.local          # WSL environment & Windows interoperability helpers
│
└── archive/                 # Archived configurations
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
# Auto-detects macOS, Pop!_OS, or Ubuntu / WSL
./setup.sh
```

### Explicit Environments

You can explicitly target a specific profile regardless of the host OS:

```bash
./setup.sh macos     # Deploy macOS profile (skhd, homebrew & environment paths)
./setup.sh popos     # Deploy Pop!_OS profile (systemd timers, user cron, etc.)
./setup.sh ubuntu    # Deploy Ubuntu / WSL profile (WSL interop helpers, etc.)
```

### Installer Options

- `-d`, `--dry-run`: Preview all symlinks and backups without modifying any files.
- `--no-backup`: Overwrite existing files directly without creating a backup archive.
- `-h`, `--help`: Display the usage manual.

```bash
# Dry run example
./setup.sh --dry-run
```

> **Safe Deployments:** If a destination file or directory already exists and is not already linked to this repository, `setup.sh` safely moves it to a timestamped backup directory at `~/.dotfiles_backup/<timestamp>/` before creating the symlink.

---

## ⚙️ Modular Shell Architecture

Both macOS and Linux share `common/zshrc`, which handles:
- Oh-My-Zsh bootstrapping & plugins (`git`, `zsh-autosuggestions`, `zsh-syntax-highlighting`)
- Starship prompt initialization
- Vi mode (`set -o vi`, `bindkey '^f' autosuggest-accept`)
- Portable aliases (`rm="rm -i"`) and functions (`mkcd`)
- Sourcing `$HOME/.zshrc.local` if it exists

Machine-specific variables (such as `/opt/homebrew` on macOS or WSL helpers on Ubuntu) live exclusively in each environment's `zshrc.local` and are symlinked to `~/.zshrc.local`.

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
