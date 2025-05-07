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

# cd shortcuts
alias projects="cd ~/Library/Mobile\ Documents/com\~apple\~CloudDocs/projects"
alias icloud="cd ~/Library/Mobile\ Documents/com\~apple\~CloudDocs"

# script shortcuts
alias uconf="$DOTFILES/setup.sh"
