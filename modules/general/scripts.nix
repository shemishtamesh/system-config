{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "rebuild" ''
      FLAKE="$HOME/.config/flake"

      ''${pkgs.nixfmt-rfc-style} $FLAKE

      git -C $FLAKE add .
      git -C $FLAKE commit -m 'rebuilding nixos'
      nh os switch $FLAKE
      if [ $? -ne 0 ] ; then
        notify-send -u critical 'nixos rebuild failed'
        exit 1
      fi

      git -C $FLAKE add .
      git -C $FLAKE commit -m 'rebuilding home'
      nh home switch $FLAKE
      if [ $? -ne 0 ] ; then
        notify-send -u critical 'home rebuild failed'
        exit 1
      fi

      systemctl --user restart hyprpaper.service
      if [ $? -ne 0 ] ; then
        notify-send -u critical 'wallpaper switch failed'
        exit 1
      fi

      notify-send -u low 'rebuild succeed'
    '')

    (pkgs.writeShellScriptBin "notification-log" ''
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
    '')

    (pkgs.writeShellScriptBin "bak" ''
      filename="$1"
      if [[ "$filename" =~ .bak$ ]]; then
          mv "$filename" "''${filename%.bak}";
          exit 0;
      else
          mv "$filename" "$filename.bak";
          exit 0;
      fi
      echo "Error: $filename is not a valid file or directory.";
      exit 1;
    '')
  ];
}
