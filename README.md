# Dotfiles

Install:
```sh
./conf install
```

Uninstall:
```sh
./conf install
```

## Nvim as difftool for git

```git_config
[diff]
	tool = nvim_difftool
[difftool "nvim_difftool"]
	cmd = nvim -c \"packadd nvim.difftool\" -c \"DiffTool $LOCAL $REMOTE\"
```
