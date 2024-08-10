{ config, pkgs, inputs, ... }:
let
  palette = config.lib.stylix.colors.withHashtag;
  rgba = (import ../utils/functions.nix { inherit pkgs; }).rgba config.lib.stylix.colors;
  icons = (import ../utils/theming.nix { inherit pkgs; }).icons;
in
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "reboot";
        action = "reboot";
        text = "reboot";
        keybind = "r";
      }
      {
        label = "logout";
        action = "logout";
        text = "logout";
        keybind = "o";
      }
      {
        label = "lock";
        action = "hyprlock";
        text = "lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "hibernate";
        keybind = "h";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "suspend";
        keybind = "s";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "shutdown";
        keybind = "p";
      }
    ];
    style = /* css */ ''
      * {
          background-image: none;
          box-shadow: none;
      }

      window {
          background-color: ${rgba "base00" "0.8"};
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
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }
      #logout {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }
      #suspend {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }
      #hibernate {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"));
      }
      #shutdown {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }
      #reboot {
          /* background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); */
          /* background-image: image(url("${pkgs.wlogout}/share/wlogout/assets/reboot.svg")); */
          background-image: image(url("${icons.reboot}"));
      }
    '';
  };
}

