{
  host,
  shared,
  config,
  ...
}:
{
  stylix.targets.hyprlock.enable = false;
  programs.hyprlock = with config.lib.stylix.colors; {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };
      input-field = {
        size = "50, 50";
        outline_thickness = 0;
        fade_on_empty = true;
        fade_timeout = 1000;
        fail_timeout = 2000;
        rounding = -1;
        placeholder_text = "";
        fail_text = "X";
        halign = "center";
        valign = "bottom";
        position = "0, 90";
        outer_color = "rgba(0, 0, 0, 0.0)";
        inner_color = "rgb(${base02})";
        font_color = "rgb(${base07})";
        check_color = "rgb(${base11})";
        fail_color = "rgb(${base08}";
        capslock_color = "rgb(${base10})";
        numlock_color = "rgb(${base10})";
        bothlock_color = "rgb(${base10})";
      };
      label = [
        {
          text = "cmd[update:1000] date '+%Y-%m-%d %H:%M:%S'";
          font_size = 22;
          position = "0, 50";
          halign = "center";
          valign = "bottom";
          color = "rgb(${base07})";
        }
        {
          text = "$LAYOUT";
          font_size = 14;
          position = "0, 30";
          halign = "center";
          valign = "bottom";
          color = "rgb(${base07})";
        }
        {
          text = "$FAIL";
          font_size = 14;
          position = "0, 10";
          halign = "center";
          valign = "bottom";
          color = "rgb(${base07})";
        }
      ];
      background = builtins.attrValues (
        builtins.mapAttrs (
          portname:
          {
            width,
            height,
            ...
          }:
          {
            monitor = portname;
            path = toString (shared.theme.wallpaper { inherit portname width height; });
            blur_passes = 3;
            brightness = 0.5;
          }
        ) host.monitors
      );
    };
  };
}
