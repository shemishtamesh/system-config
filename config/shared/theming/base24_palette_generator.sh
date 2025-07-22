#!/usr/bin/env bash

NAME=colorpalette
VARIANT=dark
MIX_COLOR=lightblue
MIX_FACTOR=0.6
SATURATION=0.3
DESATURATION=0.0
GRADIENT_DESATURATION=0.0
LIGHTENING=0.05
DARKENING=0.0
BRIGHTNESS_DIFFERENCE=0.05

colorspace=OkLab

if [[ "$VARIANT" == "bright" ]]; then
    gradient_start="white"
    gradient_end="black"
else
    gradient_start="black"
    gradient_end="white"
fi

mapfile -t gradient_colors < <(
    pastel gradient "$gradient_start" "$MIX_COLOR" "$gradient_end" -n 8  --colorspace "$colorspace" \
    | pastel desaturate "$(echo "$MIX_FACTOR * $GRADIENT_DESATURATION" | bc -l)" \
    | pastel format hex
)

non_gradient_colors=()
non_gradient_color() {
    base_color=$(
        pastel color "$1" \
        | pastel mix "$MIX_COLOR" --fraction $MIX_FACTOR --colorspace "$colorspace" \
        | pastel saturate $SATURATION \
        | pastel desaturate $DESATURATION \
        | pastel lighten $LIGHTENING \
        | pastel darken $DARKENING \
        | pastel format hex
    )
    darker=$(pastel darken $BRIGHTNESS_DIFFERENCE "$base_color" | pastel format hex)
    lighter=$(pastel lighten $BRIGHTNESS_DIFFERENCE "$base_color" | pastel format hex)
    non_gradient_colors+=("$darker" "$lighter")
}

hues=6
for rotation in $(seq 0 $((hues - 1))); do
    base_color=$(
        pastel color red \
        | pastel rotate "$(echo "360 / $hues * $rotation" | bc -l)" \
    )
    non_gradient_color "$base_color"
done

non_gradient_color "$(pastel color brown)"

cat <<EOF
system: "base24"
name: "${NAME}"
variant: "${VARIANT}"
palette:
  base11: "${gradient_colors[0]}"
  base10: "${gradient_colors[0]}"
  base00: "${gradient_colors[0]}"
  base01: "${gradient_colors[1]}"
  base02: "${gradient_colors[2]}"
  base03: "${gradient_colors[3]}"
  base04: "${gradient_colors[4]}"
  base05: "${gradient_colors[5]}"
  base06: "${gradient_colors[6]}"
  base07: "${gradient_colors[7]}"
  base08: "${non_gradient_colors[0]}"
  base12: "${non_gradient_colors[1]}"
  base0A: "${non_gradient_colors[2]}"
  base13: "${non_gradient_colors[3]}"
  base0B: "${non_gradient_colors[4]}"
  base14: "${non_gradient_colors[5]}"
  base0C: "${non_gradient_colors[6]}"
  base15: "${non_gradient_colors[7]}"
  base0D: "${non_gradient_colors[8]}"
  base16: "${non_gradient_colors[9]}"
  base0E: "${non_gradient_colors[10]}"
  base17: "${non_gradient_colors[11]}"
  base0F: "${non_gradient_colors[12]}"
  base09: "${non_gradient_colors[13]}"
EOF
