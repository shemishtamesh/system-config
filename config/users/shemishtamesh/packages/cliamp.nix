{ pkgs, config, ... }:
let
  palette = config.lib.stylix.colors.withHashtag;
in
{
  home.packages = with pkgs; [
    cliamp
    yt-dlp
  ];

  sops.templates."cliamp-config".content = builtins.readFile (
    (pkgs.formats.toml { }).generate "config.toml" {
      theme = "stylix";
      ytmusic = {
        cookies_from = "firefox:~/.config/zen";
        client_id = config.sops.placeholder."cliamp/youtube_client_id";
        client_secret = config.sops.placeholder."cliamp/youtube_client_secret";
      };
      spotify.bitrate = 320;
    }
  );

  xdg.configFile."cliamp/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink
      config.sops.templates."cliamp-config".path;

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
}
