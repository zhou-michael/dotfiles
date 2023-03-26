if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
    set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'
    # starship init fish | source
    set fish_greeting

    set -Ua fish_user_paths $HOME/.cargo/bin

    starship init fish | source
end

fish_add_path /usr/local/smlnj/bin
