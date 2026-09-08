# Neovim Configuration

**Plugin manager:** lazy.nvim — all plugins lazy-load unless marked `lazy = false`.
**Colorscheme:** catppuccin-mocha
**Target use cases:** LaTeX authoring, C++, Python, Rust, Go, TypeScript, general editing.

---

## Quick reference

| Area | Plugin |
|------|--------|
| Completion | blink.cmp |
| Snippets | LuaSnip + custom `luasnippets/` |
| LSP | mason + mason-lspconfig + nvim-lspconfig |
| Formatting | conform.nvim |
| Fuzzy find | telescope.nvim + fzf-native |
| File manager | nnn.nvim |
| Syntax | nvim-treesitter |
| Git | gitsigns.nvim |
| Surround | nvim-surround |
| Comments | mini.comment |
| Status line | lualine.nvim |
| Notifications | nvim-notify |
| LaTeX | vimtex |

---

## Plugins

### Package manager

**[folke/lazy.nvim](https://github.com/folke/lazy.nvim)**
- `defaults.lazy = true` — opt-in loading for all plugins
- `ui.border = "rounded"`

---

### LSP

**[williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)**
- Rounded border UI
- Installs and manages LSP servers, linters, and formatters

**[williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)**
Auto-installs the following servers on first launch:

| Language | Server |
|----------|--------|
| Lua | `lua_ls` |
| C / C++ | `clangd` (with `--background-index`, `--clang-tidy`) |
| Python | `pyright` (basic type-checking, auto-imports) |
| TypeScript / JavaScript | `ts_ls` (inlay hints) |
| Rust | `rust_analyzer` (clippy on save) |
| Go | `gopls` (staticcheck, unused params) |
| Bash | `bashls` |
| JSON | `jsonls` |
| YAML | `yamlls` |
| HTML | `html` |
| CSS | `cssls` |
| Markdown | `marksman` |
| LaTeX | `texlab` (chktex diagnostics; vimtex handles compilation) |

**[neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)**
- Capabilities provided by blink.cmp
- Formatting via conform.nvim with LSP fallback

---

### Completion

**[Saghen/blink.cmp](https://github.com/Saghen/blink.cmp)**
- Native Rust fuzzy matching — faster than nvim-cmp
- Sources: LSP → Path → Snippets → Buffer
- Snippet integration: LuaSnip
- Disabled for `tex` files (LuaSnip autosnippets work without the popup)
- Disabled during macro recording/execution and in prompt buffers
- Signature help enabled

---

### Snippets

**[L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)**
- `enable_autosnippets = true` — snippets fire as you type without manual trigger
- Loads [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets) (VSCode snippet collection)
- Loads custom Lua snippets from `luasnippets/` (see below)
- `<Tab>` / `<S-Tab>` jump forward/backward through tabstops
- `<C-l>` cycle through choice nodes

**Custom snippet files (`luasnippets/`):**

| File | Filetype | Contents |
|------|----------|----------|
| `tex.lua` | tex | Full math snippet suite (see LaTeX section) |
| `cpp.lua` | cpp | `compprog`, `fastio`, `header` |
| `lua.lua` | lua | `lsp` (lspconfig setup template) |

---

### Formatting

**[stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)**
Format-on-save (500 ms timeout) with LSP fallback.

| Filetype | Formatter |
|----------|-----------|
| Lua | stylua |
| Python | black + isort |
| JS / TS / JSON / YAML / HTML / CSS / Markdown | prettier |
| C / C++ | clang-format |
| Rust | rustfmt |
| Go | gofmt |
| Shell | shfmt |

Install formatters via Mason (`:MasonInstall stylua black prettier clang-format shfmt`).

---

### Treesitter

**[nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**
- Installed parsers: bash, c, cpp, diff, html, javascript, jsdoc, json, jsonc, lua, luadoc, luap, markdown, markdown_inline, python, query, regex, toml, tsx, typescript, vim, vimdoc, yaml
- Highlight, indent enabled
- Treesitter-based folding (`foldmethod = expr`)
- Incremental selection: `<C-a>` expand, `<BS>` shrink

**[nvim-treesitter/nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)**
- Shows enclosing function/class at top of screen (VSCode-style breadcrumbs)
- `max_lines = 3`, separator `─`

**[nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)**
- Text objects for functions, classes, parameters

---

### Fuzzy Finder

**[nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)**
- `ascending` sort with prompt at top
- Hidden files included in `find_files`
- `<C-j>` / `<C-k>` navigate results in insert mode
- `<Esc>` closes picker (no need for double-`<Esc>`)

**[nvim-telescope/telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)**
- Native fzf sorting algorithm — significant performance improvement on large repos

---

### File Manager

**[luukvbaal/nnn.nvim](https://github.com/luukvbaal/nnn.nvim)**
- Explorer: `nnn -AHo` (hidden files, auto-open), width 36, top-left
- Picker: `nnn -AHdo`, 90% × 80% centered dialog, rounded border
- Auto-opens when Neovim is given a directory argument
- Window actions: `<C-t>` tab, `<C-s>` split, `<C-v>` vsplit, `<C-p>` preview

---

### Editor Enhancements

**[windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)**
- Reactively inserts closing pair on `(`, `[`, `{`, `"`, `'`

**[kylechui/nvim-surround](https://github.com/kylechui/nvim-surround)**
- Operates on *existing* text in normal mode — no conflict with autopairs
- `ys{motion}{char}` — surround, e.g. `ysiw(` wraps word in parens
- `cs{old}{new}` — change surrounding, e.g. `cs([` changes `()` to `[]`
- `ds{char}` — delete surrounding, e.g. `ds"` removes quotes

**[lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)**
- Inline change indicators in the sign column
- Hunk-level stage, reset, preview, blame, diff

**[echasnovski/mini.comment](https://github.com/echasnovski/mini.comment)**
- `gcc` — toggle current line comment
- `gc{motion}` — toggle comment over motion

**[echasnovski/mini.ai](https://github.com/echasnovski/mini.ai)**
- Extended `a`/`i` text objects for functions, classes, arguments, etc.

**[echasnovski/mini.move](https://github.com/echasnovski/mini.move)**
- `<M-h/j/k/l>` — move current line or visual selection in any direction

**[echasnovski/mini.bufremove](https://github.com/echasnovski/mini.bufremove)**
- Close buffer without closing the window

---

### UI

**[catppuccin/nvim](https://github.com/catppuccin/nvim)** — active (mocha flavor)
**[folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)** — inactive alternative

**[nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)**
- `a`: mode | `b`: branch, diff | `c`: filename, diagnostics
- `x`: encoding, format, filetype | `y`: progress | `z`: location

**[lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)**
- Char `│`, scope highlight on `Function`

**[rcarriga/nvim-notify](https://github.com/rcarriga/nvim-notify)**
- Render: minimal, animation: fade

**[NvChad/nvim-colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)**
- Previews hex colors, RGB, CSS color functions in all filetypes

**[folke/which-key.nvim](https://github.com/folke/which-key.nvim)**
- Shows available keybind completions 400 ms after pressing a leader key
- Groups: `<leader>h` (git), `<leader>f` (telescope), `<leader>b` (buffer), `<space>` (lsp)

**[folke/noice.nvim](https://github.com/folke/noice.nvim)** — available but disabled
**[akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)** — available but disabled

---

### LaTeX

**[lervag/vimtex](https://github.com/lervag/vimtex)**
- PDF viewer: sioyek
- Compiler: latexmk, output to `build/`
- Skim sync + reading bar
- Concealing: `abdmgs`

---

## Editor settings

| Option | Value | Effect |
|--------|-------|--------|
| `number` + `relativenumber` | true | Hybrid line numbers |
| `tabstop` / `shiftwidth` | 4 | 4-space indentation |
| `expandtab` | true | Spaces, not tabs |
| `wrap` | false | No line wrapping |
| `textwidth` | 100 | Column limit |
| `foldmethod` | expr (treesitter) | Treesitter-driven folding |
| `foldlevel` | 20 | Files open fully unfolded |
| `spell` | true | Spellcheck on |
| `spelllang` | en_us, cjk | US English + CJK |
| `conceallevel` | 2 | LaTeX concealment active |
| `undofile` | true | Persistent undo across sessions |
| `undolevels` | 500 | Undo history depth |
| `timeoutlen` | 150 ms | Fast key sequence timeout |
| `scrolloff` | 8 | Keep 8 lines visible above/below cursor |
| `sidescrolloff` | 8 | Keep 8 columns left/right of cursor |
| `splitbelow` / `splitright` | true | Natural split direction |
| `pumblend` | 10 | Popup menu transparency |
| `ignorecase` + `smartcase` | true | Smart search case |
| `mapleader` | `<Space>` | |
| `maplocalleader` | `\` | |

---

## Keybindings

### Global

| Key | Action |
|-----|--------|
| `<Leader>n` | nnn Explorer |
| `<Leader>N` | nnn Explorer (current file's directory) |
| `<Leader>m` | nnn Picker |
| `<Leader>M` | nnn Picker (current file's directory) |
| `<Leader>b` | Next buffer |
| `<Leader>B` | Prev buffer |
| `<Leader>bd` | Delete buffer (keep window) |
| `<Leader>bD` | Force-delete buffer |

### Telescope

| Key | Action |
|-----|--------|
| `<Leader>ff` | Find files |
| `<Leader>fg` | Live grep |
| `<Leader>fb` | Open buffers |
| `<Leader>fh` | Help tags |
| `<Leader>fd` | Diagnostics |
| `<Leader>fr` | LSP references |
| `<Leader>fs` | Document symbols |
| `<Leader>fS` | Workspace symbols |
| `<Leader>fo` | Recent files |
| `<Leader>fw` | Grep word under cursor |
| `<Leader>t` | Open Telescope picker menu |

**Inside Telescope:**

| Key | Action |
|-----|--------|
| `<C-j>` / `<C-k>` | Navigate results |
| `<Esc>` | Close picker |
| `<C-x>` | Open in split |
| `<C-v>` | Open in vsplit |
| `<C-t>` | Open in new tab |

### LSP (active when a server is attached)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Show references |
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `<space>rn` | Rename symbol |
| `<space>ca` | Code action |
| `<space>f` | Format document (conform → LSP fallback) |
| `<space>D` | Type definition |
| `<space>e` | Open diagnostic float |
| `[d` / `]d` | Prev / next diagnostic |
| `<space>q` | Set location list |
| `<space>wa` | Add workspace folder |
| `<space>wr` | Remove workspace folder |
| `<space>wl` | List workspace folders |

### Completion (blink.cmp)

| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger / show documentation |
| `<C-e>` | Close completion menu |
| `<CR>` | Confirm selection |
| `<C-b>` / `<C-f>` | Scroll documentation |

### Snippets (LuaSnip)

| Key | Mode | Action |
|-----|------|--------|
| `<Tab>` | Insert, Select | Jump to next tabstop |
| `<S-Tab>` | Insert, Select | Jump to previous tabstop |
| `<C-l>` | Insert, Select | Cycle choice node |

### Git (gitsigns.nvim)

| Key | Action |
|-----|--------|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage entire buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hR` | Reset entire buffer |
| `<leader>hp` | Preview hunk inline |
| `<leader>hb` | Full blame for current line |
| `<leader>hd` | Diff this file |
| `<leader>hD` | Diff against last commit (~) |
| `<leader>hT` | Toggle inline blame |
| `<leader>hX` | Toggle deleted line display |

### Surround (nvim-surround)

| Key | Mode | Action |
|-----|------|--------|
| `ys{motion}{char}` | Normal | Add surround |
| `yss{char}` | Normal | Surround current line |
| `cs{old}{new}` | Normal | Change surround |
| `ds{char}` | Normal | Delete surround |
| `S{char}` | Visual | Surround selection |

### Comments (mini.comment)

| Key | Mode | Action |
|-----|------|--------|
| `gcc` | Normal | Toggle line comment |
| `gc{motion}` | Normal | Toggle comment over motion |
| `gc` | Visual | Toggle comment on selection |

### Move lines (mini.move)

| Key | Mode | Action |
|-----|------|--------|
| `<M-h/j/k/l>` | Normal | Move current line |
| `<M-h/j/k/l>` | Visual | Move selection |

### Treesitter

| Key | Action |
|-----|--------|
| `<C-a>` | Expand incremental selection |
| `<BS>` | Shrink incremental selection |

---

## LaTeX snippet reference (`luasnippets/tex.lua`)

All math-context snippets only fire inside `\( \)`, `\[ \]`, or math environments (detected via vimtex). Autosnippets fire as you type without pressing any trigger key.

### Document structure (manual)

| Trigger | Expands to |
|---------|-----------|
| `preamble` | Full document skeleton with `michael` package |
| `beg` | `\begin{env}...\end{env}` |
| `asy` | Asymptote figure environment |
| `mm` *(auto)* | `\[ ... \]` display math block |
| `im` *(auto)* | `\( ... \)` inline math |

### Math fonts (auto, math)

| Trigger | Result |
|---------|--------|
| `mbf` | `\mathbf{}` |
| `mrm` | `\mathrm{}` |
| `mbb` | `\mathbb{}` |
| `mcal` | `\mathcal{}` |

### Common subscripts (auto, math)

| Trigger | Result |
|---------|--------|
| `xnn` | `x_{n}` |
| `xii` | `x_{i}` |
| `xjj` | `x_{j}` |
| `xn1` | `x_{n+1}` |
| `x2` | `x_{2}` (any letter + digit) |
| `\alpha2` | `\alpha_{2}` (any Greek command + digit) |
| `_` | `_{...}` wrapper |
| `^` | `^{...}` wrapper |
| `sqre` | `^2` |
| `cube` | `^3` |

### Radicals and roots (math)

| Trigger | Result |
|---------|--------|
| `xsqrt` *(auto)* | `x\sqrt{}` |
| `rt` *(manual)* | `\sqrt[n]{}` |

### Accents (auto, math) — postfix style

Append the accent name after a letter or Greek command:

| Suffix | Result |
|--------|--------|
| `hat` | `\hat{x}` |
| `dot` | `\dot{x}` |
| `ddot` | `\ddot{x}` |
| `bar` | `\bar{x}` |
| `vec` | `\vec{x}` |
| `und` | `\underline{x}` |
| `tild` | `\tilde{x}` |

### Delimiters (auto, math)

| Trigger | Result |
|---------|--------|
| `lrp` | `\left( ... \right)` |
| `lrb` | `\left[ ... \right]` |
| `lrr` | `\left\{ ... \right\}` |
| `lr<` | `\left\langle ... \right\rangle` |
| `lrc` | `\left\lceil ... \right\rceil` |
| `lrf` | `\left\lfloor ... \right\rfloor` |
| `lr\|` | `\left\lvert ... \right\rvert` |

### Number sets (auto, math)

| Trigger | Result |
|---------|--------|
| `RR` | `\mathbb R` |
| `ZZ` | `\mathbb Z` |
| `QQ` | `\mathbb Q` |
| `CC` | `\mathbb C` |
| `NN` | `\mathbb N` |
| `LL` | `\mathcal L` |
| `II` | `\mathbb 1` |

### Derivatives (manual and auto, math)

| Trigger | Result |
|---------|--------|
| `dd` | `\frac{\mathrm d ...}{\mathrm d ...}` |
| `dxdy` *(auto)* | `\frac{\mathrm d x}{\mathrm d y}` |
| `ddx` *(auto)* | `\frac{\mathrm d ...}{\mathrm d x}` |
| `2dd` | Second derivative (manual) |
| `2ddx` *(auto)* | Second derivative in x |
| `2dxdy` *(auto)* | Second derivative x/y |
| `part` | Partial derivative |

### Fractions (auto, math)

| Trigger | Result |
|---------|--------|
| `//` | `\frac{}{}` |
| `3/` | `\frac{3}{}` (any integer) |
| `x^2/` | `\frac{x^2}{}` (word/command expression) |
| `(a+b)/` | `\frac{a+b}{}` (paren expression, stack-aware) |

### Matrices (auto, math)

| Trigger | Result |
|---------|--------|
| `bmat2,3` | 2×3 `\begin{bmatrix}` with tabstops |

### Text in math (manual, math)

| Trigger | Result |
|---------|--------|
| `te` | `\text{}` |
| `tet` | `\texttt{}` |

---

## C++ snippets (`luasnippets/cpp.lua`)

| Trigger | Contents |
|---------|---------|
| `compprog` | Competitive programming template with `setupIO` |
| `fastio` | `ios_base::sync_with_stdio(false); cin.tie(nullptr);` |
| `header` | File header with author, date (auto), assignment, description |

---

## Spell dictionary

118 custom words in `spell/en.utf-8.add`: mathematical terms (eigenvector, homomorphism, cohomology, bijection, covariant, …), domain terms (asymptote, quaternion, subsequence, …).
