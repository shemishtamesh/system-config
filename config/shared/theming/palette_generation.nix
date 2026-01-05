pkgs:
{
  palette_name ? "default_color_palette",
  variant ? "dark",
  mix_color ? "lightblue",
  mix_factor ? "0.6",
  saturation ? "0.3",
  desaturation ? "0.0",
  gradient_desaturation ? "0.0",
  lightening ? "0.05",
  darkening ? "0.0",
  brightness_difference ? "0.05",
  colorspace ? "OkLab",
}:
(import ../functions.nix pkgs).importYaml (
  pkgs.stdenv.mkDerivation {
    name = palette_name;
    buildInputs = with pkgs; [
      pastel
      bc
    ];
    src = ./base24_palette_generator.sh;
    env = {
      inherit
        palette_name
        variant
        mix_color
        mix_factor
        saturation
        desaturation
        gradient_desaturation
        lightening
        darkening
        brightness_difference
        colorspace
        ;
    };
    unpackPhase = "true";
    buildPhase = ''bash "$src" > ${palette_name}.yaml'';
    installPhase = ''install -Dm0644 ${palette_name}.yaml "$out"'';
  }
)
