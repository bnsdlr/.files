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
alias neovimconf="cd $HOME/.config/nvim; nvim ."
alias neovimdot="cd $HOME/.dotfiles; nvim ."
alias neovim="nvim"

# script shortcuts
alias uconf="$DOTFILES/update.sh"
alias rnix="$HOME/.scripts/darwin-rebuild.sh"
