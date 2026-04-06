# Dotfiles

## Sepup

```sh
git clone https://github.com/bnsdlr/dotfiles ~/.files && ~/.files/setup.sh
```

## If I Have Ehough

```sh
$HOME/.files/setup.sh -r
```

## Add these lines to ~/.gitconfig

```git_config
[diff]
	tool = nvim_difftool
[difftool "nvim_difftool"]
	cmd = nvim -c \"packadd nvim.difftool\" -c \"DiffTool $LOCAL $REMOTE\"
```

## Troubleshooting

Delete all `nvim` related folders under `~/.local` and then reinstall it.
