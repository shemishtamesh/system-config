{ pkgs, ... }:

{
  programs.rofi.enable = true;
  programs.rofi = {
    package = pkgs.rofi-wayland;
    extraConfig = {
      show-icons = true;
      # modi = "drun,calc";
      # modi = "󱓟:rofi -show drun,:rofi -show window,󰈤:rofi -show recursivebrowser,:rofi -show calc,󰻐:rofimoji -f emoji*.csv math.csv nerd_font.csv";
      modi = "combi,drun,window,recursivebrowser,calc,char:rofimoji -f emoji*.csv math.csv nerd_font.csv";
      combi-modi = "drun,window,recursivebrowser,char:rofimoji -f emoji*.csv math.csv nerd_font.csv";
      # modi = "combi,drun,window,recursivebrowser,󰻐:rofimoji -f all";
      # combi-modi = "drun,calc"󱓟;
      sidebar-mode = true;
    };
    plugins = with pkgs; [ rofi-calc ];
  };
  nixpkgs.overlays = [
    (final: prev: {
      rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
    })
  ];
}
