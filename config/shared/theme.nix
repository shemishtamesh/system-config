pkgs:
let
  scheme = scheme_generator { palette_name = "default"; };
  alternative_schemes = [
    (scheme_generator {
      palette_name = "light";
      arguments.variant = "light";
    })
    (scheme_generator {
      palette_name = "extreme";
      arguments = {
        variant = "dark";
        mix_color = "white";
        mix_factor = "0.0";
        saturation = "0.4";
        desaturation = "0.0";
        gradient_desaturation = "0.0";
        lightening = "0.10";
        darkening = "0.0";
        brightness_difference = "0.00";
        colorspace = "OkLab";
      };
    })
  ];

  scheme_generator = (import ./theming/palette_generation.nix) pkgs;

  wallpaper_generator = (import ./theming/wallpaper_generator.nix) pkgs scheme;

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
  stylix_settings = {
    enable = true;
    base16Scheme = scheme;
    polarity = scheme.variant;
    opacity = {
      desktop = 0.5;
      popups = 0.75;
    };
    inherit fonts cursor;
  };
  inherit
    scheme
    fonts
    cursor
    alternative_schemes
    wallpaper_generator
    ;
}
