{ pkgs }:
let
  screenWidth = 1920;
  screenHeight = 1080;
  scheme = functions.importYaml "${pkgs.base16-schemes}/share/themes/irblack.yaml";
  functions = import ./functions.nix { inherit pkgs; };
  imageFromScheme = functions.imageFromScheme { width = screenWidth; height = screenHeight; };
  images = functions.imagesFromScheme {
    screenWidth = 1920;
    screenHeight = 1080;
    inherit scheme;
  };
in
{
  inherit scheme;
  fonts = {
    serif = {
      package = pkgs.fira-code-symbols;
      name = "FiraCode Nerd Font";
    };

    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "FiraCode Nerd Font";
    };

    monospace = {
      package = pkgs.dejavu_fonts;
      name = "FiraCode Nerd Font";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "FiraCode Nerd Font";
    };
  };
  # wallpaper = images.wallpaper;
  wallpaper =
    let
      logoScale = 8;
      palette = scheme.palette;
    in
    imageFromScheme {
      name = "wallpaper";
      svgText = /* svg */ ''
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <svg
           width="${toString screenWidth}"
           height="${toString screenHeight}"
           version="1.1"
           id="svg4"
           xmlns="http://www.w3.org/2000/svg"
           xmlns:svg="http://www.w3.org/2000/svg">
          <defs
             id="defs4" />
          <rect
             width="${toString screenWidth}"
             height="${toString screenHeight}"
             fill="#${palette.base00}"
             id="rect1" />
          <svg
             x="${toString (screenWidth / 2 - (logoScale * 50))}"
             y="${toString (screenHeight / 2 - (logoScale * 50))}"
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
                   fill="#${palette.base08}"
                   style="display:inline;isolation:auto;mix-blend-mode:normal"
                   id="path1" />
                <path
                   d="m -204.9102,29.388 -122.22,211.67 -28.535,-48.37 32.938,-56.688 -65.415,-0.1717 -13.942,-24.169 14.237,-24.721 93.111,0.2937 33.464,-57.69 z"
                   fill="#${palette.base09}"
                   id="path2"
                   style="display:inline" />
                <path
                   d="m -195.535,198.588 244.42,0.012 -27.622,48.897 -65.562,-0.1813 32.559,56.737 -13.961,24.158 -28.528,0.031 -46.301,-80.784 -66.693,-0.1359 z"
                   fill="#${palette.base0A}"
                   id="path3"
                   style="display:inline" />
                <path
                   d="m -53.275,105.84 -122.2,-211.68 56.157,-0.5268 32.624,56.869 32.856,-56.565 27.902,0.011 14.291,24.69 -46.81,80.49 33.229,57.826 z"
                   fill="#${palette.base0B}"
                   id="path4"
                   style="display:inline" />
                <path
                   d="m -97.659,193.01 122.22,-211.67 28.535,48.37 -32.938,56.688 65.415,0.1716 13.941,24.169 -14.237,24.721 -93.111,-0.2937 -33.464,57.69 z"
                   fill="#${palette.base0C}"
                   style="display:inline;isolation:auto;mix-blend-mode:normal"
                   id="path5" />
                <path
                   d="m -107.2575,23.36 -244.42,-0.012 27.622,-48.897 65.562,0.1813 -32.559,-56.737 13.961,-24.158 28.528,-0.031 46.301,80.784 66.693,0.1359 z"
                   fill="#${palette.base0D}"
                   style="display:inline;isolation:auto;mix-blend-mode:normal"
                   id="path6" />
              </g>
            </g>
          </svg>
        </svg>
      '';
    };
}
