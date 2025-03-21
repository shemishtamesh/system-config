pkgs: {
  recursiveMerge =
    attrList:
    with pkgs.lib;
    let
      merge =
        attrPath:
        zipAttrsWith (
          name: values:
          if tail values == [ ] then
            head values
          else if all isList values then
            unique (concatLists values)
          else if all isAttrs values then
            merge (attrPath ++ [ name ]) values
          else
            last values
        );
    in
    merge [ ] attrList;
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
  svgToPng =
    {
      width,
      height,
      svgText,
      name,
    }:
    pkgs.stdenv.mkDerivation {
      name = "${name}.png";
      src = pkgs.writeTextFile {
        name = "${name}.svg";
        text = svgText;
      };
      buildInputs = with pkgs; [ inkscape ];
      unpackPhase = "true";
      buildPhase = ''
        inkscape --export-type="png" $src -w ${toString width} -h ${toString height} -o ${name}.png
      '';
      installPhase = "install -Dm0644 ${name}.png $out";
    };
  sync_external_monitors_brightness =
    let
      ddcutil = "${pkgs.ddcutil}/bin/ddcutil";
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      bc = "${pkgs.bc}/bin/bc";
    in
    # sh
    pkgs.lib.getExe (
      pkgs.writeShellScriptBin "sync_external_monitors_brightness" "${ddcutil} setvcp 10 $(echo \"$(echo \"$(${brightnessctl} g) / $(${brightnessctl} m) * 100\" | ${bc} -l | ${bc}) / 1\" | ${bc})"
    );
}
