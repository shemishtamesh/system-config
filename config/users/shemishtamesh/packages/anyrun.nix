{ inputs, pkgs, ... }:
{
  programs.anyrun = {
    enable = true;
    config = {
      x = {
        fraction = 0.5;
      };
      y = {
        fraction = 0.3;
      };
      width = {
        fraction = 0.3;
      };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = null;

      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        dictionary
        kidex
        randr
        rink
        shell
        stdin
        symbols
        translate
        websearch
      ];
    };

    extraCss = # css
      ''
        .some_class {
          background: red;
        }
      '';
  };

  extraConfigFiles."some-plugin.ron".text = # ron
    ''
      Config(
        prefix: ":",
        language_delimiter: ">",
        max_entries: 3,
      )
    '';
}
