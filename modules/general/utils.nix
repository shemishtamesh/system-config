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
    "${ddcutil} setvcp 10 $(echo \"$(${brightnessctl} g) / $(${brightnessctl} m) * 100\" | ${bc})";
}
