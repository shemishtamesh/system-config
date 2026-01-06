{
  shared,
  host,
  lib,
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
              };
            };
          }
        ) host.monitors
      )
    );
in
{
  stylix = shared.theme.stylix_settings;
  home.file = wallpaper_paths shared.theme.scheme;
  specialisation = builtins.listToAttrs (
    map (scheme: {
      inherit (scheme) name;
      value.configuration = {
        stylix = {
          base16Scheme = scheme;
          polarity = scheme.variant;
        };
        home.file = builtins.mapAttrs (file_path: wallpaper: lib.mkForce wallpaper) (
          wallpaper_paths scheme
        );
      };
    }) shared.theme.alternative_schemes
  );
}
