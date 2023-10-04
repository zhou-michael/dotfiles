setlocal wrap
let b:pear_tree_pairs = {
            \ '(': {'closer': ')', 'not_in': ['String', 'Comment']},
            \ '[': {'closer': ']', 'not_in': ['String', 'Comment']},
            \ '{': {'closer': '}', 'not_in': ['String', 'Comment']},
            \ "'": {'closer': "'", 'not_in': ['String', 'Comment']},
            \ '"': {'closer': '"', 'not_in': ['String', 'Comment']},
            \ '$' : {'closer': '$', 'not_in': ['String', 'Comment']},
            \ '\\[' : {'closer': '\\]', 'not_in': ['String', 'Comment']}
            \ }
