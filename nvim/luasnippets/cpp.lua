local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node
local f  = ls.function_node

return {
    -- competitive programming template
    s("compprog", {
        t({
            "#include <bits/stdc++.h>",
            "using namespace std;",
            "",
            'const string filename{"',
        }),
        i(1, "name"),
        t({
            '"};',
            "",
            "void setupIO(bool fileIO, bool fileDebug)",
            "{",
            "    ios_base::sync_with_stdio(false);",
            "    cin.tie(nullptr);",
            "",
            "    if (fileIO)",
            "    {",
            '        freopen((filename + ".in").c_str(), "r", stdin);',
            '        freopen((filename + ".out").c_str(), "w", stdout);',
            "    }",
            "",
            "    if (fileDebug)",
            "    {",
            '        freopen((filename + ".debug").c_str(), "w", stderr);',
            "    }",
            "}",
            "",
            "int main()",
            "{",
            "    setupIO(false, false);",
            "    ",
        }),
        i(0),
        t({ "", "}" }),
    }),

    -- fast I/O lines
    s("fastio", {
        t({
            "ios_base::sync_with_stdio(false);",
            "cin.tie(nullptr);",
        }),
        i(0),
    }),

    -- file header
    s("header", {
        t("// Michael Zhou\n// "),
        f(function() return os.date("%Y-%m-%d") end),
        t("\n// "),
        i(1, "Assignment"),
        t("\n// "),
        i(2, "Description"),
        t("\n"),
        i(0),
    }),
}, {}
