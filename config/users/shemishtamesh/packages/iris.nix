{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  iris = inputs.iris.packages.${pkgs.stdenv.hostPlatform.system}.default;
  palette = config.lib.stylix.colors.withHashtag;
in
{
  home.packages = [ iris ];

  xdg.configFile."iris/theme.toml".source = (pkgs.formats.toml { }).generate "theme.toml" {
    border = palette.base0D;
    accent = palette.base0B;
    muted = palette.base03;
    text = palette.base06;
    text_sel = palette.base07;
    key = palette.base0D;
    match = palette.base0B;
    desc = palette.base04;
    desc_sel = palette.base06;
    sel_bg = palette.base02;
    sel_text = palette.base00;
    scroll_info = palette.base0D;
    ghost_text = palette.base03;
    hist = palette.base01;
    hist_sel = palette.base0B;
    sys = palette.base00;
    sys_sel = palette.base0D;
    alias = palette.base01;
    alias_sel = palette.base0D;
  };

  xdg.configFile."iris/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
    ui.hidden-files = true;
    keybindings = {
      select = "ctrl+y";
      navigate-up = "ctrl+p";
      navigate-down = "ctrl+n";
    };
    updater.check-on-startup = true;
    ai = {
      enabled = true;
      provider = "ollama";
      providers.ollama = {
        endpoint = "http://localhost:11434/v1/chat/completions";
        model = "qwen2.5-coder:7b";
      };
    };
    core = {
      expand-alias = false;
      cobra-probe-enabled = false;
    };
  };

  programs.zsh.initContent =
    let
      irisZshCompletion = pkgs.runCommand "iris-zsh-completion" { } ''
        mkdir -p "$out"
        ${iris}/bin/iris completion zsh > "$out/_iris"
      '';
    in
    lib.mkOrder 550 /* sh */ ''
      fpath+=(${irisZshCompletion})

      eval "$(${lib.getExe iris} init zsh)"
    '';
}
