pkgs:
let
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
    functions.scadToPng {
      name = "${portname}_wallpaper";
      scadText = # openscad
        ''
          colors = ["#${base00}", "#${base01}", "#${base02}", "#${base03}", "#${base04}", "#${base05}", "#${base06}", "#${base07}", "#${base08}", "#${base09}", "#${base0A}", "#${base0B}", "#${base0C}", "#${base0D}", "#${base0E}", "#${base0F}", "#${base10}", "#${base11}", "#${base12}", "#${base13}", "#${base14}", "#${base15}", "#${base16}", "#${base17}"];

          $image_height = ${toString height};
          $number_of_triangles_on_y_axis = 70;
          $triangle_height = $image_height / $number_of_triangles_on_y_axis;
          triangle_side = $triangle_height / sin(60);
          $gaps = $triangle_height * 2 / 25;

          function random_from_position(position, min, max) = floor(rands(min, max, 1, position[0] * 1000 + position[1])[0]);

          module triangle(position) {
              module basic_triangle(){
                  translate([-triangle_side / 2, -$triangle_height / 2])
                  polygon([
                      [0, 0],
                      [triangle_side, 0],
                      [triangle_side / 2, sin(60) * triangle_side]
                  ]);
              }

              offset(delta = -$gaps)
              translate([(position[0] / 2 + 0.5) * triangle_side, (position[1] + 0.5) * $triangle_height])
              if ((position[0] % 2 == 0) != (position[1] % 2 == 0))
                  rotate(180)
                  basic_triangle();
              else
                  basic_triangle();
          }

          module my_lambda(colors) {
              for (pos = concat(
                  // long
                  [ for (i = [0:7]) [ i - 7,   -i - 1 ] ],
                  [ for (i = [0:6]) [ i - 7,   -i - 2 ] ],
                  [ for (i = [0:6]) [ i - 8,   -i - 2 ] ],
                  [ for (i = [0:5]) [ i - 8,   -i - 3 ] ],
                  // short
                  [ for (i = [0:2]) [ i - 9,    i - 7 ] ],
                  [ for (i = [0:2]) [ i - 9,    i - 8 ] ],
                  [ for (i = [0:2]) [ i - 8,    i - 8 ] ],
                  [ for (i = [0:2]) [ i - 7,    i - 8 ] ]
              ))
                  color(colors[random_from_position(pos, 0, len(colors))])
                  triangle(pos);
          }

          module nix(color_groups) {
              for (i = [0:5]) {
                  rotate(-60 * i)
                  my_lambda(color_groups[i % len(color_groups)]);
              }
          }

          module background()
              for (i = [-38:44])
                  for (j = [-13:12]) {
                      distance = min(max(floor(sqrt(((i - 3) * triangle_side)^2 + (j * 3 * $triangle_height)^2) / 100), 0), 7);
                      color(colors[random_from_position([i, j], 0, 7 - distance)])
                      if ((i < -2 || 8 < i) || (j < -3 || 2 < j))
                          triangle([-4 + i, j]);
                  }

          module palette() {
              for (i = [0:6])
                  for (j = [-1:0])
                      color(colors[i + 8 * abs(j + 2)])
                      triangle([-4 + i, j]);

              for (i = [0:6])
                  color(colors[i])
                  triangle([i - 4, -2]);
          }

          module wallpaper() {
              background();
              palette();

              nix([
                  [colors[08], colors[16]],
                  [colors[09], colors[17]],
                  [colors[10], colors[18]],
                  [colors[11], colors[19]],
                  [colors[12], colors[20]],
                  [colors[13], colors[21]],
                  [colors[14], colors[22]],
                  [colors[15], colors[23]]
              ]);
          }

          wallpaper();
        '';
      inherit width height;
      background_color = "#${base00}";
    };
}
