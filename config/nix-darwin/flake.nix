{
  description = "Multi-platform nix flake for macOS and Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    # Common packages for all platforms
    commonPackages = pkgs: with pkgs; [
      neovim                # Text Editor
      tmux                  # Multiplexer
      skim                  # Fuzzy Finder
      bat                   # better cat
      ripgrep               # better grep
      oh-my-zsh             # Oh My Zsh!
      rustup                # rust, rust-analyzer, cargo...
      nodejs                # NodeJs
      yt-dlp                # yt-dlp
      btop                  # btop
      wget                  # wget
      pkg-config            # pkg-config
      uv                    # python package manager
    ];

    # Linux-specific packages (apps that are installed via Homebrew on macOS)
    linuxOnlyPackages = pkgs: with pkgs; [
      ffmpeg                # ffmpeg
      alacritty             # Terminal
      ghostty               # Terminal
      firefox               # Firefox
    ];

    # macOS specific configuration
    mac = { pkgs, config, ... }: {
      homebrew = {
          enable = true;
          onActivation.cleanup = "uninstall";

          taps = [];
          brews = [
            "ffmpeg"                # ffmpeg
          ];
          casks = [ 
            "alacritty"             # Terminal
            "ghostty"               # What is better than one terminal?
            "hammerspoon"           # App launcher, small scripts and stuff
            "karabiner-elements"    # Keyboard remaping
            "firefox"               # FireFox
            "discord"               # Discord
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

      # Enable touch id auth for sudo
      security.pam.services.sudo_local.touchIdAuth = true;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      
      environment.systemPackages = (commonPackages pkgs) ++ (with pkgs; [
        mkalias               # Make Alias for mac apps (so they appear in spotlight)
      ]);
    };

    # Base configuration for both platforms
    baseConfiguration = { pkgs, config, ... }: {
      # Configures nix to be able to download non open source packages
      nixpkgs.config.allowUnfree = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;
    };

    # Linux home-manager configuration
    linuxHomeConfig = { pkgs, ... }: {
      home.username = "niemand";  # Replace with your actual username
      home.homeDirectory = "/home/niemand";  # Replace with your actual home directory
      home.stateVersion = "24.05";

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      home.packages = (commonPackages pkgs) ++ (linuxOnlyPackages pkgs);

      # Let Home Manager install and manage itself
      programs.home-manager.enable = true;
    };
  in
  {
    # Build darwin flake using:
    # darwin-rebuild switch --flake .#air
    darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
      modules = [ 
        mac
        baseConfiguration 
      ];
    };

    # darwin-rebuild switch --flake .#imac
    darwinConfigurations."imac" = nix-darwin.lib.darwinSystem {
      modules = [ 
        mac
        baseConfiguration 
      ];
    };

    # For Linux, use home-manager instead of nix-darwin
    # home-manager switch --flake .#win
    homeConfigurations."win" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [ linuxHomeConfig ];
    };

    # Alternative: You can also provide packages directly for nix profile
    packages.x86_64-linux = {
      win = nixpkgs.legacyPackages.x86_64-linux.buildEnv {
        name = "win-env";
        paths = (commonPackages nixpkgs.legacyPackages.x86_64-linux) ++ (linuxOnlyPackages nixpkgs.legacyPackages.x86_64-linux);
      };
    };

    packages.aarch64-darwin = {
      air = nixpkgs.legacyPackages.aarch64-darwin.buildEnv {
        name = "air-env";
        paths = commonPackages nixpkgs.legacyPackages.aarch64-darwin;
      };
      imac = nixpkgs.legacyPackages.aarch64-darwin.buildEnv {
        name = "imac-env";
        paths = commonPackages nixpkgs.legacyPackages.aarch64-darwin;
      };
    };
  };
}
