{ pkgs, config, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
  palette = config.lib.stylix.colors.withHashtag;
  rgba = (import ../general/functions.nix { inherit pkgs; }).rgba config.lib.stylix.colors;
in
{
  stylix.targets.rofi.enable = false;
  programs.rofi.enable = true;
  programs.rofi = {
    package = pkgs.rofi-wayland;
    extraConfig = {
      show-icons = true;
      modi = "combi,drun,window,recursivebrowser,calc,char:rofimoji -f emoji*.csv math.csv nerd_font.csv --use-icons";
      combi-modi = "drun,window,recursivebrowser,calc,char:rofimoji -f emoji*.csv math.csv nerd_font.csv --use-icons";
      sidebar-mode = true;
    };
    plugins = with pkgs; [ rofi-calc ];
    theme = {
      "*" = {
        bg0 = mkLiteral rgba "base00" 0.8;
        bg1 = mkLiteral palette.base01;
        bg2 = mkLiteral rgba "base06" 0.2;
        bg3 = mkLiteral rgba "base07" 0.4;
        bg4 = mkLiteral rgba "base0D" 0.8;

        fg0 = mkLiteral palette.base07;
        fg1 = mkLiteral rgba "base07" 0.8;

        # bg0 = mkLiteral "#242424";
        # bg1 = mkLiteral "#363636";
        # bg2 = mkLiteral "#f5f5f5";
        # bg3 = mkLiteral "#f5f5f5";
        # bg4 = mkLiteral "#0860f2";

        # fg0 = mkLiteral "#f5f5f5";
        # fg1 = mkLiteral "#f5f5f5";

        # bg0 = mkLiteral "#24242480";
        # bg1 = mkLiteral "#363636";
        # bg2 = mkLiteral "#f5f5f520";
        # bg3 = mkLiteral "#f5f5f540";
        # bg4 = mkLiteral "#0860f2E6";

        # fg0 = mkLiteral "#f5f5f5";
        # fg1 = mkLiteral "#f5f5f580";

        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";
        padding = mkLiteral "0px";
        margin = mkLiteral "0px";
      };

      window = {
        fullscreen = true;
        padding = mkLiteral "1em";
        background-color = mkLiteral "@bg0";
      };

      mainbox = {
        padding = mkLiteral "8px";
      };

      inputbar = {
        background-color = mkLiteral "@bg2";

        margin = mkLiteral "0px calc( 50% - 120px )";
        padding = mkLiteral "2px 4px";
        spacing = mkLiteral "4px";

        border = mkLiteral "1px";
        border-radius = mkLiteral "2px";
        border-color = mkLiteral "@bg3";

        children = mkLiteral "[icon-search,entry]";
      };

      prompt = {
        enabled = false;
      };

      icon-search = {
        expand = false;
        filename = "search";
        vertical-align = mkLiteral "0.5";
      };

      entry = {
        placeholder = "Search";
        placeholder-color = mkLiteral "@bg2";
      };

      listview = {
        margin = mkLiteral "48px calc( 50% - 560px )";
        spacing = mkLiteral "48px";
        columns = 6;
      };

      "element, element-text, element-icon" = {
        cursor = "pointer";
      };

      element = {
        padding = mkLiteral "8px";
        spacing = mkLiteral "4px";

        orientation = mkLiteral "vertical";
        border-radius = mkLiteral "16px";
      };

      "element selected" = {
        background-color = mkLiteral "@bg4";
      };

      element-icon = {
        size = mkLiteral "4em";
        horizontal-align = mkLiteral "0.5";
      };

      element-text = {
        horizontal-align = "0.5";
      };
    };
  };
  nixpkgs.overlays = [
    (final: prev: {
      rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
    })
    (final: prev: {
      # see https://github.com/svenstaro/rofi-calc/issues/117
      libqalculate = prev.libqalculate.overrideAttrs (_: rec {
        pname = "libqalculate";
        version = "4.8.1";

        src = pkgs.fetchFromGitHub {
          owner = "qalculate";
          repo = "libqalculate";
          rev = "v${version}";
          sha256 = "sha256-4WqKlwVf4/ixVr98lPFVfNL6EOIfHHfL55xLsYqxkhY=";
        };
      });
    })
  ];
}


