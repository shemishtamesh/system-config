pkgs: {
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
}
