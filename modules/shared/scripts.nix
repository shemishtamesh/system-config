pkgs:
let
  ddcutil = "${pkgs.ddcutil}/bin/ddcutil";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  bc = "${pkgs.bc}/bin/bc";
in
{
  sync_external_monitors_brightness = pkgs.lib.getExe (
    pkgs.writeShellScriptBin "sync_external_monitors_brightness" ''
      ${ddcutil} setvcp 10 $(echo \"$(echo \"$(${brightnessctl} g) / $(${brightnessctl} m) * 100\" | ${bc} -l | ${bc}) / 1\" | ${bc})
    ''
  );
  set_brightness = pkgs.lib.getExe (
    pkgs.writeShellScriptBin "set_brightness" ''
      ${ddcutil} getvcp 10 \
        | awk -F 'current value = ' '{print $2}' \
        | awk -F',' '{print $1}' \
        | grep '[0-9]' \
        | sed 's/[^0-9]//g' \
        > /tmp/previous_brightness
      for bus in $(${ddcutil} detect --terse | grep -F "I2C bus:" | awk -F '-' '{print $2}'); do
        ${ddcutil} setvcp 10 $1 \
          --bus "$bus" \
          --mccs 2.2 \
          --sleep-multiplier 3 \
          --disable-dynamic-sleep
      done
    ''
  );
}
