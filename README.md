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

## Switch Theme to random every time interval

```sh
cronttab -e
```

and then add sth like this:

```
# Every day in the 0th hour
* 0 * * * pkill -USR1 nvim
```

## Troubleshooting

Delete all `nvim` related folders under `~/.local` and then reinstall it.
