pkgs:
let
  # scheme = functions.importYaml "${pkgs.base16-schemes}/share/themes/irblack.yaml";
  # scheme = functions.importYaml "${pkgs.base16-schemes}/share/themes/atelier-forest-light.yaml";
  scheme = {
    system = "base24";
    name = "moonfly";
    slug = "moonfly";
    author = "bluz 71 (and edited by me)";
    variant = "dark";
    palette = {
      base00 = "000000"; # #000000 black
      base01 = "323437"; # #323437 gray 1
      base02 = "949494"; # #949494 gray 2
      base03 = "9e9e9e"; # #9e9e9e gray 3
      base04 = "bdbdbd"; # #bdbdbd gray 4
      base05 = "c6c6c6"; # #c6c6c6 gray 5
      base06 = "e4e4e4"; # #e4e4e4 gray 6
      base07 = "eeeeee"; # #eeeeee white
      base08 = "ff5d5d"; # #ff5d5d red
      base09 = "ff944d"; # #ff944d orange
      base0A = "e3c78a"; # #e3c78a yellow
      base0B = "8cc85f"; # #8cc85f green
      base0C = "79dac8"; # #79dac8 violet
      base0D = "80a0ff"; # #80a0ff blue
      base0E = "cf87e8"; # #cf87e8 purple
      base0F = "b2ceee"; # #b2ceee brown
      base10 = "ff5189"; # #ff5189 bright red
      base11 = "ffbb80"; # #ffbb80 bright orange
      base12 = "c6c684"; # #c6c684 bright yellow
      base13 = "36c692"; # #36c692 bright green
      base14 = "85dc85"; # #85dc85 bright violet
      base15 = "74b2ff"; # #74b2ff bright blue
      base16 = "ae81ff"; # #ae81ff bright purple
      base17 = "d2eeff"; # #d2eeff bright brown
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
