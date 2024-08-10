{ pkgs }:
let
  functions = import ./functions.nix { inherit pkgs; };
  scheme = functions.importYaml "${pkgs.base16-schemes}/share/themes/irblack.yaml";
  images = functions.imagesFromScheme {
    screenWidth = 1920;
    screenHeight = 1080;
    inherit scheme;
  };
in
{
  inherit scheme;
  wallpaper = images.wallpaper;
  fonts = {
    serif = {
      package = pkgs.fira-code-symbols;
      name = "FiraCode Nerd Font";
    };

    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "FiraCode Nerd Font";
    };

    monospace = {
      package = pkgs.dejavu_fonts;
      name = "FiraCode Nerd Font";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "FiraCode Nerd Font";
    };
  };
}
