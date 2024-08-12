{ pkgs, ... }:

{
  programs.rofi.enable = true;
  programs.rofi = {
    package = pkgs.rofi-wayland;
    extraConfig = {
      show-icons = true;
      # modi = "combi,drun,run,ssh,keys,recursivebrowser,filebrowser";
      # modi = "combi,drun,run,ssh,keys,recursivebrowser,filebrowser,emoji:rofimoji";
      modi = "combi,drun,run,ssh,keys,recursivebrowser,filebrowser,󰻐:rofimoji -f *";
      # modi = "combi,drun,run,ssh,keys,recursivebrowser,filebrowser,emoji,calc";
      sidebar-mode = true;
    };
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
}
