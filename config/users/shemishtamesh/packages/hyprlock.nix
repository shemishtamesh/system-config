{
  host,
  shared,
  config,
  ...
}:
{
  stylix.targets.hyprlock.enable = false;
  programs.hyprlock = {
    enable = true;
    settings = with config.lib.stylix.colors; {
      general = {
        hide_cursor = true;
      };
      input-field = {
        size = "50, 50";
        outline_thickness = 0;
        fade_on_empty = true;
        fade_timeout = 1000;
        rounding = -1;
        placeholder_text = "";
        fail_text = "$ATTEMPTS";
        halign = "center";
        valign = "center";
        outer_color = "rgba(0, 0, 0, 0.0)";
        inner_color = "rgba(0, 0, 0, 0.0)";
        font_color = "rgb(${base04})";
        check_color = "rgb(${base09})";
        fail_color = "rgb(${base08})";
        capslock_color = "rgb(${base0A})";
        numlock_color = "rgb(${base0A})";
        bothlock_color = "rgb(${base0A})";
      };
      label = [
        {
          text = "cmd[update:1000] date '+%Y-%m-%d %H:%M:%S'";
          font_size = 22;
          position = "0, 50";
          halign = "center";
          valign = "bottom";
          color = "rgb(${base04})";
        }
        {
          text = "$LAYOUT";
          font_size = 14;
          position = "0, 30";
          halign = "center";
          valign = "bottom";
          color = "rgb(${base01})";
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
            path = toString (
              shared.theme.wallpaper {
                inherit portname width height;
                background = false;
                palette = false;
                gaps = false;
                random = false;
              }
            );
            blur_passes = 2;
            brightness = 0.5;
          }
        ) host.monitors
      );
    };
  };
}
