# { inputs, pkgs, ... }:
# {
#   programs.anyrun = {
#     enable = true;
#     config = {
#       x = {
#         fraction = 0.5;
#       };
#       y = {
#         fraction = 0.3;
#       };
#       width = {
#         fraction = 0.3;
#       };
#       hideIcons = false;
#       ignoreExclusiveZones = false;
#       layer = "overlay";
#       hidePluginInfo = false;
#       closeOnClick = true;
#       showResultsImmediately = true;
#       maxEntries = null;
#
#       plugins = with inputs.anyrun.packages.${pkgs.system}; [
#         applications
#         dictionary
#         kidex
#         randr
#         rink
#         shell
#         stdin
#         symbols
#         translate
#         websearch
#       ];
#     };
#
#     extraCss = # css
#       ''
#         .some_class {
#           background: red;
#         }
#       '';
#
#     extraConfigFiles."some-plugin.ron".text = # ron
#       ''
#         Config(
#           prefix: ":",
#           language_delimiter: ">",
#           max_entries: 3,
#         )
#       '';
#   };
# }

{
  pkgs,
  inputs,
  ...
}:
{
  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        shell
        symbols
        translate
      ];

      width.fraction = 0.25;
      y.fraction = 0.3;
      hidePluginInfo = true;
      closeOnClick = true;
    };

    extraCss = builtins.readFile (./. + "/style-dark.css");

    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          desktop_actions: false,
          max_entries: 5,
          terminal: Some("ghostty"),
        )
      '';

      "shell.ron".text = ''
        Config(
          prefix: ">"
        )
      '';
    };
  };
}
