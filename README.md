# Dotfiles

Just some config so I can share it between my devices. 

# Notes

1. [`kanata`](https://github.com/jtroo/kanata) - Keyborad remap, cross platform.

# Installation

## Download and setup dotfiles

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

## Install Nix

### For Linux

[Download nix](https://nixos.org/download/#nix-install-linux)

```
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
```

```
nix profile install --extra-experimental-features 'nix-command flakes' .#win
```

### For Darwin

Install nix-darwin by following the instructions [here](https://www.youtube.com/watch?v=Z8BL8mdzWHI&t=282s).

Here are somethings for you to copy...

```shell
sh <(curl -L https://nixos.org/nix/install)
```

```shell
nix flake init -t nix-darwin --extra-experimental-features "nix-command flakes"
```

```shell
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#imac
```

# Uninstall

Run the `setup.sh` script inside the dotfiles direcotry with the `-r` attribute.

```shell
$HOME/.dotfiles/setup.sh -r
```
