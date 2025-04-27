pkgs: {
  importYaml =
    file:
    builtins.fromJSON (
      builtins.readFile (
        pkgs.runCommandNoCC "converted-yaml.json" { } ''
          ${pkgs.yj}/bin/yj < "${file}" > "$out"
        ''
      )
    );
  rgba =
    palette: color: opacity:
    let
      r = palette."${color}-rgb-r";
      g = palette."${color}-rgb-g";
      b = palette."${color}-rgb-b";
    in
    "rgba(${r}, ${g}, ${b}, ${builtins.toString opacity})";
  svgToPng =
    {
      width,
      height,
      svgText,
      name,
    }:
    pkgs.stdenv.mkDerivation {
      name = "${name}.png";
      src = pkgs.writeTextFile {
        name = "${name}.svg";
        text = svgText;
      };
      buildInputs = with pkgs; [ inkscape ];
      unpackPhase = "true";
      buildPhase = ''
        inkscape --export-type="png" $src -w ${toString width} -h ${toString height} -o ${name}.png
      '';
      installPhase = "install -Dm0644 ${name}.png $out";
    };
  scadToPng =
    {
      width,
      height,
      scadText,
      background_color,
      name,
    }:
    pkgs.stdenv.mkDerivation {
      name = "${name}.png";
      src = pkgs.writeTextFile {
        name = "${name}.scad";
        text = scadText;
      };
      buildInputs = with pkgs; [
        openscad
        xvfb-run
        xorg.xorgserver
        mesa
      ];
      unpackPhase = "true";
      buildPhase = ''
        mkdir -p $TMPDIR/config/OpenSCAD/color-schemes/render
        cat > $TMPDIR/config/OpenSCAD/color-schemes/render/CustomBackground.json <<EOF
          {
            "name": "custom_background",
            "index": 2000,
            "show-in-gui": false,
            "colors": {
              "background": "${background_color}",
              "axes-color": "${background_color}",
              "opencsg-face-front": "${background_color}",
              "opencsg-face-back": "${background_color}",
              "cgal-face-front": "${background_color}",
              "cgal-face-back": "${background_color}",
              "cgal-face-2d": "${background_color}",
              "cgal-edge-front": "${background_color}",
              "cgal-edge-back": "${background_color}",
              "cgal-edge-2d": "${background_color}",
              "crosshair": "${background_color}"
            }
          }
        EOF

        export XDG_CONFIG_HOME=$TMPDIR/config
        export LIBGL_ALWAYS_SOFTWARE=1
        export LIBGL_DRIVERS_PATH="${pkgs.mesa}/lib/dri"
        export LD_LIBRARY_PATH="${pkgs.mesa}/lib''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"

        openscad \
          --render \
          --colorscheme custom_background \
          --projection=ortho \
          --camera=0,0,0,0,0,0,${width} \
          --imgsize=${width},${height} \
          -o ${name}.png \
          $src
      '';
      installPhase = "install -Dm0644 ${name}.png $out";
    };
}
