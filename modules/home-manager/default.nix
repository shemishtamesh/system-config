{ theme, ... }:

{
  imports = [
    ./packages
    ./environment_variables.nix
    ./scripts.nix
    ./packages/hypridle.nix
    ./packages/hyprpaper.nix
    ./packages/hyprlock.nix
    ./packages/hyprland.nix
    ./packages/waybar.nix
    ./packages/wlogout.nix
    ./packages/dunst.nix
    ./packages/rofi.nix
    ./packages/kitty.nix
    ./packages/git.nix
    ./packages/zsh.nix
    ./packages/starship.nix
    ./packages/zoxide.nix
    ./packages/fzf.nix
    ./packages/direnv.nix
    ./packages/tmux.nix
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
    indicator = true;
  };

  # allowing unfree packages
  nixpkgs.config = import ./nixpkgs.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs.nix;
  programs.home-manager.useGlobalPkgs = true;
  programs.home-manager.useUserPackages = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # WARNING: do not change this without reading docs
}
