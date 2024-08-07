{ pkgs, ... }:
let
  importYaml =
    file: builtins.fromJSON (
      builtins.readFile (
        pkgs.runCommandNoCC "converted-yaml.json" ''${pkgs.yj}/bin/yj < "${file}" > "$out"''
      )
    );
  nixWallpaperFromScheme =
    { width
    , height
    , logoScale
    , backgroundColor
    , logoColor1
    , logoColor2
    , logoColor3
    , logoColor4
    , logoColor5
    , logoColor6
    }:
    pkgs.stdenv.mkDerivation {
      name = "generated-nix-wallpaper.png";
      src = pkgs.writeTextFile {
        name = "template.svg";
        text = /* svg */ ''
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
               width="1920"
               height="1080"
               fill="#${backgroundColor}"
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
                     fill="#${logoColor1}"
                     style="display:inline;isolation:auto;mix-blend-mode:normal"
                     id="path1" />
                  <path
                     d="m -204.9102,29.388 -122.22,211.67 -28.535,-48.37 32.938,-56.688 -65.415,-0.1717 -13.942,-24.169 14.237,-24.721 93.111,0.2937 33.464,-57.69 z"
                     fill="#${logoColor2}"
                     id="path2"
                     style="display:inline" />
                  <path
                     d="m -195.535,198.588 244.42,0.012 -27.622,48.897 -65.562,-0.1813 32.559,56.737 -13.961,24.158 -28.528,0.031 -46.301,-80.784 -66.693,-0.1359 z"
                     fill="#${logoColor3}"
                     id="path3"
                     style="display:inline" />
                  <path
                     d="m -53.275,105.84 -122.2,-211.68 56.157,-0.5268 32.624,56.869 32.856,-56.565 27.902,0.011 14.291,24.69 -46.81,80.49 33.229,57.826 z"
                     fill="#${logoColor4}"
                     id="path4"
                     style="display:inline" />
                  <path
                     d="m -97.659,193.01 122.22,-211.67 28.535,48.37 -32.938,56.688 65.415,0.1716 13.941,24.169 -14.237,24.721 -93.111,-0.2937 -33.464,57.69 z"
                     fill="#${logoColor5}"
                     style="display:inline;isolation:auto;mix-blend-mode:normal"
                     id="path5" />
                  <path
                     d="m -107.2575,23.36 -244.42,-0.012 27.622,-48.897 65.562,0.1813 -32.559,-56.737 13.961,-24.158 28.528,-0.031 46.301,80.784 66.693,0.1359 z"
                     fill="#${logoColor6}"
                     style="display:inline;isolation:auto;mix-blend-mode:normal"
                     id="path6" />
                </g>
              </g>
            </svg>
          </svg>
        '';
      };
      buildInputs = with pkgs; [ inkscape ];
      unpackPhase = "true";
      buildPhase = ''
        inkscape --export-type="png" $src -w ${toString width} -h ${
          toString height
        } -o wallpaper.png
      '';
      installPhase = "install -Dm0644 wallpaper.png $out";
    };
  scheme = importYaml "${pkgs.base16-schemes}/share/themes/isotope.yaml";
in
{
  wallpaper = nixWallpaperFromScheme {
    width = 1920;
    height = 1080;
    logoScale = 8;
    backgroundColor = scheme.palette.base00;
    logoColor1 = scheme.palette.base08;
    logoColor2 = scheme.palette.base09;
    logoColor3 = scheme.palette.base0A;
    logoColor4 = scheme.palette.base0B;
    logoColor5 = scheme.palette.base0C;
    logoColor6 = scheme.palette.base0D;
  };
}
