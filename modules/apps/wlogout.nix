{ config, pkgs, inputs, lib, ... }:
let
  palette = config.lib.stylix.colors.withHashtag;
  functions = (import ../general/functions.nix { inherit pkgs; });
  rgba = functions.rgba config.lib.stylix.colors;
  imageFromScheme = functions.imageFromScheme {
    width = 500;
    height = 500;
  };
  rebootIcon = imageFromScheme {
    svgText = builtins.replaceStrings [ "<path d=" ]
      [ ''<path fill="${palette.base0C}" d='' ] (lib.strings.fileContents
        "${pkgs.wlogout}/share/wlogout/assets/reboot.svg");
    name = "rebootIcon";
  };
  lockIcon = imageFromScheme {
    svgText = builtins.replaceStrings [ "<path d=" ]
      [ ''<path fill="${palette.base0C}" d='' ] (lib.strings.fileContents
        "${pkgs.wlogout}/share/wlogout/assets/lock.svg");
    name = "lockIcon";
  };
  suspendIcon = imageFromScheme {
    svgText = builtins.replaceStrings [ "<path d=" ]
      [ ''<path fill="${palette.base0C}" d='' ] (lib.strings.fileContents
        "${pkgs.wlogout}/share/wlogout/assets/suspend.svg");
    name = "suspendIcon";
  };
  logoutIcon = imageFromScheme {
    svgText = builtins.replaceStrings [ "<path d=" ]
      [ ''<path fill="${palette.base0C}" d='' ] (lib.strings.fileContents
        "${pkgs.wlogout}/share/wlogout/assets/logout.svg");
    name = "logoutIcon";
  };
  hibernateIcon = imageFromScheme {
    svgText = builtins.replaceStrings [ "<path d=" ]
      [ ''<path fill="${palette.base0C}" d='' ] (lib.strings.fileContents
        "${pkgs.wlogout}/share/wlogout/assets/hibernate.svg");
    name = "hibernateIcon";
  };
  shutdownIcon = imageFromScheme {
    svgText = builtins.replaceStrings [ "<path d=" ]
      [ ''<path fill="${palette.base0C}" d='' ] (lib.strings.fileContents
        "${pkgs.wlogout}/share/wlogout/assets/shutdown.svg");
    name = "shutdownIcon";
  };
in {
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "o";
      }
      {
        label = "shutdown";
        action = "shutdown now";
        text = "Shutdown";
        keybind = "d";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "reboot";
        text = "Reboot";
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

