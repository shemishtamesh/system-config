{
  stable-pkgs,
  ...
}:
{
  permittedInsecurePackages = [ "electron-39.8.10" ]; # TODO: remove this when https://github.com/NixOS/nixpkgs/issues/526914 is resolved

  home.packages = [ stable-pkgs.bitwarden-desktop ];
}
