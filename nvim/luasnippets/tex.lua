-- LuaSnip snippets for LaTeX (tex filetype).
-- Ported from UltiSnips/tex.snippets.
-- Math-context detection uses vimtex's mathzone API.

local ls  = require("luasnip")
local s   = ls.snippet
local sn  = ls.snippet_node
local t   = ls.text_node
local i   = ls.insert_node
local f   = ls.function_node
local d   = ls.dynamic_node
local c   = ls.choice_node

-- returns true when the cursor is inside a math zone (vimtex)
local function math()
    local ok, val = pcall(vim.fn["vimtex#syntax#in_mathzone"])
    return ok and val == 1
end

-- Greek letter set for auto-subscript detection
local greek_set = {
    alpha=true, beta=true, gamma=true, Gamma=true, delta=true, Delta=true,
    epsilon=true, varepsilon=true, zeta=true, eta=true,
    theta=true, vartheta=true, Theta=true,
    iota=true, kappa=true, Kappa=true,
    lambda=true, Lambda=true,
    mu=true, nu=true,
    xi=true, Xi=true,
    pi=true, Pi=true,
    rho=true, varrho=true,
    sigma=true, Sigma=true,
    tau=true,
    upsilon=true, Upsilon=true,
    phi=true, varphi=true, Phi=true,
    chi=true,
    psi=true, Psi=true,
    omega=true, Omega=true,
    nabla=true,
}

-- Left/right delimiter table
local lr_delims = {
    p   = { "(",        ")"        },
    b   = { "[",        "]"        },
    r   = { "\\{",      "\\}"      },
    ["<"] = { "\\langle", "\\rangle" },
    c   = { "\\lceil",  "\\rceil"  },
    f   = { "\\lfloor", "\\rfloor" },
    ["|"] = { "\\lvert",  "\\rvert"  },
}

-- ─────────────────────────────────────────────────────────────
-- REGULAR snippets (require manual expansion)
-- ─────────────────────────────────────────────────────────────
local regular = {

    -- document preamble
    s("preamble", {
        t({
            "%! TeX program = lualatex",
            "\\documentclass[11pt]{scrartcl}",
            "\\usepackage{michael}",
            "",
            "\\title{",
        }),
        i(1),
        t({ "}", "", "\\begin{document}", "\\maketitle", "", "" }),
        i(0),
        t({ "", "", "\\end{document}" }),
    }),

    -- \begin{} / \end{} pair
    s("beg", {
        t("\\begin{"),
        i(1, "env"),
        t("}"),
        i(2),
        t({ "", "\\end{" }),
        f(function(args) return args[1][1] end, { 1 }),
        t("}"),
        i(0),
    }),

    -- asymptote figure
    s("asy", {
        t({
            "\\begin{figure}",
            "\t\\centering",
            "\t\\begin{asy}",
            "\t\t",
        }),
        i(0),
        t({ "", "\t\\end{asy}", "\\end{figure}" }),
    }),

    -- n-th root (non-auto; use sqrt for square root)
    s({ trig = "rt", condition = math }, {
        t("\\sqrt["), i(1), t("]{"), i(2), t("}"), i(0),
    }),

    -- text in math
    s({ trig = "te",  condition = math }, { t("\\text{"),   i(1), t("}"), i(0) }),
    s({ trig = "tet", condition = math }, { t("\\texttt{"), i(1), t("} "), i(0) }),

    -- number sets
    s({ trig = "RR", condition = math }, { t("\\mathbb R "), i(0) }),
    s({ trig = "ZZ", condition = math }, { t("\\mathbb Z"),  i(0) }),
    s({ trig = "QQ", condition = math }, { t("\\mathbb Q"),  i(0) }),
    s({ trig = "CC", condition = math }, { t("\\mathbb C"),  i(0) }),
    s({ trig = "NN", condition = math }, { t("\\mathbb N"),  i(0) }),
    s({ trig = "LL", condition = math }, { t("\\mathcal L"), i(0) }),
    s({ trig = "II", condition = math }, { t("\\mathbb 1"),  i(0) }),

    -- manual derivative (placeholders for numerator/denominator)
    s({ trig = "dd", condition = math }, {
        t("\\frac{\\mathrm d "), i(1), t("}{\\mathrm d "), i(2), t("} "), i(0),
    }),

    -- second derivative
    s({ trig = "2dd", condition = math }, {
        t("\\frac{\\mathrm d^2 "), i(1),
        t("}{\\mathrm d "), i(2), t("^2} "), i(0),
    }),

    -- partial derivative
    s({ trig = "part", condition = math }, {
        t("\\frac{\\partial "), i(1),
        t("}{\\partial "), i(2), t("} "), i(0),
    }),
}

