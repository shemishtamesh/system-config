{ inputs, pkgs, ... }:
let
  colorScheme = inputs.nix-colors.colorSchemes.irblack;
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    # ./modules/apps/hyprland.nix
    ./modules/apps/hyprpaper.nix
    # ./modules/apps/hyprlock.nix
    # ./modules/apps/zsh.nix
    # ./modules/apps/waybar.nix
    # ./modules/apps/wlogout.nix
    # ./modules/apps/kitty.nix
    # ./modules/apps/git.nix
  ];

  home.username = "shemishtamesh";
  home.homeDirectory = "/home/shemishtamesh";

  inherit colorScheme;

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # WARNING: do not change this without reading docs
}
