# Dotfiles

Just some config so I can share it between my devices.

# Installation

Just run this script in your terminal.

```bash
#!/bin/bash

repo_url="https://github.com/niemand8080/dotfiles"

dotfiles="$HOME/.dotfiles"

if [[ -d "$dotfiles" ]]; then
    dotfiles="$HOME/.dotfiles-by-niemand8080"
fi

git clone "$repo_url" "$dotfiles" 

echo "Successfully cloned dotfiles, running setup script..."

"$dotfiles/setup.sh"
```
