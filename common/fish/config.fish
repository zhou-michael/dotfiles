# ==============================================================================
# Michael Zhou's Fish Configuration (Cross-Platform)
# ==============================================================================

# PATH Configuration (cross-platform)
test -d /opt/homebrew/bin && fish_add_path -p /opt/homebrew/bin
test -d /opt/homebrew/sbin && fish_add_path -p /opt/homebrew/sbin
test -d $HOME/.local/bin && fish_add_path -p $HOME/.local/bin
test -d $HOME/.juliaup/bin && fish_add_path -p $HOME/.juliaup/bin
test -d $HOME/.elan/bin && fish_add_path -p $HOME/.elan/bin

if status is-interactive
    # Vi keybindings & autosuggestion navigation
    fish_vi_key_bindings
    bind -M insert alt-n accept-autosuggestion
    bind -M insert ctrl-n nextd-or-forward-word

    # Prompt (Starship)
    if type -q starship
        starship init fish | source
    end

    # Environment
    set -gx EDITOR nvim
    set -gx NNN_TRASH "trash"

    # Context colors (Catppuccin compatible)
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
    set -gx NNN_COLORS "#04020301;4231"
    set -gx NNN_FCOLORS "$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$UNKNOWN"

    # Direnv hook
    if type -q direnv
        direnv hook fish | source
    end

    # WSL Interop
    if test -f /proc/version; and grep -qi microsoft /proc/version
        type -q clip.exe && alias pbcopy="clip.exe"
        type -q explorer.exe && alias open="explorer.exe"
    end
end

# OrbStack integration (macOS)
if test -f ~/.orbstack/shell/init2.fish
    source ~/.orbstack/shell/init2.fish 2>/dev/null || true
end
