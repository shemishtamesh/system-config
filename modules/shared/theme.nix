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
      base01 = "1a1a27"; # #1a1a27
      base02 = "2a2a40"; # #2a2a40
      base03 = "44475a"; # #44475a
      base04 = "cdd6f4"; # #cdd6f4
      base05 = "ffffff"; # #ffffff
      base06 = "f5e0dc"; # #f5e0dc
      base07 = "f8f8f2"; # #f8f8f2
      base08 = "ff6e6e"; # #ff6e6e
      base09 = "ffb86c"; # #ffb86c
      base0A = "f1fa8c"; # #f1fa8c
      base0B = "50fa7b"; # #50fa7b
      base0C = "8be9fd"; # #8be9fd
      base0D = "61afef"; # #61afef
      base0E = "bd93f9"; # #bd93f9
      base0F = "ff79c6"; # #ff79c6
      base10 = "ff9ac1"; # #ff9ac1
      base11 = "94d6ff"; # #94d6ff
      base12 = "a6e3a1"; # #a6e3a1
      base13 = "fab387"; # #fab387
      base14 = "b4befe"; # #b4befe
      base15 = "e5cffe"; # #e5cffe
      base16 = "f8f8ff"; # #f8f8ff
      base17 = "282a36"; # #282a36

      # base00 = "000000"; # #000000 black
      # base01 = "242422"; # #242422 gray 1
      # base02 = "484844"; # #484844 gray 2
      # base03 = "6c6c66"; # #6c6c66 gray 3
      # base04 = "918f88"; # #918f88 gray 4
      # base05 = "b5b3aa"; # #b5b3aa gray 5
      # base06 = "d9d7cc"; # #d9d7cc gray 6
      # base07 = "fdfbee"; # #fdfbee white
      # base08 = "df4c40"; # #df4c40 red
      # base09 = "c9a042"; # #c9a042 orange
      # base0A = "dfdf96"; # #dfdf96 yellow
      # base0B = "88df40"; # #88df40 green
      # base0C = "a6a5de"; # #a6a5de violet
      # base0D = "76abde"; # #76abde blue
      # base0E = "df53dd"; # #df53dd purple
      # base0F = "916a1d"; # #916a1d brown
      # base10 = "ff6c60"; # #ff6c60 bright red
      # base11 = "e9c062"; # #e9c062 bright orange
      # base12 = "ffffb6"; # #ffffb6 bright yellow
      # base13 = "a8ff60"; # #a8ff60 bright green
      # base14 = "c6c5fe"; # #c6c5fe bright violet
      # base15 = "96cbfe"; # #96cbfe bright blue
      # base16 = "ff73fd"; # #ff73fd bright purple
      # base17 = "b18a3d"; # #b18a3d bright brown
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
