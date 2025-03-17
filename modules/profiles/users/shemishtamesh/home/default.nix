{
  shared,
  username,
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

  home.username = username;
  home.homeDirectory =
    if (host.system == "aarch64-darwin") || (host.system == "x86_64-darwin") then
      "/Users/${username}"
    else
      "/home/${username}";

  stylix = {
    enable = true;
    base16Scheme = shared.theme.scheme;
    fonts = shared.theme.fonts;
  };

  # allowing unfree packages
  nixpkgs.config = import ./nixpkgs.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs.nix;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # WARNING: do not change this without reading docs
}
