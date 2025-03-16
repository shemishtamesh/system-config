{
  shared,
  username,
  pkgs,
  host,
  ...
}:
let
  linux_conf = {
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

    home.username = username;
    home.homeDirectory = "/home/${username}";

    stylix = {
      enable = true;
      base16Scheme = shared.theme.scheme;
      fonts = shared.theme.fonts;
    };

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    # allowing unfree packages
    nixpkgs.config = import ./nixpkgs.nix;
    xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs.nix;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    home.stateVersion = "24.05"; # WARNING: do not change this without reading docs
  };
  mac_conf = {
    home.username = username;
    home.homeDirectory = "/Users/${username}";

    home.packages = with pkgs; [
    ];

    programs.home-manager.enable = true;

    home.stateVersion = "23.05"; # Please read the docs before changing.
  };
in
if host.system == "aarch64-darwin" then mac_conf else linux_conf
