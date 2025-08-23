#!/bin/bash
# inspired: https://github.com/SylvanFranklin/.config/blob/df0087d62958add7d78e29192682825adbb98e7c/scripts/tmux-session-dispensary.sh

DIRS=(
    "$HOME/documents/notes"
    "$HOME/documents/projects"
    "$(pwd)"
)

check_if_installed() {
    cli_tool=$1
    git_url=$2
    if ! which $cli_tool; then
        printf "Make sure $cli_tool is installed ($git_url)\n"
        echo "Press enter to exit"
        read
        exit 1
    fi
}

if [[ $# -eq 1 ]]; then
    selected=$1
else
    check_if_installed fd "https://github.com/sharkdp/fd"
    check_if_installed sk "https://github.com/skim-rs/skim"
    selected=$("$HOME/.config/scripts/list-dirs.sh" ${DIRS[@]} \
        | sed -E "s|^$HOME/(.*)/$|\1|" \
        | sk --margin 10% --color="bw")
    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "$selected" | tr '. ' _)

if ! tmux has-session -t "$selected_name"; then
    tmux new-session -ds "$selected_name" -c "$selected"
    tmux select-window -t "$selected_name:1"
fi

if [[ "$TMUX" == "" ]]; then
    tmux attach -t "$selected_name"
else
    tmux switch-client -t "$selected_name"
fi

