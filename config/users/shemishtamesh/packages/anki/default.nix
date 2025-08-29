{ inputs, host, ... }:
let
  stable-pkgs = inputs.nixpkgs-stable.legacyPackages."${host.system}";
in
{
  programs.anki = {
    enable = true;
    package = stable-pkgs.anki;
  };
}
