# AGENT.md

This file provides guidance to AI coding assistants (Antigravity, Claude Code, Gemini CLI, Copilot) when working with code in this repository.

## Repository Overview

Personal dotfiles monorepo supporting **macOS**, **Pop!_OS (Linux)**, and **Ubuntu (WSL2)**. Configs live here as the single source of truth and are deployed via symlinks managed by `setup.sh`.

## Monorepo Layout

- `setup.sh` — Unified installer supporting OS auto-detection, explicit targets (`macos`, `popos`, `ubuntu`), binary dependency installation (`--install-packages`), dry-runs, and safe backups to `~/.dotfiles_backup/`.
- `common/` — Cross-platform configurations shared across all operating systems:
  - `zshrc` → `~/.zshrc` (unified cross-platform zsh config with `$OSTYPE` branching)
  - `nvim/` → `~/.config/nvim/`
  - `starship.toml` → `~/.config/starship.toml`
  - `tmux/` → `~/.config/tmux/` and `~/.tmux.conf`
  - `git/` → `~/.config/git/` and `~/.gitconfig`
  - `kitty/` → `~/.config/kitty/`
  - `fish/` → `~/.config/fish/`
  - `neofetch/` → `~/.config/neofetch/`
  - `emacs/` → `~/.emacs.d/`
  - `michael.sty` → `~/texmf/tex/latex/common/michael.sty`
- `macos/` — macOS workstation specific configs:
  - `skhd/` → `~/.config/skhd/`
- `popos/` — Pop!_OS Linux workstation specific configs:
  - `zathura/` → `~/.config/zathura/`
  - `bin/run-user-cron` → `~/.local/bin/run-user-cron`
  - `systemd/` → `~/.config/systemd/user/` (user-cron@.service, user-cron-{daily,weekly}.timer)
  - `cron/daily/`, `cron/weekly/` → `~/.config/cron/{daily,weekly}/`
- `ubuntu/` — Ubuntu / WSL2 configs:
  - `wsl.conf` — WSL2 configuration template for `/etc/wsl.conf`
- `archive/` — Legacy / inactive configs:
  - `alacritty/` — Alacritty terminal emulator config
  - `sketchybar/` — macOS status bar config & plugins
  - `yabai/` — Tiling window manager config

## Deployment

Deploy using the setup script:
```bash
./setup.sh                    # Auto-detects host OS and symlinks configs
./setup.sh --install-packages # Installs CLI packages (nvim, starship, tmux, etc.)
./setup.sh macos              # Force macOS profile
./setup.sh popos              # Force Pop!_OS profile
./setup.sh ubuntu             # Force Ubuntu / WSL profile
./setup.sh --dry-run          # Preview actions without making changes
```

## Neovim Configuration Architecture

The nvim config lives in `common/nvim/`. Entry point is `common/nvim/init.lua`, which:
1. Sets `maplocalleader = "\\"` before anything else
2. Bootstraps lazy.nvim
3. Loads `nvim/lua/config/` (options, keybinds, autocmds)
4. Calls `require("lazy").setup("plugin", ...)` — auto-discovers modules under `nvim/lua/plugin/`

**Plugin module layout** (`common/nvim/lua/plugin/`):
- `editor/` — completion (blink.cmp), snippets (LuaSnip), telescope, gitsigns, nnn, mini, surround, autopairs
- `lsp/` — mason, mason-lspconfig, nvim-lspconfig, conform.nvim
- `treesitter/` — nvim-treesitter, treesitter-context
- `latex/` — vimtex, knap
- `ui/` — lualine, bufferline, noice, nvim-notify, indent-blankline, colorizer, which-key, web-devicons
- `colorscheme.lua` — Catppuccin Mocha setup

**Key design decisions:**
- `defaults.lazy = true` — all plugins opt-in to loading; event/cmd/ft triggers required
- blink.cmp is disabled for `tex` files (LuaSnip autosnippets fire without popup interference)
- LSP formatting is delegated entirely to conform.nvim with LSP fallback; format-on-save at 500ms timeout
- Custom snippets live in `nvim/luasnippets/` (tex.lua for math, cpp.lua for competitive programming)
