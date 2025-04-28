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
      buildPhase = "python3 main.py";
      installPhase = "install -Dm0644 ${name}.png $out";
      src = pkgs.writeTextFile {
        name = "${portname}_wallpaper";
        text =
          with scheme.palette;
          # python
          ''
            #!/usr/bin/env python
            import math
            import random
            from PIL import Image, ImageDraw


            random.seed(0)

            IMAGE_NAME = ${name}
            SCALING_FOR_ANTIALIASING = 8
            SCREEN_WIDTH = ${toString height} * SCALING_FOR_ANTIALIASING
            SCREEN_HEIGHT = ${toString width} * SCALING_FOR_ANTIALIASING
            TRIANGLE_SIDE_LENGTH = SCREEN_HEIGHT / 35
            TRIANGLE_HEIGHT = TRIANGLE_SIDE_LENGTH * math.sin(math.radians(60))
            GAPS = TRIANGLE_HEIGHT * 4 / 25
            EDGE_BUFFER = 1
            RADIUS_RATIO = 2.6
            COLORS = [
                "#${base00}",
                "#${base01}",
                "#${base02}",
                "#${base03}",
                "#${base04}",
                "#${base05}",
                "#${base06}",
                "#${base07}",
                "#${base08}",
                "#${base09}",
                "#${base0A}",
                "#${base0B}",
                "#${base0C}",
                "#${base0D}",
                "#${base0F}",
                "#${base10}",
                "#${base11}",
                "#${base12}",
                "#${base13}",
                "#${base14}",
                "#${base15}",
                "#${base16}",
                "#${base17}",
                "#${base18}",
            ]


            class Point:
                def __init__(self, x: float, y: float) -> None:
                    self.x = x
                    self.y = y

                def __add__(self, other: "Point") -> "Point":
                    return Point(self.x + other.x, self.y + other.y)

                def translate(self, other: "Point") -> "Point":
                    return self + other

                def rotate(self, pivot: "Point", angle_rad: float) -> "Point":
                    x_rot = (
                        (self.x - pivot.x) * math.cos(angle_rad)
                        - (self.y - pivot.y) * math.sin(angle_rad)
                        + pivot.x
                    )
                    y_rot = (
                        (self.x - pivot.x) * math.sin(angle_rad)
                        + (self.y - pivot.y) * math.cos(angle_rad)
                        + pivot.y
                    )
                    return Point(x_rot, y_rot)


            class Color:
                def __init__(self, red: int, green: int, blue: int) -> None:
                    self.red = red
                    self.green = green
                    self.blue = blue

                @classmethod
                def from_hex(cls, hex_color: str) -> "Color":
                    hex_color = hex_color.lstrip("#")
                    return cls(*[int(hex_color[i : i + 2], 16) for i in (0, 2, 4)])


            class Triangle:
                def __init__(self, position: Point, color: Color) -> None:
                    self.color = color

                    flip = (position.x % 2 == 0) != (position.y % 2 == 0)
                    self.points = [
                        Point(0, 0),
                        Point(TRIANGLE_SIDE_LENGTH, 0),
                        Point(
                            TRIANGLE_SIDE_LENGTH / 2,
                            TRIANGLE_SIDE_LENGTH * math.sin(math.radians(60)),
                        ),
                    ]
                    self.rotate(
                        self.points[0], ((math.tau / 2) if flip else 0) + math.tau / 6
                    )
                    self.translate(
                        Point(
                            (position.x * TRIANGLE_SIDE_LENGTH / 2) + SCREEN_WIDTH / 2,
                            (position.y * TRIANGLE_HEIGHT)
                            + SCREEN_HEIGHT / 2
                            + (TRIANGLE_HEIGHT if flip else 0),
                        ),
                    )
                    self.shrink(GAPS)

                def translate(self, direction: Point) -> "Triangle":
                    self.points = [point + direction for point in self.points]
                    return self

                def rotate(self, pivot: Point, angle_rad: float) -> "Triangle":
                    rotated_points = []
                    for point in self.points:
                        rotated_points.append(point.rotate(pivot, angle_rad))
                    self.points = rotated_points
                    return self

                def shrink(self, amount: float) -> "Triangle":
                    cx = sum([point.x for point in self.points]) / len(self.points)
                    cy = sum([point.y for point in self.points]) / len(self.points)
                    new_points = []
                    for point in self.points:
                        dx = cx - point.x
                        dy = cy - point.y
                        length = math.sqrt(dx**2 + dy**2)
                        dx /= length
                        dy /= length
                        new_x = point.x + dx * amount
                        new_y = point.y + dy * amount
                        new_points.append(Point(new_x, new_y))
                    self.points = new_points
                    return self

                def draw(self, image: Image) -> "Triangle":
                    draw = ImageDraw.Draw(image)
                    draw.polygon(
                        [(point.x, point.y) for point in self.points],
                        fill=(self.color.red, self.color.green, self.color.blue),
                    )
                    return self


            class NixLambda:
                def __init__(self, position, colors: list[Color]) -> None:
                    self.triangles = []
                    for coordinates in (
                        # long
                        [Point(i, i) for i in range(0, 8)]
                        + [Point(i, i + 1) for i in range(0, 7)]
                        + [Point(i - 1, i + 1) for i in range(0, 7)]
                        + [Point(i - 1, i + 2) for i in range(0, 6)]
                        # short
                        + [Point(i - 2, -i + 6) for i in range(0, 3)]
                        + [Point(i - 2, -i + 7) for i in range(0, 3)]
                        + [Point(i - 1, -i + 7) for i in range(0, 3)]
                        + [Point(i - 1, -i + 8) for i in range(1, 3)]
                    ):
                        self.triangles.append(
                            Triangle(coordinates + position, random.choice(colors))
                        )

                def translate(self, direction: Point) -> "NixLambda":
                    for triangle in self.triangles:
                        triangle.translate(direction)
                    return self

                def rotate(self, pivot: Point, angle_rad: float) -> "NixLambda":
                    for triangle in self.triangles:
                        triangle.rotate(pivot, angle_rad)
                    return self

                def draw(self, image: Image) -> "NixLambda":
                    for triangle in self.triangles:
                        triangle.draw(image)
                    return self


            class Nix:
                def __init__(self, color_groups: list[list[Color]]):
                    self.lambdas = []
                    for i in range(0, 6):
                        self.lambdas.append(
                            NixLambda(
                                Point(-6, 0), color_groups[i % len(color_groups)]
                            ).rotate(
                                Point(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2),
                                i * math.tau / 6,
                            )
                        )

                def draw(self, image: Image) -> "Nix":
                    for nix_lambda in self.lambdas:
                        nix_lambda.draw(image)
                    return self


            class Background:
                def __init__(self, colors: list[Color]) -> None:
                    self.triangles = []
                    for x in range(
                        # no need to divide by 2 because of how the triangles are packed
                        -int(SCREEN_WIDTH / TRIANGLE_SIDE_LENGTH) + EDGE_BUFFER,
                        int(SCREEN_WIDTH / TRIANGLE_SIDE_LENGTH) - EDGE_BUFFER,
                    ):
                        for y in range(
                            -int(SCREEN_HEIGHT / TRIANGLE_HEIGHT / 2) + EDGE_BUFFER,
                            int(SCREEN_HEIGHT / TRIANGLE_HEIGHT / 2) - EDGE_BUFFER,
                        ):
                            if -6 < x < 6 and -6 < y < 6:
                                continue
                            distance = (x**2 + (y * RADIUS_RATIO) ** 2) ** (1 / 2)
                            self.triangles.append(
                                Triangle(
                                    Point(x, y),
                                    random.choice(
                                        colors[: max(len(colors) - int(distance / 2), 1)]
                                    ),
                                )
                            )

                def draw(self, image: Image) -> "Background":
                    for triangle in self.triangles:
                        triangle.draw(image)
                    return self


            class Palette:
                def __init__(self, colors) -> None:
                    self.triangles = []
                    for i in range(7):
                        for j in range(2):
                            self.triangles.append(
                                Triangle(Point(i - 3, -j), colors[8 + i + 8 * j])
                            )
                    self.triangles.append(Triangle(Point(-2, -2), colors[5]))
                    self.triangles.append(Triangle(Point(0, -2), colors[3]))
                    self.triangles.append(Triangle(Point(2, -2), colors[7]))
                    self.triangles.append(Triangle(Point(-2, 1), colors[6]))
                    self.triangles.append(Triangle(Point(0, 1), colors[2]))
                    self.triangles.append(Triangle(Point(2, 1), colors[4]))
                    self.triangles.append(Triangle(Point(0, 2), colors[1]))

                def draw(self, image: Image) -> "Palette":
                    for triangle in self.triangles:
                        triangle.draw(image)
                    return self


            class Wallpaper:
                def __init__(self, colors):
                    self.background = Background(colors)
                    self.palette = Palette(colors)
                    self.nix = Nix([[colors[i], colors[i + 8]] for i in range(8, 16)])

                def draw(self, image):
                    self.background.draw(image)
                    self.palette.draw(image)
                    self.nix.draw(image)


            def main():
                image = Image.new(
                    "RGB", (int(SCREEN_WIDTH), int(SCREEN_HEIGHT)), COLORS[0]
                )

                Wallpaper([Color.from_hex(color) for color in COLORS]).draw(image)

                image = image.resize(
                    (
                        SCREEN_WIDTH // SCALING_FOR_ANTIALIASING,
                        SCREEN_HEIGHT // SCALING_FOR_ANTIALIASING,
                    ),
                    resample=Image.Resampling.LANCZOS,
                )
                image.save(IMAGE_NAME)


            if __name__ == "__main__":
                main()
          '';
      };
    };
}
