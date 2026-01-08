pkgs:
let
  scheme_generator = (import ./theming/palette_generation.nix) pkgs;
  scheme = scheme_generator { palette_name = "default"; };
  fonts = {
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };
    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };
    monospace = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font Mono";
    };
    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Emoji";
    };
  };
  cursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };
in
{
  inherit scheme fonts cursor;
  stylix_settings = {
    enable = true;
    base16Scheme = scheme;
    polarity = scheme.variant;
    inherit fonts cursor;
  };
  alternative_schemes = [
    (scheme_generator {
      palette_name = "light";
      arguments.variant = "light";
    })
    (scheme_generator {
      palette_name = "palegreen";
      arguments = {
        mix_color = "palegreen";
        mix_factor = 0.3;
        gradient_desaturation = 0.6;
      };
    })
  ];
  wallpaper_generator =
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
    };
}
