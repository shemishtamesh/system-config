{ theme, ... }:
let
  nixpkgs_config = # nix
    "{ allowBroken = true; }";
in
{
  imports = [
    ./home/packages.nix
    ./home/environment_variables.nix
    ./home/scripts.nix
    ./home/apps/hypridle.nix
    ./home/apps/hyprpaper.nix
    ./home/apps/hyprlock.nix
    ./home/apps/hyprland.nix
    ./home/apps/waybar.nix
    ./home/apps/wlogout.nix
    ./home/apps/dunst.nix
    ./home/apps/rofi.nix
    ./home/apps/kitty.nix
    ./home/apps/git.nix
    ./home/apps/zsh.nix
    ./home/apps/starship.nix
    ./home/apps/zoxide.nix
    ./home/apps/fzf.nix
    ./home/apps/direnv.nix
    ./home/apps/tmux.nix
    ./home/apps/nixvim/nixvim.nix
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

  nixpkgs.config = nixpkgs_config;
  xdg.configFile."nixpkgs/config.nix".source = nixpkgs_config;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # WARNING: do not change this without reading docs
}
