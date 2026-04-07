{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ hyprlauncher ];
  };
}
