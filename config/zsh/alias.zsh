unalias g 2>/dev/null
unalias f 2>/dev/null

alias documents="cd $HOME/documents"
alias downloads="cd $HOME/downloads"
alias icloud="cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs"

alias sz="source $HOME/.zshrc"
alias se="source $HOME/.zshenv"

if command -v exercism &>/dev/null; then
	alias exer="cd $(exercism workspace)"
fi

alias vim="nvim"

alias ls="ls -CGA --color=auto"
alias l="ls"

alias mountwin="sudo mount -t ntfs-3g /dev/nvme0n1p3 /mnt/windows"

# script shortcuts
alias uconf="$DOTFILES/update.sh"
alias tf="$HOME/.config/scripts/tmux-session-dispensary.sh"
alias zv="$HOME/.config/scripts/zv.sh"
alias tree="$HOME/.config/scripts/tree.sh"
