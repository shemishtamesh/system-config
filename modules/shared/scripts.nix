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
      for bus in $(${ddcutil} detect --terse \
                        | grep -F "I2C bus:" \
                        | awk -F '-' '{print $2}'); do
          ${ddcutil} setvcp 10 $1 --bus "$bus"
      done
    ''
  );
}
