{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  iris = inputs.iris.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [ iris ];

  xdg.configFile."iris/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
    core = {
      expand-alias = false;
      enable-cobra-probe = false;
    };
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
        model = "qwen2.5-coder";
      };
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
