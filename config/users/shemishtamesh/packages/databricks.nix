{ pkgs, ... }:
let
  databricks-cli = pkgs.databricks-cli;
in
{
  home.packages = [ databricks-cli ];
  programs.zsh.initExtra =
    let
      databricksZshCompletion = pkgs.runCommand "databricks-zsh-completion" { } ''
        mkdir -p "$out"
        ${databricks-cli}/bin/databricks-cli completion > "$out/_databricks"
      '';
    in
    ''
      fpath+=(${databricksZshCompletion})
    '';
}
