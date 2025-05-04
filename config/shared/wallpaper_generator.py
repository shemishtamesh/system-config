#!/usr/bin/env python
import math
import random
import argparse
from PIL import Image, ImageDraw


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

    def __str__(self) -> str:
        return "#{:02x}{:02x}{:02x}".format(self.red, self.green, self.blue)


class Triangle:
    def __init__(
        self, position: Point, color: Color, side_length: float, gaps: float
    ) -> None:
        self.color = color

        flip = (position.x % 2 == 0) != (position.y % 2 == 0)
        self.points = [
            Point(0, 0),
            Point(side_length, 0),
            Point(
                side_length / 2,
                side_length * math.sin(math.tau / 6),
            ),
        ]
        self.rotate(
            self.points[0], ((math.tau / 2) if flip else 0) + math.tau / 6
        )
        self.translate(
            Point(
                (position.x * side_length / 2),
                (position.y * side_length * math.sin(math.tau / 6))
                + ((side_length * math.sin(math.tau / 6)) if flip else 0),
            ),
        )
        self.shrink(gaps)

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


class TriangleFactory:
    def __init__(self, offset: Point, side_length: float, gaps: float):
        self.offset = offset
        self.side_length = side_length
        self.gaps = gaps

    def triangle(self, position, color):
        return Triangle(
            position, color, self.side_length, self.gaps
        ).translate(self.offset)


class NixLambda:
    def __init__(
        self,
        position,
        colors: list[Color],
        triangle_factory: TriangleFactory,
    ) -> None:
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
                triangle_factory.triangle(
                    coordinates + position,
                    random.choice(colors),
                )
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
    def __init__(
        self,
        color_groups: list[list[Color]],
        triangle_factory: TriangleFactory,
        use_random: bool,
    ):
        self.lambdas = []
        for i in range(0, 6):
            self.lambdas.append(
                NixLambda(
                    Point(-6, 0),
                    color_groups[i % len(color_groups)]
                    if use_random
                    else [color_groups[i % len(color_groups)][0]],
                    triangle_factory,
                ).rotate(
                    triangle_factory.offset,
                    i * math.tau / 6,
                )
            )

    def draw(self, image: Image) -> "Nix":
        for nix_lambda in self.lambdas:
            nix_lambda.draw(image)
        return self


class Background:
    def __init__(
        self,
        width: int,
        height: int,
        edge_buffer: int,
        radius_ratio: float,
        distance_fade_scale: float,
        color_outside_nix: bool,
        colors: list[Color],
        triangle_factory: TriangleFactory,
        use_random: bool,
    ) -> None:
        if len(colors) > 17:
            colors = [colors[17], colors[16]] + colors[:16] + colors[18:]

        triangle_height = triangle_factory.side_length * math.sin(math.tau / 6)

        self.triangles = []
        for x in range(
            # no need to divide by 2 because of how the triangles are packed
            -int(width / triangle_factory.side_length) + edge_buffer,
            int(width / triangle_factory.side_length) - edge_buffer,
        ):
            for y in range(
                -int(height / triangle_height / 2) + edge_buffer,
                int(height / triangle_height / 2) - edge_buffer,
            ):
                if -6 < x < 6 and -6 < y < 6:
                    continue
                distance = (x**2 + (y * radius_ratio) ** 2) ** (1 / 2)
                color_index = max(
                    len(colors)
                    - int(distance * distance_fade_scale * len(colors) / 24),
                    1,
                )
                if not color_outside_nix:
                    color_index = min(color_index, 8)
                self.triangles.append(
                    triangle_factory.triangle(
                        Point(x, y),
                        random.choice(colors[:color_index])
                        if use_random
                        else colors[0],
                    )
                )

    def draw(self, image: Image) -> "Background":
        for triangle in self.triangles:
            triangle.draw(image)
        return self


