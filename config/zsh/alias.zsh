ff() {
    echo "$(fzf --height=20 --reverse --tabstop=4 --border --preview='bat --color=always --style=numbers --line-range=:50 {}')"
}

fnvim() {
    selected_file=$(ff)
    if [ -n "$selected_file" ]; then
        nvim "$selected_file"
    else
        echo "no file selected"
    fi
}

alias nvimconf="cd $HOME/.config/nvim; nvim ."

# script shortcuts
alias uconf="$DOTFILES/update.sh"
alias rnix="$HOME/.scripts/darwin-rebuild.sh"
