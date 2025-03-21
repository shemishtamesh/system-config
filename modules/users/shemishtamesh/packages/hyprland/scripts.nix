{
  pkgs,
  gaps,
  rounding,
}:
{
  toggle-bar = pkgs.lib.getExe (
    pkgs.writeShellScriptApplication {
      name = "toggle-bar";
      runtimeInputs = with pkgs; [ killall ];
      text = # sh
        ''
          killall .waybar-wrapped
          if [[ $? -eq 0 ]]; then
              hyprctl keyword general:border_size 0;
              hyprctl keyword general:gaps_in 0
              hyprctl keyword general:gaps_out 0
              hyprctl keyword decoration:rounding 0
              hyprctl keyword decoration:shadow:enabled 1
              hyprctl keyword decoration:shadow:range 50
              exit 0
          fi

          hyprctl keyword general:border_size 1;
          hyprctl keyword general:gaps_in ${gaps}
          hyprctl keyword general:gaps_out ${gaps}
          hyprctl keyword decoration:rounding ${rounding}
          hyprctl keyword decoration:shadow:enabled 0
          waybar
        '';
    }
  );
  notification-log = pkgs.lib.getExe (
    pkgs.writeShellScriptBin "notification-log" ''
      logfile=$1

      declare -a MSGBUF
      STATE=off
      MSGTIME=

      printbuf() {
        JOINED=$( echo "''${MSGBUF[@]}" | sed 's/,$//' )
        printf "%s\n%s\n\n" "--- ''${MSGTIME} ---" "''${JOINED}"
      }

      procmsg() {
        if [[ "''${1}" =~ member=Notify$ ]]; then
          STATE=on
          MSGTIME=$(date '+%Y-%m-%d %H:%M:%S')
          MSGBUF=()
        elif [[ "''${1}" =~ member=NotificationClosed$ ]]; then
          STATE=off
          printbuf
        else
          if [[ "''${STATE}" == "on" ]]; then
            if [[ "''${1}" =~ ^string ]]; then
              case "''${1}" in
                "string \"\"") ;;
                "string \"urgency\"") ;;
                "string \"sender-pid\"") ;;
                *)
                  MSGBUF+=$( echo -n "''${1}," )
                ;;
              esac
            fi
          fi
        fi
      }

      dbus-monitor "interface='org.freedesktop.Notifications'" | \
          while read -r line; do
            procmsg "$line" >> "$logfile"
          done
    ''
  );
}