class Palette:
    def __init__(
        self, colors: list[Color], triangle_factory: TriangleFactory
    ) -> None:
        self.triangles = []
        hexagon = [
            # grayscale
            ((0, 1), 7),
            ((1, 1), 6),
            ((-1, 1), 5),
            ((2, 1), 4),
            ((-2, 1), 3),
            ((0, -2), 17),
            ((1, -2), 16),
            ((-1, -2), 0),
            ((2, -2), 1),
            ((-2, -2), 2),
            # regular
            ((-3, -1), 18),
            ((-2, -1), 19),
            ((-1, -1), 20),
            ((0, -1), 9),
            ((1, -1), 21),
            ((2, -1), 22),
            ((3, -1), 23),
            # bright
            ((-3, 0), 8),
            ((-2, 0), 10),
            ((-1, 0), 11),
            ((0, 0), 15),
            ((1, 0), 12),
            ((2, 0), 13),
            ((3, 0), 14),
        ]
        dimonds = [
            # # grayscale
            # ((0, 1), 7),
            # ((1, 1), 6),
            # ((-1, 1), 5),
            # ((2, 1), 4),
            # ((-2, 1), 3),
            # ((0, -2), 17),
            # ((1, -2), 16),
            # ((-1, -2), 0),
            # ((2, -2), 1),
            # ((-2, -2), 2),
            # red
            ((-3, 1), 18),
            ((-2, 1), 8),

            # yellow
            ((-3, -2), 19),
            ((-2, -2), 10),

            # green
            ((0, -2), 20),
            ((0, -1), 11),

            # cyan
            ((3, -2), 21),
            ((2, -2), 12),

            # blue
            ((3, 1), 22),
            ((2, 1), 13),

            # # extra
            # ((3, 1), 9),
            # ((2, 1), 15),

        #     ((3, -1), 23),
        #     #
        #     ((3, 0), 14),
        ]
        for coords_and_color in dimonds:
            self.triangles.append(
                triangle_factory.triangle(
                    Point(*coords_and_color[0]), colors[coords_and_color[1]]
                )
            )

    def draw(self, image: Image) -> "Palette":
        for triangle in self.triangles:
            triangle.draw(image)
        return self


class Wallpaper:
    def __init__(
        self,
        width: int,
        height: int,
        edge_buffer: int,
        radius_ratio: float,
        distance_fade_scale: float,
        color_outside_nix: bool,
        background: bool,
        nix: bool,
        palette: bool,
        use_random: bool,
        colors: list[Color],
        triangle_side_length: float,
        gaps: float,
    ):
        triangle_factory = TriangleFactory(
            Point(width / 2, height / 2), triangle_side_length, gaps
        )
        self.background = (
            Background(
                width,
                height,
                edge_buffer,
                radius_ratio,
                distance_fade_scale,
                color_outside_nix,
                colors,
                triangle_factory,
                use_random,
            )
            if background
            else None
        )
        self.palette = Palette(colors, triangle_factory) if palette else None
        self.nix = (
            Nix(
                [
                    [colors[8], colors[18]],
                    [colors[10], colors[19]],
                    [colors[11], colors[20]],
                    [colors[12], colors[21]],
                    [colors[13], colors[22]],
                    [colors[14], colors[23]],
                ],
                triangle_factory,
                use_random,
            )
            if nix
            else None
        )

    def draw(self, image):
        if self.background:
            self.background.draw(image)
        if self.nix:
            self.nix.draw(image)
        if self.palette:
            self.palette.draw(image)


