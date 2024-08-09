{ inputs, pkgs, ... }:
let
  colorScheme = inputs.nix-colors.colorSchemes.irblack;
  theme = (import ../utils/theming.nix { inherit pkgs; });
in
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../apps/hyprland.nix
    ../apps/hyprpaper.nix
    ../apps/hyprlock.nix
    ../apps/zsh.nix
    ../apps/waybar.nix
    ../apps/wlogout.nix
    # ../apps/kitty.nix
    ../apps/git.nix
  ];

  programs.kitty.enable = true;
  home.username = "shemishtamesh";
  home.homeDirectory = "/home/shemishtamesh";

  inherit colorScheme;


  stylix.base16Scheme = theme.scheme;
  stylix.image = theme.wallpaper;
  stylix.targets.kitty.enable = true;
  # stylix.targets.kitty.enable = false;
  # stylix.image = pkgs.fetchurl {
  #   url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
  #   sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  # };

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # WARNING: do not change this without reading docs
}
