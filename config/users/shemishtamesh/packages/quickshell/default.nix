{
  config,
  pkgs,
  inputs,
  ...
}:

let
  appearanceBlock = pkgs.writeText "defaultColors.qml" (
    with config.lib.stylix.colors;
    ''
      property QtObject defaultColors: QtObject {
          property bool darkmode: true
          property color m3primary: "#${base0D}"
          property color m3onPrimary: "#${base00}"
          property color m3primaryContainer: "#${base0F}"
          property color m3onPrimaryContainer: "#${base07}"
          property color m3secondary: "#${base0E}"
          property color m3onSecondary: "#${base00}"
          property color m3secondaryContainer: "#${base02}"
          property color m3onSecondaryContainer: "#${base06}"
          property color m3background: "#${base00}"
          property color m3onBackground: "#${base05}"
          property color m3surface: "#${base00}"
          property color m3surfaceContainerLow: "#${base01}"
          property color m3surfaceContainer: "#${base02}"
          property color m3surfaceContainerHigh: "#${base03}"
          property color m3surfaceContainerHighest: "#${base04}"
          property color m3onSurface: "#${base05}"
          property color m3surfaceVariant: "#${base03}"
          property color m3onSurfaceVariant: "#${base0A}"
          property color m3inverseSurface: "#${base05}"
          property color m3inverseOnSurface: "#${base01}"
          property color m3outline: "#${base04}"
          property color m3outlineVariant: "#${base03}"
          property color m3shadow: "#000000"
      }
    ''
  );

  overviewPatched = pkgs.runCommand "quickshell-overview-patched" { } ''
    cp -r ${inputs.quickshell-overview} $out
    chmod -R u+w $out

    python3 <<'PY'
    from pathlib import Path
    qml = Path("$out/common/Appearance.qml")
    block = Path("${appearanceBlock}").read_text()

    old = '''
        property QtObject defaultColors: QtObject {
            property bool darkmode: true
            property color m3primary: "#E5B6F2"
            property color m3onPrimary: "#452152"
            property color m3primaryContainer: "#5D386A"
            property color m3onPrimaryContainer: "#F9D8FF"
            property color m3secondary: "#D5C0D7"
            property color m3onSecondary: "#392C3D"
            property color m3secondaryContainer: "#534457"
            property color m3onSecondaryContainer: "#F2DCF3"
            property color m3background: "#161217"
            property color m3onBackground: "#EAE0E7"
            property color m3surface: "#161217"
            property color m3surfaceContainerLow: "#1F1A1F"
            property color m3surfaceContainer: "#231E23"
            property color m3surfaceContainerHigh: "#2D282E"
            property color m3surfaceContainerHighest: "#383339"
            property color m3onSurface: "#EAE0E7"
            property color m3surfaceVariant: "#4C444D"
            property color m3onSurfaceVariant: "#CFC3CD"
            property color m3inverseSurface: "#EAE0E7"
            property color m3inverseOnSurface: "#342F34"
            property color m3outline: "#988E97"
            property color m3outlineVariant: "#4C444D"
            property color m3shadow: "#000000"
        }
    '''.strip("\n")

    text = qml.read_text()
    if old not in text:
        raise SystemExit("defaultColors block not found in Appearance.qml")
    qml.write_text(text.replace(old, block.strip("\n")))
    PY
  '';
in
{
  xdg.enable = true;

  home.packages = with pkgs; [
    quickshell
    qt6.qtdeclarative
    qt6.qtwayland
  ];

  qt.enable = true;

  xdg.configFile = {
    "quickshell/overview" = {
      source = overviewPatched;
      recursive = true;
    };

    "quickshell/overview/config.json".text = builtins.toJSON {
      overview = {
        rows = 3;
        columns = 3;
        scale = 0.16;
        enable = true;
        hideEmptyRows = false;
      };
      appearance = {
        colorSource = "default";
      };
    };
  };
}
