{ inputs, ... }:
{
  imports = [ ./services ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  programs.zsh.enable = true;

  system.defaults = {
    dock = {
      autohide = true;
      largesize = 128;
      tilesize = 16;
      magnification = true;
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

  # use touch id auth for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # prevent `error: Build user group has mismatching GID, aborting activation`
  ids.gids.nixbld = 30000;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  # Set Git commit hash for darwin-version.
  system.configurationRevision = with inputs; self.rev or self.dirtyRev or null;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
