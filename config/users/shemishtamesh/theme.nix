{
  pkgs,
  shared,
  host,
  lib,
  config,
  ...
}:
let
  wallpaper_paths =
    scheme:
    builtins.listToAttrs (
      builtins.attrValues (
        builtins.mapAttrs (
          portname:
          {
            width,
            height,
            ...
          }:
          {
            name = "Pictures/Wallpapers/${portname}/wallpaper.png";
            value = {
              source = shared.theme.wallpaper_generator {
                name = portname;
                inherit width height;
                background = true;
                color_scheme = scheme;
                gaps = false;
              };
            };
          }
        ) host.monitors
      )
    );
in
{
  stylix = shared.theme.stylix_settings;
  home = {
    file = wallpaper_paths shared.theme.scheme;
    pointerCursor.enable = pkgs.stdenv.isLinux;
  };

  qt = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
  };
  # stylix delivers kdeglobals via XDG_CONFIG_DIRS which systemd-launched apps never see
  # place it directly instead.
  xdg.configFile = lib.mkIf pkgs.stdenv.isLinux {
    "kdeglobals".source = "${lib.head config.xdg.systemDirs.config}/kdeglobals";
  };

  specialisation = builtins.listToAttrs (
    map (scheme: {
      inherit (scheme) name;
      value.configuration = {
        stylix = {
          base16Scheme = scheme;
          polarity = lib.mkForce scheme.variant;
        };
        home.file = builtins.mapAttrs (file_path: wallpaper: lib.mkForce wallpaper) (
          wallpaper_paths scheme
        );
      };
    }) shared.theme.alternative_schemes
  );
}
