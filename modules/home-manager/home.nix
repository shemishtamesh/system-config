{ inputs, pkgs, theme, ... }:

{
  imports = [
    ../apps/hyprland.nix
    ../apps/hyprpaper.nix
    ../apps/hyprlock.nix
    ../apps/zsh.nix
    ../apps/waybar.nix
    ../apps/wlogout.nix
    ../apps/kitty.nix
    ../apps/git.nix
  ];

  home.username = "shemishtamesh";
  home.homeDirectory = "/home/shemishtamesh";

  inherit theme;

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # WARNING: do not change this without reading docs
}
