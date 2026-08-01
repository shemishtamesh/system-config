pkgs: scheme:
{
  width,
  height,
  name ? "wallpaper",
  color_scheme ? scheme,
  background ? true,
  palette ? true,
  nix ? true,
  gaps ? true,
  random ? true,
}:
let
  file_name = "${name}.png";
in
pkgs.stdenv.mkDerivation {
  name = file_name;
  buildInputs = [
    (pkgs.python3.withPackages (
      ps: with ps; [
        pillow
      ]
    ))
  ];
  src = ./theming/wallpaper_generator.py;
  unpackPhase = "true";
  buildPhase = ''
    python3 $src \
      ${file_name} \
      $(echo '${toString (builtins.attrValues color_scheme.palette)}') \
      --resolution ${toString width}x${toString height} \
      ${if !background then "--no_background" else ""} \
      ${if !palette then "--no_palette" else ""} \
      ${if !nix then "--no_nix" else ""} \
      ${if !gaps then "--gaps 0" else ""} \
      ${if !random then "--no_random" else ""} \
      # --no_color_outside_nix \
      # --distance_fade_scale "0.45" \
  '';
  installPhase = "install -Dm0644 ${file_name} $out";
}
