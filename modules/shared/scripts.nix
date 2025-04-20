pkgs: {
  sync_external_monitors_brightness =
    let
      ddcutil = "${pkgs.ddcutil}/bin/ddcutil";
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      bc = "${pkgs.bc}/bin/bc";
    in
    # sh
    pkgs.lib.getExe (
      pkgs.writeShellScriptBin "sync_external_monitors_brightness" ''
        ${ddcutil} setvcp 10 $(echo \"$(echo \"$(${brightnessctl} g) / $(${brightnessctl} m) * 100\" | ${bc} -l | ${bc}) / 1\" | ${bc})
      ''
    );
}
