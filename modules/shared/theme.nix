pkgs:
let
  # scheme = functions.importYaml "${pkgs.base16-schemes}/share/themes/irblack.yaml";
  # scheme = functions.importYaml "${pkgs.base16-schemes}/share/themes/atelier-forest-light.yaml";
  scheme = {
    system = "base24";
    name = "custom";
    slug = "custom";
    author = "";
    variant = "dark";
    palette = {
      base00 = "000000"; # #000000
      base01 = "0b1520"; # #0b1520
      base02 = "1a2e42"; # #1a2e42
      base03 = "27435f"; # #27435f
      base04 = "62819e"; # #62819e
      base05 = "92abc5"; # #92abc5
      base06 = "b9d3e8"; # #b9d3e8
      base07 = "e3f0f8"; # #e3f0f8

      base08 = "ff6b6b"; # #ff6b6b
      base09 = "ffab6b"; # #ffab6b
      base0A = "f0fa90"; # #f0fa90
      base0B = "6af09e"; # #6af09e
      base0C = "8f8fff"; # #8f8fff
      base0D = "569dff"; # #569dff
      base0E = "c3a1ff"; # #c3a1ff
      base0F = "b48f6a"; # #b48f6a

      base10 = "ff8f8f"; # #ff8f8f
      base11 = "ffc28f"; # #ffc28f
      base12 = "ffffaf"; # #ffffaf
      base13 = "8dffb9"; # #8dffb9
      base14 = "afafff"; # #afafff
      base15 = "a3cfff"; # #a3cfff
      base16 = "e5cfff"; # #e5cfff
      base17 = "d7b18f"; # #d7b18f
    };
  };
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
  functions = import ./functions.nix pkgs;
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
    with scheme.palette;
    let
      logoScale = 8;
    in
    functions.svgToPng {
      name = "${portname}_wallpaper";
      svgText = # svg
        ''
          <?xml version="1.0" encoding="UTF-8" standalone="no"?>
          <svg
             width="${toString width}"
             height="${toString height}"
             version="1.1"
             id="svg4"
             xmlns="http://www.w3.org/2000/svg"
             xmlns:svg="http://www.w3.org/2000/svg">
            <defs
               id="defs4" />
            <rect
               width="${toString width}"
               height="${toString height}"
               fill="#${base00}"
               id="rect1" />
            <svg
               x="${toString (width / 2 - (logoScale * 50))}"
               y="${toString (height / 2 - (logoScale * 50))}"
               version="1.1"
               id="svg3">
              <g
                 transform="scale(${toString logoScale})"
                 id="g3">
                <g
                   transform="matrix(.19936 0 0 .19936 80.161 27.828)"
                   id="g2">
                  <path
                     d="m -249.0175,116.584 122.2,211.68 -56.157,0.5268 -32.624,-56.869 -32.856,56.565 -27.902,-0.011 -14.291,-24.69 46.81,-80.49 -33.229,-57.826 z"
                     fill="#${base08}"
                     style="display:inline;isolation:auto;mix-blend-mode:normal"
                     id="path1" />
                  <path
                     d="m -204.9102,29.388 -122.22,211.67 -28.535,-48.37 32.938,-56.688 -65.415,-0.1717 -13.942,-24.169 14.237,-24.721 93.111,0.2937 33.464,-57.69 z"
                     fill="#${base09}"
                     id="path2"
                     style="display:inline" />
                  <path
                     d="m -195.535,198.588 244.42,0.012 -27.622,48.897 -65.562,-0.1813 32.559,56.737 -13.961,24.158 -28.528,0.031 -46.301,-80.784 -66.693,-0.1359 z"
                     fill="#${base0A}"
                     id="path3"
                     style="display:inline" />
                  <path
                     d="m -53.275,105.84 -122.2,-211.68 56.157,-0.5268 32.624,56.869 32.856,-56.565 27.902,0.011 14.291,24.69 -46.81,80.49 33.229,57.826 z"
                     fill="#${base0B}"
                     id="path4"
                     style="display:inline" />
                  <path
                     d="m -97.659,193.01 122.22,-211.67 28.535,48.37 -32.938,56.688 65.415,0.1716 13.941,24.169 -14.237,24.721 -93.111,-0.2937 -33.464,57.69 z"
                     fill="#${base0C}"
                     style="display:inline;isolation:auto;mix-blend-mode:normal"
                     id="path5" />
                  <path
                     d="m -107.2575,23.36 -244.42,-0.012 27.622,-48.897 65.562,0.1813 -32.559,-56.737 13.961,-24.158 28.528,-0.031 46.301,80.784 66.693,0.1359 z"
                     fill="#${base0D}"
                     style="display:inline;isolation:auto;mix-blend-mode:normal"
                     id="path6" />
                </g>
              </g>
            </svg>
          </svg>
        '';
      inherit width height;
    };
}
