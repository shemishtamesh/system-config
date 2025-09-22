pkgs:
let
  scheme = (import ./functions.nix pkgs).importYaml (
    let
      name = "base24_color_palette";
    in
    pkgs.stdenv.mkDerivation {
      inherit name;
      buildInputs = with pkgs; [
        pastel
        bc
      ];
      src = ./theming/base24_palette_generator.sh;
      unpackPhase = "true";
      buildPhase = "bash $src > ${name}.yaml";
      installPhase = "install -Dm0644 ${name}.yaml $out";
    }
  );
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
      package = pkgs.noto-fonts-emoji;
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
    inherit fonts;# cursor;
  };
  wallpaper =
    {
      portname,
      width,
      height,
      background ? true,
      palette ? true,
      nix ? true,
      gaps ? true,
      random ? true,
    }:
    let
      name = "${portname}_wallpaper.png";
    in
    pkgs.stdenv.mkDerivation {
      inherit name;
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
          ${name} \
          $(echo '${toString (builtins.attrValues scheme.palette)}') \
          --resolution ${toString width}x${toString height} \
          ${if !background then "--no_background" else ""} \
          ${if !palette then "--no_palette" else ""} \
          ${if !nix then "--no_nix" else ""} \
          ${if !gaps then "--gaps 0" else ""} \
          ${if !random then "--no_random" else ""} \
          # --no_color_outside_nix \
      '';
      installPhase = "install -Dm0644 ${name} $out";
    };
}
