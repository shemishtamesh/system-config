pkgs:
{
  palette_name,
  arguments ? {
    variant = "dark";
    mix_color = "blue";
    mix_factor = "0.0";
    saturation = "1.0";
    desaturation = "0.0";
    gradient_desaturation = "0.0";
    lightening = "0.00";
    darkening = "0.0";
    brightness_difference = "0.00";
    colorspace = "OkLab";
  },
}:
(import ../functions.nix pkgs).importYaml (
  pkgs.stdenv.mkDerivation {
    name = palette_name;
    buildInputs = with pkgs; [
      pastel
      bc
    ];
    src = ./base24_palette_generator.sh;
    env = builtins.mapAttrs (name: value: toString value) arguments // {
      inherit palette_name;
    };
    unpackPhase = "true";
    buildPhase = ''bash "$src" > ${palette_name}.yaml'';
    installPhase = ''install -Dm0644 ${palette_name}.yaml "$out"'';
  }
)
