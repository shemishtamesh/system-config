{ config, pkgs, inputs, ... }:
let
  rgb = hex: (inputs.nix-colors.lib.conversions.hexToRGBString "," hex);
  palette = config.colorScheme.palette;
in
{
    programs.wlogout = {
        enable = true;
        style = /* css */ ''
            * {
                background-image: none;
                box-shadow: none;
            }

            window {
                background-color: rgba(${rgb palette.base00}, 0.8);
            }

            button {
                border-radius: 10px;
                border-color: #${palette.base07};
                text-decoration-color: #${palette.base07};
                color: #${palette.base07};
                background-color: #${palette.base01};
                border-style: solid;
                border-width: 0;
                background-repeat: no-repeat;
                background-position: center;
                background-size: 25%;
                margin: 2px;
            }

            button:focus, button:active, button:hover {
                background-color: #${palette.base08};
                outline-style: none;
            }

            #lock {
                background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"), url("/usr/local/share/wlogout/icons/lock.png"));
            }
            #logout {
                background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"), url("/usr/local/share/wlogout/icons/logout.png"));
            }
            #suspend {
                background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"), url("/usr/local/share/wlogout/icons/suspend.png"));
            }
            #hibernate {
                background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"), url("/usr/local/share/wlogout/icons/hibernate.png"));
            }
            #shutdown {
                background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"), url("/usr/local/share/wlogout/icons/shutdown.png"));
            }
            #reboot {
                background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"), url("/usr/local/share/wlogout/icons/reboot.png"));
            }
        '';
    };
}

