# Dotfiles

Just some config so I can share it between my devices. 

# Notes

1. [`kanata`](https://github.com/jtroo/kanata) - Keyborad remap, cross platform.

# Installation

## Download and setup dotfiles

Just run this script in your terminal.

```bash
#!/bin/bash

repo_url="https://github.com/bnsdlr/dotfiles"

dotfiles="$HOME/.dotfiles"

if [[ -d "$dotfiles" ]]; then
    dotfiles="$HOME/.dotfiles-by-bnsdlr"
fi

git clone "$repo_url" "$dotfiles" 

echo "Successfully cloned dotfiles, running setup script..."

"$dotfiles/setup.sh"
```

# Uninstall

Run the `setup.sh` script inside the dotfiles direcotry with the `-r` attribute.

```shell
$HOME/.dotfiles/setup.sh -r
```
