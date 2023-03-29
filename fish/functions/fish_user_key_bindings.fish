function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf accept-autosuggestion
    end

    alias rm="rm -i"

    function compile -d "Compiles a c++ file with c++17 and all warnings" -a "path"
        set index 1
        set last_index (string length $argv[1])
        for char in (string split '' $argv[1])
            if [ $char != '.' ]
                set index (math $index + 1)
            else
                set last_index $index
            end
        end
        set out (string sub -s 1 -l (math $last_index - 1) $argv[1])

        g++ -std=c++17 -O2 -o "$out" $1 -Wall $argv[1]
    end

    function run -d "Compiles and runs a c++ file" -a "path"
        set index 1
        set last_index (string length $argv[1])
        for char in (string split '' $argv[1])
            if [ $char != '.' ]
                set index (math $index + 1)
            else
                set last_index $index
            end
        end
        set out (string sub -s 1 -l (math $last_index - 1) $argv[1])

        compile $argv[1] && "./$out" & fg
    end
end
