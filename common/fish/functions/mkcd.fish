function mkcd
    if test (count $argv) -ne 1
        echo "Usage: mkcd <directory>"
        return 1
    end

    set dir $argv[1]

    if not test -d $dir
        mkdir -p $dir
        if test $status -ne 0
            echo "Failed to create directory: $dir"
            return 1
        end
    end

    cd $dir
end

