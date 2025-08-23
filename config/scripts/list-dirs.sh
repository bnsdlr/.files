#!/bin/bash

DIRS=$@

dirs=$(fd . ${DIRS[@]} --type=dir --full-path --no-ignore-vcs --hidden \
    --exclude '**/.git/**' --exclude target --exclude src --exclude '**/.*/**' \
    --exclude Library)

for dir in $dirs; do
    if [[ "$dir" =~ ".git" ]]; then
        dir=$(echo "$dir" | sed 's|/.git||')
        echo "$dir"
    fi
done

for dir in $(fd . ${DIRS[@]} --type=dir --full-path --max-depth=2 --exclude Library); do
    echo "$dir"
done

