# Packages

## Brews / Casks

```shell
brew bundle
```

## Other

```shell
brew "exercism"
cask "brave-browser"
cask "discord"
```

## Nightly Neovim

```shell
brew install bob
bob use nightly
```

## Evremap

```shell
sudo cp $HOME/.files/config/evremap/config.toml /etc/evremap.toml
sudo cp $HOME/.files/config/evremap/evremap.service /usr/lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable evremap.service
sudo systemctl start evremap.service
```

## Qutebrowser

```shell
brew install qutebrowser
```

## Fonts

```shell
brew install --cask font-jetbrains-mono-nerd-font
```

<!--
## Emacs

```shell
brew tap "d12frosted/emacs-plus"
brew install "d12frosted/emacs-plus/emacs-plus@30"
```
-->

## Programing Languages

### Rust

Via the [offical website](https://www.rust-lang.org/tools/install).

```shel
brew "rustup"
```

```shel
brew "elixir"
```

## Other

  - [Oh My Zsh](https://ohmyz.sh)
