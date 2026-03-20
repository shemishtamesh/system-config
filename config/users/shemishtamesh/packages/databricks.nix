{ pkgs, ... }:
let
  databricks-cli = pkgs.databricks-cli;
in
{
  home.packages = [ databricks-cli ];
  programs.zsh.plugins.databricks-cli.completions =
    let
      databricksZshCompletion = pkgs.runCommand "databricks-zsh-completion" { } ''
        mkdir -p "$out"
        ${databricks-cli}/bin/databricks completion zsh > "$out/_databricks"
      '';
    in
    [ "${databricksZshCompletion}/_databricks" ];
}
