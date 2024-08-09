{ inputs, pkgs, theme, ... }:

{
  imports = [
    ../apps/hyprpaper.nix
    ../apps/hyprlock.nix
    ../apps/hyprland.nix
    ../apps/zsh.nix
    ../apps/waybar.nix
    ../apps/wlogout.nix
    ../apps/kitty.nix
    ../apps/git.nix
  ];

  home.username = "shemishtamesh";
  home.homeDirectory = "/home/shemishtamesh";

  stylix.enable = true;
  stylix.targets.waybar.enable = false;
  stylix.base16Scheme = theme.scheme;
  stylix.image = theme.wallpaper;

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # WARNING: do not change this without reading docs
}
