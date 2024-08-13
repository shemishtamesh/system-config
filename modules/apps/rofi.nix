{ pkgs, ... }:

{
  programs.rofi.enable = true;
  programs.rofi = {
    package = pkgs.rofi-wayland;
    extraConfig = {
      show-icons = true;
      modi = "drun,calc";
      # modi = "drun,window,recursivebrowser,calc,󰻐:rofimoji -f emoji*.csv math.csv nerd_font.csv";
      # modi = "combi,drun,window,recursivebrowser,󰻐:rofimoji -f emoji*.csv math.csv nerd_font.csv";
      # combi-modi = "drun,window,recursivebrowser,calc,󰻐:rofimoji -f emoji*.csv math.csv nerd_font.csv";
      # modi = "combi,drun,window,recursivebrowser,󰻐:rofimoji -f all";
      combi-modi = "drun,calc";
      sidebar-mode = true;
    };
    plugins = with pkgs; [ rofi-calc ];
    # plugins = with pkgs; [ rofi-calc rofi-emoji ];
    # plugins = with pkgs; [ rofimoji ];
    # plugins = with pkgs; [
    #   # HACK: temporary fix until ABI update
    #   (rofi-emoji.override {
    #     rofi-unwrapped = rofi-wayland-unwrapped;
    #   })
    #   (rofi-calc.override {
    #     rofi-unwrapped = rofi-wayland-unwrapped;
    #   })
    # ];
  };
  nixpkgs.overlays = [
    (final: prev: {
      rofi-calc = prev.rofi-calc.override { rofi = prev.rofi-wayland; };
    })
  ];
}
