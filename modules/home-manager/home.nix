{ inputs, pkgs, theme, ... }:

{
  imports = [
    # ../apps/hypridle.nix
    ../apps/hyprpaper.nix
    ../apps/hyprlock.nix
    ../apps/hyprland.nix
    ../apps/waybar.nix
    ../apps/wlogout.nix
    ../apps/dunst.nix
    ../apps/rofi.nix
    ../apps/kitty.nix
    ../apps/git.nix
    ../apps/zsh.nix
    ../apps/starship.nix
    ../apps/zoxide.nix
    ../apps/fzf.nix
  ];

  home.username = "shemishtamesh";
  home.homeDirectory = "/home/shemishtamesh";

  stylix = {
    enable = true;
    base16Scheme = theme.scheme;
    image = theme.wallpaper;
    fonts = theme.fonts;
  };

  services.kdeconnect = {
    enable = true;
    # package = pkgs.kdePackages.kdeconnect-kde;
    indicator = true;
  };

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # WARNING: do not change this without reading docs
}
