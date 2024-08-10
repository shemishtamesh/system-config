{ pkgs }:
let
  functions = import ./functions.nix { inherit pkgs; };
  # scheme = functions.importYaml "${pkgs.base16-schemes}/share/themes/irblack.yaml";
  scheme = functions.importYaml "${pkgs.base16-schemes}/share/themes/snow.yaml";
in
{
  inherit scheme;
  wallpaper = functions.nixWallpaperFromScheme {
    width = 1920;
    height = 1080;
    logoScale = 8;
    backgroundColor = scheme.palette.base00;
    logoColor1 = scheme.palette.base08;
    logoColor2 = scheme.palette.base09;
    logoColor3 = scheme.palette.base0A;
    logoColor4 = scheme.palette.base0B;
    logoColor5 = scheme.palette.base0C;
    logoColor6 = scheme.palette.base0D;
  };
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
