pg() {
    p=$(sk --margin 10% --regex --ansi -i -c 'rg --color=always --line-number "{}"')

    if (( $? == 0 )); then
        num="${p#*:}"
        num="${num%%:*}"

        p="${p%%:*}"

        nvim "$file" +$num
    fi
}

pf() {
    p=$(sk --regex --ansi --margin 10%)

    if (( $? == 0 )); then
        p="${p%%:*}"
        nvim "$p"
    fi
}

alias doc="cd $HOME/documents"
alias p="cd $HOME/documents/projects"
alias edu="cd $HOME/documents/projects/edu"
alias conf="cd $HOME/.config"
alias dot="cd $HOME/.dotfiles"

alias vi="nvim"

# script shortcuts
alias uconf="$DOTFILES/update.sh"
alias tf="$HOME/.config/scripts/tmux-session-dispensary.sh"
