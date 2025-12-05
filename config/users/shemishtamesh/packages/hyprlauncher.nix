{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [ hyprlauncher ];
    # xdg.configFile."hypr/hyprlauncher.conf".text = '' '';
  };
}
