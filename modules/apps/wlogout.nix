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
        label = "lock";
        action = "swaylock";
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
        keybind = "s";
      }
      {
        label = "suspend";
        action = "loginctl suspend";
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
          background-image: image(url("/home/shemishtamesh/testicons/lock.svg"));
      }
      #logout {
          background-image: image(url("/home/shemishtamesh/testicons/logout.svg"));
      }
      #suspend {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }
      #hibernate {
          background-image: image(url("/home/shemishtamesh/testicons/hibernate.svg"));
      }
      #shutdown {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/assets/shutdown.svg"));
      }
      #reboot {
          background-image: image(url("/home/shemishtamesh/testicons/reboot.svg"));
      }
    '';
  };
}

