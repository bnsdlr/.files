pg() {
    p=$(sk --regex --ansi -i -c 'rg --color=always --line-number "{}"')

    if (( $? == 0 )); then
        num="${p#*:}"
        num="${num%%:*}"

        p="${p%%:*}"

        dir="${p%/*}"
        file="${p##*/}"

        cd "$dir" && nvim "$file" +$num
    fi
}

pf() {
    p=$(sk --regex --ansi)

    if (( $? == 0 )); then
        p="${p%%:*}"
        nvim "$p"
    fi
}

alias nvimconf="cd $HOME/.config/nvim; nvim ."
alias nvimdot="cd $HOME/.dotfiles; nvim ."

alias doc="cd $HOME/documents"
alias p="cd $HOME/documents/projects"
alias edu="cd $HOME/documents/projects/edu"
alias conf="cd $HOME/.config"
alias dot="cd $HOME/.dotfiles"

# script shortcuts
alias uconf="$DOTFILES/update.sh"
