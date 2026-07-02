{ pkgs, ... }:
let
  version = "2.9.0";
in
{
  home.packages = [
    (pkgs.appimageTools.wrapType2 {
      pname = "silverbullet-plus";
      inherit version;
      src = pkgs.fetchurl {
        url = "https://releases.silverbullet.plus/releases/${version}/SilverBullet_x86_64.AppImage";
        hash = "sha256-GtiLG6cnZIwwMGjINYEzboCTi+0weUX7zvrtmgA7y4c=";
      };
    })
  ];
}
