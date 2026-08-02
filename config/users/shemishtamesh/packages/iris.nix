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
    keybindings = {
      select = "ctrl+y";
      navigate-up = "ctrl+p";
      navigate-down = "ctrl+n";
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

      # IRIS_FD is set inside the process launched by iris to prevent recursion.
      if [[ -o interactive && -z "$IRIS_FD" ]]; then
        exec iris
      fi
    '';
}
