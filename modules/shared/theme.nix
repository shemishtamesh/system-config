pkgs:
let
  scheme = import ./colorschemes/snow.nix;
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
    inherit fonts cursor;
  };
  wallpaper =
    {
      portname,
      width,
      height,
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
      src = ./wallpaper_generator.py;
      unpackPhase = "true";
      buildPhase = ''
        echo test
        echo ${toString (builtins.attrValues scheme.palette)}
        echo test
        python3 $src \
          ${name} \
          ${toString (builtins.attrValues scheme.palette)}
      '';
      # } --resolution ${toString width}x${toString height}";
      installPhase = "install -Dm0644 ${name} $out";
    };
}
