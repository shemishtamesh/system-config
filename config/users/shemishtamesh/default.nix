{
  shared,
  username,
  pkgs,
  host,
  ...
}:
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

  stylix = # TODO: remove the conditinal
    if host.hostname != "shemishtamac" then
      {
        inherit (shared.theme.stylix_settings)
          enable
          base16Scheme
          fonts
          cursor
          ;
        targets = {
          kde.enable = true;
          qt.enable = true;
        };
      }
    else
      with shared.theme.stylix_settings;
      {
        enable = false;
        inherit base16Scheme fonts;
      };

  # allowing unfree packages
  nixpkgs.config = import ./nixpkgs.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs.nix;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
