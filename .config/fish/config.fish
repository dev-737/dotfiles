if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    enable_transience
end

alias n="nvim"
alias cls="clear"
alias connect="bluetoothctl connect"
alias disconnect="bluetoothctl disconnect"
alias ls='exa --icons'
alias la='ls -a'

# disable "welcome to fish" message on startup
set -g fish_greeting

