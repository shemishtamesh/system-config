{
  shared,
  username,
  pkgs,
  ...
}:
{
  imports = [
    ./packages
    ./services.nix
    ./environment_variables.nix
    ./scripts.nix
  ];

  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  stylix = {
    enable = true;
    base16Scheme = shared.theme.scheme;
    fonts = shared.theme.fonts;
    cursor = {
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  # allowing unfree packages
  nixpkgs.config = import ./nixpkgs.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs.nix;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # WARNING: do not change this without reading docs
}
