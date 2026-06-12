{
  username,
  pkgs,
  shared,
  ...
}:
{
  imports = [
    ./packages
    ./services.nix
    ./environment_variables.nix
    ./scripts.nix
    ./theme.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/${if pkgs.stdenv.isDarwin then "Users" else "home"}/${username}";

    stateVersion = "24.05"; # WARNING: do not change this without reading docs
  };

  xdg.enable = true;

  # allowing unfree packages
  nixpkgs.config = shared.nixpkgs_config;
  xdg.configFile."nixpkgs/config.nix".text = pkgs.lib.generators.toPretty { } shared.nixpkgs_config;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
