#!/usr/bin/env bash

if [ -z "$palette_name" ]; then
  echo "Invalid palette name. Expected a non-empty string" >&2
fi;

: "${variant:=dark}"
: "${mix_color:=lightblue}"
: "${mix_factor:=0.6}"
: "${saturation:=0.3}"
: "${desaturation:=0.0}"
: "${gradient_desaturation:=0.0}"
: "${lightening:=0.05}"
: "${darkening:=0.0}"
: "${brightness_difference:=0.05}"
: "${colorspace:=OkLab}"

if [[ "$variant" == "light" ]]; then
    gradient_start="white"
    gradient_end="black"
elif [[ "$variant" == "dark" ]]; then
    gradient_start="black"
    gradient_end="white"
else
  echo "Invalid variant '$variant'. Expected 'light' or 'dark'" >&2
  exit 1
fi

mapfile -t gradient_colors < <(
    pastel gradient "$gradient_start" "$mix_color" "$gradient_end" -n 8  --colorspace "$colorspace" \
    | pastel desaturate "$(echo "$mix_factor * $gradient_desaturation" | bc -l)" \
    | pastel format hex
)

non_gradient_colors=()
non_gradient_color() {
    base_color=$(
        pastel color "$1" \
        | pastel mix "$mix_color" --fraction "$mix_factor" --colorspace "$colorspace" \
        | pastel saturate "$saturation" \
        | pastel desaturate "$desaturation" \
        | pastel lighten "$lightening" \
        | pastel darken "$darkening" \
        | pastel format hex
    )
    darker=$(pastel darken "$brightness_difference" "$base_color" | pastel format hex)
    lighter=$(pastel lighten "$brightness_difference" "$base_color" | pastel format hex)
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
name: "${palette_name}"
variant: "${variant}"
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
