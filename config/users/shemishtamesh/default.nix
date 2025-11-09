{
  shared,
  username,
  pkgs,
  ...
}:
let
  nixpkgs_config = (import ./nixpkgs.nix) pkgs;
in
{
  imports = [
    ./packages
    ./services.nix
    ./environment_variables.nix
    ./scripts.nix
  ];

  home = {
    inherit username;
    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

    stateVersion = "24.05"; # WARNING: do not change this without reading docs
  };

  stylix = shared.theme.stylix_settings;

  # allowing unfree packages
  nixpkgs.config = nixpkgs_config.object;
  xdg.configFile."nixpkgs/config.nix".source = nixpkgs_config.file;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
