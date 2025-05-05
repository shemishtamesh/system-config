{
  shared,
  inputs,
  host,
  ...
}:
{
  imports = [
    ./services
    ./homebrew.nix
  ];

  # Enable alternative shell support in nix-darwin.
  programs.zsh.enable = true;

  system = {
    defaults = {
      dock = {
        autohide = true;
        largesize = 128;
        tilesize = 16;
        magnification = true;
        show-recents = false;
      };
      finder = {
        FXPreferredViewStyle = "clmv";
        AppleShowAllFiles = true;
        FXEnableExtensionChangeWarning = false;
        ShowPathbar = true;
      };
      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
        AppleInterfaceStyle = "Dark";
        AppleShowAllExtensions = true;
      };
      magicmouse.MouseButtonMode = "TwoButton";
    };

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;

    # Set Git commit hash for darwin-version.
    configurationRevision = with inputs; self.rev or self.dirtyRev or null;
  };

  stylix = with shared.theme.stylix_settings; {
    inherit enable base16Scheme fonts cursor;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = (builtins.attrNames host.users);
  };

  # use touch id auth for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # prevent `error: Build user group has mismatching GID, aborting activation`
  ids.gids.nixbld = 30000;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = host.system;
}
