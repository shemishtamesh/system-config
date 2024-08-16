{ pkgs, config, ... }:

{
  # stylix.targets.rofi.enable = false;
  programs.rofi.enable = true;
  programs.rofi = {
    package = pkgs.rofi-wayland;
    extraConfig = {
      show-icons = true;
      modi = "combi,drun,window,recursivebrowser,calc,char:rofimoji -f emoji*.csv math.csv nerd_font.csv";
      combi-modi = "drun,window,recursivebrowser,char:rofimoji -f emoji*.csv math.csv nerd_font.csv";
      sidebar-mode = true;
    };
    plugins = with pkgs; [ rofi-calc ];
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          width = 1012;
        };

        "#inputbar" = {
          children = map mkLiteral [ "prompt" "entry" ];
        };

        "#textbox-prompt-colon" = {
          expand = false;
          str = ":";
          margin = mkLiteral "0px 0.3em 0em 0em";
        };
      };
  };
  nixpkgs.overlays = [
    (final: prev: {
      rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
    })
  ];
}


