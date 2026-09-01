{ pkgs, config, ... }:
let
  palette = config.lib.stylix.colors.withHashtag;
in
{
  home.packages = with pkgs; [
    cliamp
    yt-dlp
  ];

  sops.templates."cliamp-config" = {
    path = "${config.xdg.configHome}/cliamp/config.toml";
    content = builtins.readFile (
      (pkgs.formats.toml { }).generate "config.toml" {
        theme = "stylix";
        visualizer = "Columns";
        ytmusic = {
          cookies_from = "firefox:~/.config/zen";
          client_id = config.sops.placeholder."cliamp/youtube_client_id";
          client_secret = config.sops.placeholder."cliamp/youtube_client_secret";
        };
        spotify.client_id = config.sops.placeholder."cliamp/spotify_client_id";
      }
    );
  };

  xdg.configFile."cliamp/themes/stylix.toml".source = (pkgs.formats.toml { }).generate "stylix.toml" {
    accent = palette.base0D;
    bright_fg = palette.base07;
    fg = palette.base04;
    green = palette.base0B;
    yellow = palette.base0A;
    red = palette.base08;
  };

  sops.secrets."cliamp/youtube_client_id" = { };
  sops.secrets."cliamp/youtube_client_secret" = { };
  sops.secrets."cliamp/spotify_client_id" = { };
}
