# Neovim Configuration Review

## Overview

Plugin manager: **lazy.nvim** with lazy loading enabled by default.
Total plugins: ~33 (including disabled ones).

---

## Plugins & Settings

### Package Manager

**[folke/lazy.nvim](https://github.com/folke/lazy.nvim)**
- `defaults.lazy = true` — all plugins lazy-load unless specified
- `ui.border = "rounded"`

---

### LSP

**[williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)**
- Rounded border UI
- Installs/manages LSP servers, linters, formatters

**[williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)**
- Bridges mason and nvim-lspconfig
- `ensure_installed`: lua_ls, clangd, pyright

**[neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)**
- Configured servers: `lua_ls`, `clangd`, `pyright`
- `lua_ls`: globals include `vim` for Neovim config editing
- All servers receive cmp capabilities via `cmp_nvim_lsp`
- LSP keybindings (on attach):
  - `gd` — go to definition
  - `gD` — go to declaration
  - `gi` — go to implementation
  - `gr` — show references
  - `K` — hover documentation
  - `<C-k>` — signature help
  - `<space>rn` — rename symbol
  - `<space>ca` — code action
  - `<space>f` — format document (async)
  - `<space>e` — open diagnostic float
  - `[d` / `]d` — prev/next diagnostic
  - `<space>D` — type definition
  - `<space>wa/wr/wl` — workspace folder management

---

### Completion

**[hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)**
- Completion sources (in priority order): `nvim_lsp`, `luasnip`, `ultisnips`, `buffer`
- Kind icons with nerd font glyphs
- Menu labels: `[lsp]`, `[snp]`, `[buf]`, `[lua]`, `[ltx]`
- Cmdline completion: buffer for `/`/`?`, path + cmdline for `:`
- Mappings:
  - `<C-b>` / `<C-f>` — scroll docs
  - `<C-Space>` — trigger completion
  - `<C-e>` — abort
  - `<CR>` — confirm

**[hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)** — LSP source
**[hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer)** — buffer words
**[hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path)** — filesystem paths
**[hrsh7th/cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)** — command-line mode
**[quangnguyen30192/cmp-nvim-ultisnips](https://github.com/quangnguyen30192/cmp-nvim-ultisnips)** — UltiSnips source
**[saadparwaiz1/cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)** — LuaSnip source

---

### Snippets

**[SirVer/ultisnips](https://github.com/SirVer/ultisnips)** — primary snippet engine
- `<Tab>` — expand snippet
- `<C-c>` — jump forward
- `<C-x>` — jump backward
- Custom snippet files: `UltiSnips/tex.snippets`, `cpp.snippets`, `lua.snippets`
- Extensive LaTeX math snippets (Greek letters, auto-fractions, matrices, environments)

**[L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)** — secondary engine (jsregexp build dep)

**[rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)** — VSCode snippet collection

---

### Treesitter

**[nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**
- Installed parsers: bash, c, cpp, diff, html, javascript, jsdoc, json, jsonc, lua, luadoc, luap, markdown, markdown_inline, python, query, regex, toml, tsx, typescript, vim, vimdoc, yaml
- Highlight, indent enabled
- Folding via `nvim_treesitter#foldexpr()`
- Incremental selection: `<C-a>` expand, `<BS>` shrink

**[nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)** — text objects

**[nvim-treesitter/nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)** — disabled

---

### Fuzzy Finder

**[nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)**
- `<Leader>t` — open Telescope

**[nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** — dependency

---

### File Manager

**[luukvbaal/nnn.nvim](https://github.com/luukvbaal/nnn.nvim)**
- Explorer: `nnn -AHo`, width 36, top-left, fullscreen on empty tab
- Picker: `nnn -AHdo`, 90% × 80% centered dialog, rounded border
- `<Leader>n` — explorer, `<Leader>N` — explorer in cwd
- `<Leader>m` — picker, `<Leader>M` — picker in cwd
- Window actions: `<C-t>` tab, `<C-s>` split, `<C-v>` vsplit, `<C-p>` preview

---

### Editor Enhancements

**[windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)** — auto-close brackets/quotes

**[nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)** — disabled

**[ms-jpq/coq_nvim](https://github.com/ms-jpq/coq_nvim)** — disabled (alternative completion)

---

### UI

**[catppuccin/nvim](https://github.com/catppuccin/nvim)** — active colorscheme (mocha flavor)

**[folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim)** — inactive alternative

**cha** — local custom colorscheme (`~/Documents/beepboop/cha`)

**[nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)**
- Sections: mode | branch+diff | filename+diagnostics | encoding+format+filetype | progress | location
- Nerd font separators

**[lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)**
- Char: `│`, scope highlight: `Function`

**[rcarriga/nvim-notify](https://github.com/rcarriga/nvim-notify)**
- Render: minimal, animation: fade

**[norcalli/nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua)**
- Active only for Lua files

**[folke/noice.nvim](https://github.com/folke/noice.nvim)**
- Messages and notifications disabled; LSP hover markdown rendering enabled

**[akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)** — disabled

**[nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)** — icons

**[MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim)** — UI component library

---

### LaTeX

**[lervag/vimtex](https://github.com/lervag/vimtex)**
- Viewer: sioyek
- Compiler: latexmk, output to `build/`
- Concealing: `abdmgs`
- Skim sync + reading bar enabled

**[frabjous/knap](https://github.com/frabjous/knap)** — disabled

---

### Editor Options (`config/options.lua`)

| Option | Value | Note |
|--------|-------|------|
| `number` + `relativenumber` | true | Hybrid line numbers |
| `tabstop` / `shiftwidth` | 4 | 4-space indentation |
| `expandtab` | true | Spaces, not tabs |
| `wrap` | false | No line wrapping |
| `textwidth` | 100 | Column limit |
| `foldmethod` | expr (treesitter) | Treesitter-driven folding |
| `foldlevel` | 20 | Start unfolded |
| `spell` | true | Spellcheck on |
| `spelllang` | en_us, cjk | English + CJK |
| `conceallevel` | 2 | Conceal enabled |
| `undofile` | true | Persistent undo |
| `undolevels` | 500 | Undo history depth |
| `timeoutlen` | 150 ms | Fast key timeout |
| `scrolloff` | 1 | Lines kept above/below |
| `sidescrolloff` | 8 | Columns kept left/right |
| `splitbelow` / `splitright` | true | Natural split direction |
| `pumblend` | 10 | Popup transparency |
| `showmode` | false | Mode hidden (lualine shows it) |
| `ignorecase` + `smartcase` | true | Smart search case |
| `mapleader` | `<Space>` | |
| `maplocalleader` | `\` | |

---

## Suggestions

### 1. Replace nvim-cmp with blink.cmp

**nvim-cmp** is aging; [**blink.cmp**](https://github.com/Saghen/blink.cmp) is a drop-in replacement written in Rust with significantly faster completion, better fuzzy matching, and a simpler config. It also has first-class support for snippets and LSP without needing separate source plugins.

**Steps:**
1. Remove `nvim-cmp` and all its source plugins (`cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp-cmdline`, `cmp-nvim-ultisnips`, `cmp_luasnip`) from `lua/plugin/lsp/`.
2. Add blink.cmp:
   ```lua
   {
     "Saghen/blink.cmp",
     event = "InsertEnter",
     version = "*",
     opts = {
       keymap = { preset = "default" },
       appearance = { use_nvim_web_devicons = true },
       sources = { default = { "lsp", "path", "snippets", "buffer" } },
       snippets = { preset = "luasnip" }, -- or "default" if dropping UltiSnips
     },
   }
   ```
3. Update LSP capabilities in `mason-lspconfig.lua`:
   ```lua
   local capabilities = require("blink.cmp").get_lsp_capabilities()
   ```
4. The cmdline completion, kind icons, and menu sources are handled automatically.

---

### 2. Expand LSP server coverage

Currently only `lua_ls`, `clangd`, and `pyright` are configured. For a genuine VSCode replacement add servers for the languages you use:

| Language | Server | Mason name |
|----------|--------|------------|
| TypeScript/JavaScript | `ts_ls` (formerly tsserver) | `typescript-language-server` |
| Rust | `rust_analyzer` | `rust-analyzer` |
| Go | `gopls` | `gopls` |
| Bash | `bashls` | `bash-language-server` |
| JSON | `jsonls` | `json-lsp` |
| YAML | `yamlls` | `yaml-language-server` |
| HTML/CSS | `html`, `cssls` | `html-lsp`, `css-lsp` |
| Markdown | `marksman` | `marksman` |
| LaTeX | `texlab` | `texlab` |

**Steps:**
1. Add to `ensure_installed` in `mason-lspconfig.lua`:
   ```lua
   ensure_installed = {
     "lua_ls", "clangd", "pyright",
     "ts_ls", "rust_analyzer", "gopls",
     "bashls", "jsonls", "yamlls",
     "html", "cssls", "marksman", "texlab",
   }
   ```
2. Add a handler entry for each server if it needs non-default settings (most don't):
   ```lua
   lspconfig.texlab.setup({ capabilities = capabilities })
   lspconfig.ts_ls.setup({ capabilities = capabilities })
   -- etc.
   ```
3. **texlab** replaces vimtex's ad-hoc completion and gives proper LSP diagnostics for LaTeX — pair it with vimtex (keep vimtex for compilation/preview, use texlab for LSP).

---

### 3. Add none-ls (null-ls) or conform.nvim for formatting/linting

The current config has no linter or formatter outside of LSP's built-in formatting. Many language servers don't provide formatting (or you may want prettier/black instead).

**Recommended: [conform.nvim](https://github.com/stevearc/conform.nvim)** for formatting + **[nvim-lint](https://github.com/mfussenegger/nvim-lint)** for linting. These are lighter and more reliable than null-ls/none-ls.

**Steps:**
1. Add conform.nvim:
   ```lua
   {
     "stevearc/conform.nvim",
     event = "BufWritePre",
     opts = {
       formatters_by_ft = {
         python     = { "black" },
         javascript = { "prettier" },
         typescript = { "prettier" },
         lua        = { "stylua" },
         cpp        = { "clang_format" },
       },
       format_on_save = { timeout_ms = 500, lsp_fallback = true },
     },
   }
   ```
2. Install the formatters via Mason: add `ensure_installed` for `mason-tool-installer` or install manually.
3. Replace the manual `<space>f` LSP format binding with `conform.format()`.

---

### 4. Add gitsigns.nvim for inline git blame and hunk navigation

There is currently no git integration at all. [**gitsigns.nvim**](https://github.com/lewis6991/gitsigns.nvim) is extremely lightweight and adds inline change indicators, hunk staging, blame, and diff viewing without adding a heavy dependency.

**Steps:**
1. Add to `lua/plugin/editor/`:
   ```lua
   {
     "lewis6991/gitsigns.nvim",
     event = "BufReadPre",
     opts = {
       signs = {
         add = { text = "▎" }, change = { text = "▎" },
         delete = { text = "" },
       },
       on_attach = function(bufnr)
         local gs = package.loaded.gitsigns
         local map = function(mode, l, r)
           vim.keymap.set(mode, l, r, { buffer = bufnr })
         end
         map("n", "]h", gs.next_hunk)
         map("n", "[h", gs.prev_hunk)
         map("n", "<leader>hs", gs.stage_hunk)
         map("n", "<leader>hr", gs.reset_hunk)
         map("n", "<leader>hb", gs.blame_line)
         map("n", "<leader>hd", gs.diffthis)
       end,
     },
   }
   ```

---

### 5. Add telescope extensions for richer searching

Telescope alone is usable but becomes much more powerful with a few additions:

- **[telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim)** — replaces the default sorter with a native fzf algorithm; significant speed improvement on large repos. Build: `make`.
- **[telescope-file-browser.nvim](https://github.com/nvim-telescope/telescope-file-browser.nvim)** — can replace or complement nnn for quick directory traversal inside Telescope.

**Steps:**
1. Add both to the telescope spec as dependencies or separate specs:
   ```lua
   {
     "nvim-telescope/telescope-fzf-native.nvim",
     build = "make",
   }
   ```
2. In telescope config, load the extension:
   ```lua
   require("telescope").load_extension("fzf")
   ```
3. Add Telescope keybinds to `keybinds.lua`:
   ```lua
   local tb = require("telescope.builtin")
   vim.keymap.set("n", "<leader>ff", tb.find_files)
   vim.keymap.set("n", "<leader>fg", tb.live_grep)
   vim.keymap.set("n", "<leader>fb", tb.buffers)
   vim.keymap.set("n", "<leader>fd", tb.diagnostics)
   vim.keymap.set("n", "<leader>fr", tb.lsp_references)
   vim.keymap.set("n", "<leader>fs", tb.lsp_document_symbols)
   ```
   These mirror VSCode's Ctrl+P / Ctrl+Shift+F / symbol search.

---

### 6. Replace nvim-colorizer.lua with a maintained fork

**norcalli/nvim-colorizer.lua** has been unmaintained for years. The maintained drop-in replacement is [**NvChad/nvim-colorizer.lua**](https://github.com/NvChad/nvim-colorizer.lua), or alternatively [**brenoprata10/nvim-highlight-colors**](https://github.com/brenoprata10/nvim-highlight-colors), both of which support more color formats and are actively maintained.

**Steps:**
1. In `colorscheme.lua` (or wherever colorizer is configured), change the plugin source:
   ```lua
   { "NvChad/nvim-colorizer.lua", opts = { filetypes = { "*" } } }
   -- or
   { "brenoprata10/nvim-highlight-colors", opts = {} }
   ```
2. Extend from Lua-only to `filetypes = { "*" }` to get color previews everywhere.

---

### 7. Add nvim-surround for surround operations

VSCode has multi-cursor + surround via extensions. In Neovim, [**kylechui/nvim-surround**](https://github.com/kylechui/nvim-surround) provides `ys`, `cs`, `ds` surround operations with zero keybind conflicts and treesitter awareness.

**Steps:**
```lua
{ "kylechui/nvim-surround", event = "VeryLazy", opts = {} }
```
No further configuration needed; it works out of the box.

---

### 8. Enable nvim-treesitter-context

This plugin is installed but disabled. It shows the enclosing function/class at the top of the screen — directly analogous to VS Code's breadcrumbs. For large files this is very useful.

**Steps:**
1. In `lua/plugin/treesitter/init.lua`, re-enable it:
   ```lua
   { "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 3 } }
   ```
2. Remove the `enabled = false` line.

---

### 9. Consolidate snippet engines — drop one of LuaSnip/UltiSnips

Having both UltiSnips and LuaSnip adds startup overhead and complexity. UltiSnips requires Python; LuaSnip is pure Lua and faster.

**Recommendation:** Migrate the UltiSnips `.snippets` files to LuaSnip format, then remove UltiSnips. LuaSnip can load UltiSnips-format files natively via `require("luasnip.loaders.from_snipmate")` or the UltiSnips loader `require("luasnip.loaders.from_ultisnips").lazy_load()`, so the existing snippet files can be reused during the transition without any rewriting.

**Steps:**
1. In the cmp config, remove the `ultisnips` source and `cmp-nvim-ultisnips`.
2. Add to LuaSnip setup:
   ```lua
   require("luasnip.loaders.from_ultisnips").lazy_load({ paths = "~/.config/nvim/UltiSnips" })
   ```
3. Set UltiSnips as `enabled = false` in lazy.nvim, confirm snippets still work.
4. Once satisfied, remove ultisnips entirely.

---

### 10. Add which-key.nvim for discoverable keybindings

With `timeoutlen = 150` the timeout is very short and there's currently no way to discover what `<space>*` bindings exist. [**folke/which-key.nvim**](https://github.com/folke/which-key.nvim) shows a popup of available completions as you type a leader sequence. It integrates with existing keymaps without requiring you to redefine them.

**Steps:**
```lua
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 400, -- ms after which popup appears
    spec = {
      { "<leader>h", group = "git hunks" },
      { "<leader>f", group = "find/telescope" },
      { "<space>",   group = "lsp" },
    },
  },
}
```

---

### 11. Add mini.nvim modules selectively

[**echasnovski/mini.nvim**](https://github.com/echasnovski/mini.nvim) is a collection of small, independent modules. Each module loads in <1ms. Specifically useful additions without bloat:

- **mini.comment** — `gcc` to toggle comments (replaces the need for Comment.nvim)
- **mini.ai** — extended text objects (`a` and `i` for functions, classes, etc.)
- **mini.move** — move lines/selections with `<M-hjkl>`
- **mini.bufremove** — close buffers without closing the window (`<leader>bd`)

**Steps:**
```lua
{ "echasnovski/mini.comment",   version = "*", opts = {} },
{ "echasnovski/mini.ai",        version = "*", opts = {} },
{ "echasnovski/mini.move",      version = "*", opts = {} },
{ "echasnovski/mini.bufremove", version = "*" },
```

---

### 12. Fix scrolloff — increase to 8

`scrolloff = 1` means the cursor can be one line from the edge before scrolling, which makes context hard to see. A value of `8` (matching `sidescrolloff`) keeps more surrounding lines visible, matching typical VSCode behavior.

**Steps:** In `options.lua`:
```lua
vim.opt.scrolloff = 8
```

---

### Summary table

| # | Change | Impact | Effort |
|---|--------|--------|--------|
| 1 | blink.cmp over nvim-cmp | Faster completion | Medium |
| 2 | Expand LSP servers | Broader language support | Low |
| 3 | conform.nvim + nvim-lint | Formatting/linting | Low |
| 4 | gitsigns.nvim | Git integration | Low |
| 5 | Telescope extensions + keybinds | Much better search | Low |
| 6 | Maintained colorizer fork | Bug fixes | Trivial |
| 7 | nvim-surround | Surround editing | Trivial |
| 8 | Enable treesitter-context | Breadcrumbs | Trivial |
| 9 | Drop UltiSnips, keep LuaSnip | Simplify, remove Python dep | Medium |
| 10 | which-key.nvim | Discoverable keybinds | Low |
| 11 | mini.nvim modules | Comments, text objects, more | Low |
| 12 | scrolloff = 8 | Better cursor context | Trivial |
