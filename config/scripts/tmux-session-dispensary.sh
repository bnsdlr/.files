#!/bin/bash
# inspired: https://github.com/SylvanFranklin/.config/blob/df0087d62958add7d78e29192682825adbb98e7c/scripts/tmux-session-dispensary.sh

DIRS=(
    "$HOME/documents/notes"
    "$HOME/documents/projects"
    "$(pwd)"
)

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(fd . "${DIRS[@]}" --type=dir --max-depth=2 --full-path \
        | sed -E "s|^$HOME/(.*)/$|\1|" \
        | sk --margin 10% --color="bw")
    [[ $selected ]] && selected="$HOME/$selected"
fi

[[ ! $selected ]] && exit 0

selected_name=$(basename "$selected" | tr . _)
if ! tmux has-session -t "$selected_name"; then
    tmux new-session -ds "$selected_name" -c "$selected"
    tmux select-window -t "$selected_name:1"
fi

tmux switch-client -t "$selected_name"

