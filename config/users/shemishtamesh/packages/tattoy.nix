{ pkgs, ... }:
{
  home.packages = with pkgs; [ tattoy ];
  xdg.configFile = {
    "tattoy/tattoy.toml".text = # toml
      ''
      show_startup_logo = false
      show_tattoy_indicator = false

        scrollback_size = 10000

        [animated_cursor]
        enabled = true
        opacity = 1.0
        path = "shaders/cursors/smear_fade.glsl"
        cursor_scale = 0.0
      '';
  };
}