-- ─────────────────────────────────────────────────────────────
-- AUTO snippets (expand as you type; math-context where noted)
-- ─────────────────────────────────────────────────────────────
local auto = {

    -- display math block
    s({ trig = "mm" }, {
        t({ "\\[", "    " }), i(0), t({ "", "\\]" }),
    }),

    -- inline math
    s({ trig = "im" }, {
        t("\\( "), i(1), t(" \\)"), i(0),
    }),

    -- ── math fonts ──────────────────────────────────────────
    s({ trig = "mbf",  condition = math, wordTrig = true }, { t("\\mathbf{"),  i(1), t("}"), i(0) }),
    s({ trig = "mrm",  condition = math, wordTrig = true }, { t("\\mathrm{"),  i(1), t("}"), i(0) }),
    s({ trig = "mbb",  condition = math, wordTrig = true }, { t("\\mathbb{"),  i(1), t("}"), i(0) }),
    s({ trig = "mcal", condition = math, wordTrig = true }, { t("\\mathcal{"), i(1), t("}"), i(0) }),

    -- ── common subscripts ───────────────────────────────────
    s({ trig = "xnn", condition = math, wordTrig = true }, { t("x_{n}"),   i(0) }),
    s({ trig = "xii", condition = math, wordTrig = true }, { t("x_{i}"),   i(0) }),
    s({ trig = "xjj", condition = math, wordTrig = true }, { t("x_{j}"),   i(0) }),
    s({ trig = "xn1", condition = math, wordTrig = true }, { t("x_{n+1}"), i(0) }),

    -- ── auto subscript: single letter + digit (e.g. x2 → x_{2}) ──
    s({
        trig = "([a-zA-Z])(%d)",
        regTrig = true,
        wordTrig = false,
        condition = math,
    }, {
        f(function(_, snip) return snip.captures[1] .. "_{" .. snip.captures[2] .. "}" end),
        i(0),
    }),

    -- auto subscript for Greek commands: \alpha2 → \alpha_{2}
    -- (priority > default so it wins over the plain-letter rule)
    s({
        trig = "\\([A-Za-z]+)(%d)",
        regTrig = true,
        condition = math,
        priority = 100,
    }, {
        f(function(_, snip)
            local name = snip.captures[1]
            local num  = snip.captures[2]
            if greek_set[name] then
                return "\\" .. name .. "_{" .. num .. "} "
            else
                return "\\" .. name .. num
            end
        end),
        i(0),
    }),

    -- ── sub / superscript wrappers ──────────────────────────
    s({ trig = "_", condition = math, wordTrig = false }, { t("_{"), i(1), t("}"), i(0) }),
    s({ trig = "^", condition = math, wordTrig = false }, { t("^{"), i(1), t("}"), i(0) }),

    -- ── powers ──────────────────────────────────────────────
    s({ trig = "sqre", condition = math, wordTrig = false }, { t("^2"), i(0) }),
    s({ trig = "cube", condition = math, wordTrig = false }, { t("^3"), i(0) }),

    -- ── sqrt (auto: "xsqrt" → x\sqrt{}) ────────────────────
    s({
        trig = "([^\\])sqrt",
        regTrig = true,
        condition = math,
    }, {
        f(function(_, snip) return snip.captures[1] end),
        t("\\sqrt{"), i(1), t("}"), i(0),
    }),

    -- ── accents: single-char variant (e.g. xhat → \hat{x}) ─
    s({ trig = "([A-Za-z0-9])hat",  regTrig = true, condition = math }, {
        t("\\hat{"),       f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),
    s({ trig = "([A-Za-z0-9])dot",  regTrig = true, condition = math }, {
        t("\\dot{"),       f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),
    s({ trig = "([A-Za-z0-9])ddot", regTrig = true, condition = math, priority = 100 }, {
        t("\\ddot{"),      f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),
    s({ trig = "([A-Za-gi-z0-9])bar", regTrig = true, condition = math }, {
        t("\\bar{"),       f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),
    s({ trig = "([A-Za-z0-9])vec",  regTrig = true, condition = math }, {
        t("\\vec{"),       f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),
    s({ trig = "([A-Za-z0-9])und",  regTrig = true, condition = math }, {
        t("\\underline{"), f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),
    s({ trig = "([A-Za-z0-9])tild", regTrig = true, condition = math }, {
        t("\\tilde{"),     f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),

    -- accents: Greek command variant (e.g. \alphahat → \hat{\alpha})
    s({ trig = "\\([A-Za-z]+)hat",  regTrig = true, condition = math }, {
        t("\\hat{\\"),    f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),
    s({ trig = "\\([A-Za-z]+)dot",  regTrig = true, condition = math }, {
        t("\\dot{\\"),    f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),
    s({ trig = "\\([A-Za-z]+)ddot", regTrig = true, condition = math, priority = 100 }, {
        t("\\ddot{\\"),   f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),
    s({ trig = "\\([A-Za-z]+)bar",  regTrig = true, condition = math }, {
        t("\\bar{\\"),    f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),
    s({ trig = "\\([A-Za-z]+)vec",  regTrig = true, condition = math }, {
        t("\\vec{\\"),    f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),
    s({ trig = "\\([A-Za-z]+)und",  regTrig = true, condition = math }, {
        t("\\underline{\\"), f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),
    s({ trig = "\\([A-Za-z]+)tild", regTrig = true, condition = math }, {
        t("\\tilde{\\"),  f(function(_, snip) return snip.captures[1] end), t("}"), i(0),
    }),

    -- ── left/right delimiters: lr<x> ────────────────────────
    s({ trig = "lr([pbr<cf|])", regTrig = true, condition = math }, {
        f(function(_, snip)
            local d = lr_delims[snip.captures[1]]
            return d and ("\\left" .. d[1]) or ("\\left" .. snip.captures[1])
        end),
        t(" "), i(1), t(" "),
        f(function(_, snip)
            local d = lr_delims[snip.captures[1]]
            return d and ("\\right" .. d[2]) or ("\\right" .. snip.captures[1])
        end),
        i(0),
    }),

    -- ── auto-derivatives (regex) ─────────────────────────────
    -- dxdy  → \frac{\mathrm d x}{\mathrm d y}
    s({ trig = "d([A-Za-z])d([A-Za-z])", regTrig = true, condition = math }, {
        t("\\frac{\\mathrm d "),
        f(function(_, snip) return snip.captures[1] end),
        t("}{\\mathrm d "),
        f(function(_, snip) return snip.captures[2] end),
        t("} "), i(0),
    }),
    -- ddx   → \frac{\mathrm d $1}{\mathrm d x}
    s({ trig = "dd([A-Za-z])", regTrig = true, condition = math }, {
        t("\\frac{\\mathrm d "), i(1),
        t("}{\\mathrm d "),
        f(function(_, snip) return snip.captures[1] end),
        t("} "), i(0),
    }),
    -- 2ddx  → second derivative in x
    s({ trig = "2dd([A-Za-z])", regTrig = true, condition = math }, {
        t("\\frac{\\mathrm d^2 "), i(1),
        t("}{\\mathrm d "),
        f(function(_, snip) return snip.captures[1] end),
        t("^2} "), i(0),
    }),
    -- 2dxdy → \frac{\mathrm d^2 x}{\mathrm d y^2}
    s({ trig = "2d([A-Za-z])d([A-Za-z])", regTrig = true, condition = math }, {
        t("\\frac{\\mathrm d^2 "),
        f(function(_, snip) return snip.captures[1] end),
        t("}{\\mathrm d "),
        f(function(_, snip) return snip.captures[2] end),
        t("^2} "), i(0),
    }),

    -- ── bmatrix generator: bmat<rows>,<cols> ─────────────────
    s({
        trig = "bmat(%d+),(%d+)",
        regTrig = true,
        condition = math,
        priority = 100,
    }, {
        d(1, function(_, parent)
            local rows = tonumber(parent.captures[1])
            local cols = tonumber(parent.captures[2])
            if not rows or not cols or rows < 1 or cols < 1 or rows > 20 or cols > 20 then
                return sn(nil, { t("") })
            end
            local nodes = { t("\\begin{bmatrix}\n") }
            local tab = 1
            for row = 1, rows do
                table.insert(nodes, t("    "))
                for col = 1, cols do
                    table.insert(nodes, i(tab))
                    tab = tab + 1
                    if col < cols then
                        table.insert(nodes, t(" & "))
                    end
                end
                if row < rows then
                    table.insert(nodes, t({ " \\\\", "" }))
                else
                    table.insert(nodes, t({ "", "" }))
                end
            end
            table.insert(nodes, t("\\end{bmatrix}"))
            return sn(nil, nodes)
        end),
    }),

    -- ── fractions ────────────────────────────────────────────
    -- // → \frac{}{}
    s({ trig = "//", condition = math, wordTrig = false }, {
        t("\\frac{"), i(1), t("}{"), i(2), t("}"), i(0),
    }),

    -- integer/ → \frac{n}{}  e.g. "3/" → \frac{3}{}
    s({
        trig = "(%d+)/",
        regTrig = true,
        condition = math,
        priority = 500,
    }, {
        t("\\frac{"),
        f(function(_, snip) return snip.captures[1] end),
        t("}{"), i(1), t("}"), i(0),
    }),

    -- word-or-command/ → \frac{word}{}  e.g. "x^2/" or "\alpha/"
    s({
        trig = "([%w\\^_{}]+)/",
        regTrig = true,
        condition = math,
        priority = 400,
    }, {
        t("\\frac{"),
        f(function(_, snip) return snip.captures[1] end),
        t("}{"), i(1), t("}"), i(0),
    }),

    -- paren-expr/ → \frac{expr}{}  with stack-based matching: "(a+b)/" → \frac{a+b}{}
    s({
        trig = "(.+)/",
        regTrig = true,
        condition = math,
        priority = 1000,
    }, {
        f(function(_, snip)
            local str  = snip.captures[1]
            local last = str:sub(-1)
            if last == ")" then
                local depth = 0
                local j = #str
                while j >= 1 do
                    local ch = str:sub(j, j)
                    if ch == ")" then
                        depth = depth + 1
                    elseif ch == "(" then
                        depth = depth - 1
                        if depth == 0 then break end
                    end
                    j = j - 1
                end
                if depth == 0 and j > 1 then
                    -- str[1..j-1] + \frac{str[j+1..-2]}
                    return str:sub(1, j - 1) .. "\\frac{" .. str:sub(j + 1, #str - 1) .. "}"
                end
            end
            return "\\frac{" .. str .. "}"
        end),
        t("{"), i(1), t("}"), i(0),
    }),
}

-- mark every auto snippet as autosnippet
for _, snip in ipairs(auto) do
    snip.snippetType = "autosnippet"
end

return regular, auto
