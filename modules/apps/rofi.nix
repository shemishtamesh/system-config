{ pkgs, ... }:

{
  # programs.rofi.enable = true;
  programs.rofi = {
    package = pkgs.rofi-wayland;
    extraConfig = {
      show-icons = true;
      modi = "drun,run,window,files,emoji,calc";
      sidebar-mode = true;
    };
    # plugins = with pkgs; [ rofi-calc rofi-calc ];
    plugins = with pkgs; [
      # HACK: temporary fix until ABI update
      (rofi-emoji.override {
        rofi-unwrapped = rofi-wayland-unwrapped;
      })
      (rofi-calc.override {
        rofi-unwrapped = rofi-wayland-unwrapped;
      })
    ];
  };
}
