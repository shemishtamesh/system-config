{
  config,
  pkgs,
  lib,
  shared,
  ...
}:
let
  palette = config.lib.stylix.colors.withHashtag;
  rgba = shared.utils.rgba config.lib.stylix.colors;
  svgToPng =
    remaining:
    shared.utils.svgToPng (
      {
        width = 500;
        height = 500;
      }
      // remaining
    );
  rebootIcon = svgToPng {
    svgText = builtins.replaceStrings [ "<path d=" ] [ ''<path fill="${palette.base0C}" d='' ] (
      lib.strings.fileContents "${pkgs.wlogout}/share/wlogout/assets/reboot.svg"
    );
    name = "rebootIcon";
  };
  lockIcon = svgToPng {
    svgText = builtins.replaceStrings [ "<path d=" ] [ ''<path fill="${palette.base0C}" d='' ] (
      lib.strings.fileContents "${pkgs.wlogout}/share/wlogout/assets/lock.svg"
    );
    name = "lockIcon";
  };
  suspendIcon = svgToPng {
    svgText = builtins.replaceStrings [ "<path d=" ] [ ''<path fill="${palette.base0C}" d='' ] (
      lib.strings.fileContents "${pkgs.wlogout}/share/wlogout/assets/suspend.svg"
    );
    name = "suspendIcon";
  };
  logoutIcon = svgToPng {
    svgText = builtins.replaceStrings [ "<path d=" ] [ ''<path fill="${palette.base0C}" d='' ] (
      lib.strings.fileContents "${pkgs.wlogout}/share/wlogout/assets/logout.svg"
    );
    name = "logoutIcon";
  };
  hibernateIcon = svgToPng {
    svgText = builtins.replaceStrings [ "<path d=" ] [ ''<path fill="${palette.base0C}" d='' ] (
      lib.strings.fileContents "${pkgs.wlogout}/share/wlogout/assets/hibernate.svg"
    );
    name = "hibernateIcon";
  };
  shutdownIcon = svgToPng {
    svgText = builtins.replaceStrings [ "<path d=" ] [ ''<path fill="${palette.base0C}" d='' ] (
      lib.strings.fileContents "${pkgs.wlogout}/share/wlogout/assets/shutdown.svg"
    );
    name = "shutdownIcon";
  };
in
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "[l]ock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "[h]ibernate";
        keybind = "h";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "l[o]gout";
        keybind = "o";
      }
      {
        label = "shutdown";
        action = "shutdown now";
        text = "shut[d]own";
        keybind = "d";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "[s]uspend";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "reboot";
        text = "[r]eboot";
        keybind = "r";
      }
    ];
    style = # css
      ''
        * {
            background-image: none;
            box-shadow: none;
        }

        window {
            background-color: ${rgba "base00" 0.8};
        }

        button {
            border-radius: 10px;
            color: ${palette.base05};
            background-color: ${palette.base01};
            border-style: solid;
            border-width: 0;
            background-repeat: no-repeat;
            background-position: center;
            background-size: 25%;
            margin: 2px;
        }

        button:focus, button:active, button:hover {
            background-color: ${palette.base02};
            outline-style: none;
        }

        #lock {
            background-image: url("${lockIcon}");
        }
        #logout {
            background-image: url("${logoutIcon}");
        }
        #suspend {
            background-image: url("${suspendIcon}");
        }
        #hibernate {
            background-image: url("${hibernateIcon}");
        }
        #shutdown {
            background-image: url("${shutdownIcon}");
        }
        #reboot {
            background-image: url("${rebootIcon}");
        }
      '';
  };
}
