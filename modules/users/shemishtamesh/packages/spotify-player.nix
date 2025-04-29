{ pkgs, ... }:
{
  home.packages = [ pkgs.spotify-player ];
  programs.spotify-player.enable = true;
}
