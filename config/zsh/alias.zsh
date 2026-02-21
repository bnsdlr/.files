unalias g 2>/dev/null
unalias f 2>/dev/null

g() {
    p=$(sk --margin 10% --regex --ansi -i -c 'rg --color=always --line-number "{}"')

    if (( $? == 0 )); then
        num="${p#*:}"
        num="${num%%:*}"

        p="${p%%:*}"

        nvim "$p" +$num
    fi
}

f() {
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
alias dot="cd $DOTFILES"
alias icloud="cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs"

if command -v exercism &>/dev/null; then
	alias exer="cd $(exercism workspace)"
fi

alias emacs="emacsclient -c -a 'emacs'"

alias ls="ls -CGA"

# script shortcuts
alias uconf="$DOTFILES/update.sh"
alias tf="$HOME/.config/scripts/tmux-session-dispensary.sh"
