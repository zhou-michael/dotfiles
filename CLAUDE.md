# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for macOS, managed manually via Git (no Stow/Ansible). Configs live here as source of truth and are deployed via symlinks to their expected locations.

## Deployment

No install script exists. Configs are manually symlinked. For example:
- `nvim/` → `~/.config/nvim/`
- `fish/` → `~/.config/fish/`
- `kitty/` → `~/.config/kitty/`
- `tmux/tmux.conf` → `~/.tmux.conf`
- `zshrc` → `~/.zshrc`
- `starship.toml` → `~/.config/starship.toml`
- `git/config` → `~/.gitconfig`
- `michael.sty` → somewhere on the LaTeX `TEXINPUTS` path

## Neovim Configuration Architecture

The nvim config is the most complex piece. Entry point is `nvim/init.lua`, which:
1. Sets `maplocalleader = "\\"` before anything else
2. Bootstraps lazy.nvim
3. Loads `nvim/lua/config/` (options, keybinds, autocmds)
4. Calls `require("lazy").setup("plugin", ...)` — this auto-discovers every module under `nvim/lua/plugin/`

**Plugin module layout** (`nvim/lua/plugin/`):
- `editor/` — completion (blink.cmp), snippets (LuaSnip), telescope, gitsigns, nnn, mini, surround, autopairs
- `lsp/` — mason, mason-lspconfig, nvim-lspconfig, conform.nvim
- `treesitter/` — nvim-treesitter, treesitter-context
- `latex/` — vimtex, knap
- `ui/` — lualine, bufferline, noice, nvim-notify, indent-blankline, colorizer, which-key, web-devicons
- `colorscheme.lua` — catppuccin setup

Each subdirectory has an `init.lua` that returns a list of lazy.nvim plugin specs; individual plugin files return a single spec table.

**Key design decisions:**
- `defaults.lazy = true` — all plugins opt-in to loading; event/cmd/ft triggers required
- blink.cmp is disabled for `tex` files (LuaSnip autosnippets fire without popup interference)
- LSP formatting is delegated entirely to conform.nvim with LSP fallback; format-on-save at 500ms timeout
- Custom snippets live in `nvim/luasnippets/` (tex.lua for math, cpp.lua for competitive programming)

## Other Notable Configs

- **sketchybar**: `sketchybar/sketchybarrc` orchestrates the macOS menu bar; plugins in `sketchybar/plugins/` are shell scripts called by sketchybar events
- **yabai + skhd**: tiling WM (`yabairc`) paired with hotkey daemon (`skhdrc`) for window management
- **fish functions**: `mkcd`, `n`/`nn` (nnn wrappers), `sk` (fzf+fd) defined in `fish/functions/`
- **michael.sty**: custom LaTeX package with math macros (probability, linear algebra notation) intended for academic documents
