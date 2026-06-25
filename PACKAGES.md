# Packages

## Brews / Casks

```shell
brew bundle
```

## Evremap

```shell
sudo cp $HOME/.files/config/evremap/config.toml /etc/evremap.toml
sudo cp $HOME/.files/config/evremap/evremap.service /usr/lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable evremap.service
sudo systemctl start evremap.service
```

