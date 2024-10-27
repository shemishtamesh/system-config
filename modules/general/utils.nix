{ pkgs }:
let
  ddcutil = "${pkgs.ddcutil}/bin/ddcutil";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  bc = "${pkgs.bc}/bin/bc";
in
{
  importYaml =
    file:
    builtins.fromJSON (
      builtins.readFile (
        pkgs.runCommandNoCC "converted-yaml.json" { } ''
          ${pkgs.yj}/bin/yj < "${file}" > "$out"
        ''
      )
    );
  rgba =
    palette: color: opacity:
    let
      r = palette."${color}-rgb-r";
      g = palette."${color}-rgb-g";
      b = palette."${color}-rgb-b";
    in
    "rgba(${r}, ${g}, ${b}, ${builtins.toString opacity})";
  imageFromScheme =
    { width, height }:
    { svgText, name }:
    pkgs.stdenv.mkDerivation {
      name = "generated-${name}.png";
      src = pkgs.writeTextFile {
        name = "template.svg";
        text = svgText;
      };
      buildInputs = with pkgs; [ inkscape ];
      unpackPhase = "true";
      buildPhase = ''
        inkscape --export-type="png" $src -w ${toString width} -h ${toString height} -o ${name}.png
      '';
      installPhase = "install -Dm0644 ${name}.png $out";
    };
  sync_external_monitor_brightness = # sh
    "${ddcutil} setvcp 10 $(echo \"$(echo \"$(${brightnessctl} g) / $(${brightnessctl} m) * 100\" | ${bc} -l | ${bc}) / 1\" | ${bc})";
  notification-log = pkgs.writeShellScriptBin "notification-log" ''
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
  '';
}
