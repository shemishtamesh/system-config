{ pkgs, ... }:

{
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
    style = /* css */ ''
      * {
          bg0:    #2E3440F2;
          bg1:    #3B4252;
          bg2:    #4C566A80;
          bg3:    #88C0D0F2;
          fg0:    #D8DEE9;
          fg1:    #ECEFF4;
          fg2:    #D8DEE9;
          fg3:    #4C566A;
      }

      @import "rounded-common.rasi"

      element selected {
          text-color: @bg1;
      }
    '';
  };
  nixpkgs.overlays = [
    (final: prev: {
      rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
    })
  ];
}


