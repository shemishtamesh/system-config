take the colors from the markdown table, and fill the colors in the nix snippet with them.

```nix
{
  base00 = "000000"; # black
  base01 = "242422"; # gray 1
  base02 = "484844"; # gray 2
  base03 = "6c6c66"; # gray 3
  base04 = "918f88"; # gray 4
  base05 = "b5b3aa"; # gray 5
  base06 = "d9d7cc"; # gray 6
  base07 = "fdfbee"; # white
  base08 = "df4c40"; # red
  base09 = "c9a042"; # orange
  base0A = "dfdf96"; # yellow
  base0B = "88df40"; # green
  base0C = "a6a5de"; # violet
  base0D = "76abde"; # blue
  base0E = "df53dd"; # purple
  base0F = "916a1d"; # brown
  base10 = "ff6c60"; # bright red
  base11 = "e9c062"; # bright orange
  base12 = "ffffb6"; # bright yellow
  base13 = "a8ff60"; # bright green
  base14 = "c6c5fe"; # bright violet
  base15 = "96cbfe"; # bright blue
  base16 = "ff73fd"; # bright purple
  base17 = "b18a3d"; # bright brown
}
```

```markdown
| Type           | Category         | Value    |
| -------------- | ---------------- | -------- |
| Background     | Background       | #080808  |
| Foreground     | Foreground       | #bdbdbd  |
| Bold           | Bold             | #eeeeee  |
| Cursor         | Cursor           | #9e9e9e  |
| Cursor Text    | Cursor Text      | #080808  |
| Selection      | Selection        | #b2ceee  |
| Selection Text | Selection Text   | #080808  |
| Color 1        | Black (normal)   | #323437  |
| Color 2        | Red (normal)     | #ff5d5d  |
| Color 3        | Green (normal)   | #8cc85f  |
| Color 4        | Yellow (normal)  | #e3c78a  |
| Color 5        | Blue (normal)    | #80a0ff  |
| Color 6        | Purple (normal)  | #cf87e8  |
| Color 7        | Cyan (normal)    | #79dac8  |
| Color 8        | White (normal)   | #c6c6c6  |
| Color 9        | Black (bright)   | #949494  |
| Color 10       | Red (bright)     | #ff5189  |
| Color 11       | Green (bright)   | #36c692  |
| Color 12       | Yellow (bright)  | #c6c684  |
| Color 13       | Blue (bright)    | #74b2ff  |
| Color 14       | Purple (bright)  | #ae81ff  |
| Color 15       | Cyan (bright)    | #85dc85  |
| Color 16       | White (bright)   | #e4e4e4  |
```



```nix
{
  base00 = "#000000"; base00 = "#000000"; base00 = "#000000"; base00 = "#080808";
  base01 = "#242422"; base01 = "#262626"; base01 = "#1c1c1c"; base01 = "#323437";
  base02 = "#484844"; base02 = "#3a3a3a"; base02 = "#262626"; base02 = "#949494";
  base03 = "#6c6c66"; base03 = "#626262"; base03 = "#3a3a3a"; base03 = "#9e9e9e";
  base04 = "#918f88"; base04 = "#808080"; base04 = "#626262"; base04 = "#bdbdbd";
  base05 = "#b5b3aa"; base05 = "#b2b2b2"; base05 = "#b2b2b2"; base05 = "#c6c6c6";
  base06 = "#d9d7cc"; base06 = "#d4d4d4"; base06 = "#d4d4d4"; base06 = "#e4e4e4";
  base07 = "#fdfbee"; base07 = "#e4e4e4"; base07 = "#e4e4e4"; base07 = "#eeeeee";
  base08 = "#df4c40"; base08 = "#ff5d5d"; base08 = "#ff5d5d"; base08 = "#ff5d5d";
  base09 = "#c9a042"; base09 = "#de935f"; base09 = "#de935f"; base09 = "#e3c78a";
  base0A = "#dfdf96"; base0A = "#e3c78a"; base0A = "#e3c78a"; base0A = "#c6c684";
  base0B = "#88df40"; base0B = "#8cc85f"; base0B = "#8cc85f"; base0B = "#8cc85f";
  base0C = "#a6a5de"; base0C = "#79dac8"; base0C = "#79dac8"; base0C = "#79dac8";
  base0D = "#76abde"; base0D = "#80a0ff"; base0D = "#80a0ff"; base0D = "#80a0ff";
  base0E = "#df53dd"; base0E = "#ae81ff"; base0E = "#ae81ff"; base0E = "#cf87e8";
  base0F = "#916a1d"; base0F = "#e9958e"; base0F = "#e9958e"; base0F = "#36c692";
  base10 = "#ff6c60"; base10 = "#ff5189"; base10 = "#ff6c60"; base10 = "#ff5189";
  base11 = "#e9c062"; base11 = "#e9c062"; base11 = "#f09479"; base11 = "#c6c684";
  base12 = "#ffffb6"; base12 = "#ffffb6"; base12 = "#ffffb6"; base12 = "#e4e4e4";
  base13 = "#a8ff60"; base13 = "#85dc85"; base13 = "#85dc85"; base13 = "#85dc85";
  base14 = "#c6c5fe"; base14 = "#adadf3"; base14 = "#adadf3"; base14 = "#ae81ff";
  base15 = "#96cbfe"; base15 = "#74b2ff"; base15 = "#74b2ff"; base15 = "#74b2ff";
  base16 = "#ff73fd"; base16 = "#cf87e8"; base16 = "#cf87e8"; base16 = "#ae81ff";
  base17 = "#b18a3d"; base17 = "#c6c684"; base17 = "#ffb5a7"; base17 = "#b2ceee";
}
```
