if status is-interactive
    # general settings
    fish_vi_key_bindings
    bind -M insert alt-n accept-autosuggestion
    bind -M insert ctrl-n nextd-or-forward-word

    # init starship
    starship init fish | source

    # NNN config

    # This second option relies on your terminal using the catppuccin theme and we'll use true catppuccin colors:
    set BLK "03"
    set CHR "03"
    set DIR "04"
    set EXE "02"
    set REG "07"
    set HARDLINK "05"
    set SYMLINK "05"
    set MISSING "08"
    set ORPHAN "01"
    set FIFO "06"
    set SOCK "03"
    set UNKNOWN "01"

    # Export Context Colors
    set -x NNN_COLORS "#04020301;4231"

    # Finally Export the set file colors ( Both options require this)
    set -x NNN_FCOLORS "$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$UNKNOWN"

    set -x EDITOR nvim

    set -x NNN_TRASH "trash"
end
