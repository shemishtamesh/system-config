{ inputs, pkgs, ... }:
let
  # colorScheme = inputs.nix-colors.colorSchemes.irblack;
  colorScheme = inputs.nix-colors.colorSchemes.black-metal;
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./modules/hyprland.nix
    ./modules/hyprpaper.nix
    # ./modules/hyprlock.nix
    ./modules/zsh.nix
    ./modules/waybar.nix
    ./modules/wlogout.nix
    ./modules/kitty.nix
    ./modules/git.nix
  ];

  home.username = "shemishtamesh";
  home.homeDirectory = "/home/shemishtamesh";

  inherit colorScheme;

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # WARNING: do not change this without reading docs
}
