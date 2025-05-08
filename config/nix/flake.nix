{
  description = "nix-darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, config, ... }: {
      # Configures nix to be able to download non open source packages
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
          pkgs.mkalias              # Make Alias for mac apps (so they appear in spotlight)
          pkgs.neovim               # Text Editor
          pkgs.tmux                 # Multiplexer (I think)
          pkgs.fzf                  # Fuzzy Finder
          pkgs.bat                  # better cat
          pkgs.ripgrep              # better grep
          pkgs.oh-my-zsh            # Oh My Zsh!
          pkgs.rustup               # rust, rust-analyzer, cargo...
          pkgs.nodejs_23            # NodeJs
        ];

      homebrew = {
          enable = true;
          onActivation.cleanup = "uninstall";

          taps = [];
          brews = [];
          casks = [ 
            "ghostty"               # Terminal
            "hammerspoon"           # App launcher, small scripts and stuff
            "karabiner-elements"    # Keyboard remaping
          ];
      };

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
            '';

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      system.defaults = {
        dock = {
            autohide = true;
            mru-spaces = false;
        };
        finder = {
            AppleShowAllExtensions = true;
            FXPreferredViewStyle = "clmv";
            FXRemoveOldTrashItems = true;
        };
      };

      # Anable touch id auth for sudo
      security.pam.services.sudo_local.touchIdAuth = true;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # air
    darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
      ];
    };

    # imac
    darwinConfigurations."imac" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
      ];
    };
  };
}