def create_wallpaper_image(
    screen_width: int,
    screen_height: int,
    edge_buffer: int,
    radius_ratio: float,
    distance_fade_scale: float,
    color_outside_nix: bool,
    background: bool,
    nix: bool,
    palette: bool,
    use_random: bool,
    colors: list[Color],
    triangle_side_length: float,
    image_name: str,
    scaling_for_antialiasing: float,
    gaps: float,
):
    scaled_width = int(screen_width * scaling_for_antialiasing)
    scaled_height = int(screen_height * scaling_for_antialiasing)
    image = Image.new(
        "RGB",
        (
            scaled_width,
            scaled_height,
        ),
        str(colors[17] if len(colors) > 17 else colors[0]),
    )

    Wallpaper(
        scaled_width,
        scaled_height,
        edge_buffer,
        radius_ratio,
        distance_fade_scale,
        color_outside_nix,
        background,
        nix,
        palette,
        use_random,
        colors,
        triangle_side_length,
        gaps,
    ).draw(image)

    image = image.resize(
        (screen_width, screen_height),
        resample=Image.Resampling.LANCZOS,
    )
    image.save(image_name)


def main():
    parser = argparse.ArgumentParser(description="wallpaper generator")
    parser.add_argument(
        "image_name",
        help="the name of the output image",
        type=str,
    )
    parser.add_argument(
        "colors",
        help="the color palette",
        nargs="+",
        type=str,
    )
    parser.add_argument(
        "-s",
        "--resolution",
        help="image resolution in the form: `{width}x{height}`",
        default="1920x1080",
        type=str,
    )
    parser.add_argument(
        "-a",
        "--scaling_for_antialiasing",
        help=(
            "the image resolution will be multiplied by this value,"
            + " after that it'll be resized to the original"
        ),
        default=16,
        type=int,
    )
    parser.add_argument(
        "-l",
        "--triangle_side_length",
        help=(
            "the side length of each triangle, by default will be calculated"
            + " based on screen height to fit 40 triangles"
        ),
        type=float,
    )
    parser.add_argument(
        "-g",
        "--gaps",
        help=(
            "the size of the gaps between the triangles,"
            + "triangle_height * 4 / 25 by default"
        ),
        type=float,
    )
    parser.add_argument(
        "-e",
        "--edge_buffer",
        help="number of triangle rows/columns to disallow around the edges",
        default=1,
        type=int,
    )
    parser.add_argument(
        "-r",
        "--radius_ratio",
        help="the ratio between the two radiai of the background fade",
        default=3,
        type=int,
    )
    parser.add_argument(
        "-d",
        "--distance_fade_scale",
        help="how fast is the fadeout",
        default=0.35,
        type=float,
    )
    parser.add_argument(
        "-x",
        "--no_color_outside_nix",
        help="whether or not do draw colors outside of the nix logo",
        action="store_true",
    )
    parser.add_argument(
        "-b",
        "--no_background",
        help="whether or not do draw the background",
        action="store_true",
    )
    parser.add_argument(
        "-n",
        "--no_nix",
        help="whether or not do draw the nix logo",
        action="store_true",
    )
    parser.add_argument(
        "-p",
        "--no_palette",
        help="whether or not do draw the palette",
        action="store_true",
    )
    parser.add_argument(
        "-m",
        "--no_random",
        help="whether or not to use randomness, if set will chose first",
        action="store_true",
    )
    parser.add_argument(
        "-i",
        "--random_seed",
        help="change this to get a new image with the same config",
        default=0,
        type=int,
    )
    args = parser.parse_args()

    random.seed(args.random_seed)
    resolution = [int(size) for size in args.resolution.split("x")]
    triangle_side_length = (
        args.triangle_side_length
        if args.triangle_side_length is not None
        else resolution[1] / math.sin(math.tau / 6) / 44
    ) * args.scaling_for_antialiasing
    gaps = (
        args.gaps
        if args.gaps is not None
        else (triangle_side_length * math.sin(math.tau / 6) * 4 / 25)
    )

    create_wallpaper_image(
        resolution[0],
        resolution[1],
        args.edge_buffer,
        args.radius_ratio,
        args.distance_fade_scale,
        not args.no_color_outside_nix,
        not args.no_background,
        not args.no_nix,
        not args.no_palette,
        not args.no_random,
        [Color.from_hex(color) for color in args.colors],
        triangle_side_length,
        args.image_name,
        args.scaling_for_antialiasing,
        gaps,
    )


if __name__ == "__main__":
    main()
