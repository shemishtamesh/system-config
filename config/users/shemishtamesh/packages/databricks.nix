{ pkgs, ... }:
let
  databricks-cli = pkgs.databricks-cli;
in
{
  home.packages = [ databricks-cli ];
  programs.zsh.initContent =
    let
      databricksZshCompletion = pkgs.runCommand "databricks-zsh-completion" { } ''
        export HOME=$TMPDIR
        mkdir -p "$out"
        ${databricks-cli}/bin/databricks completion > "$out/_databricks"
      '';
    in
    ''
      fpath+=(${databricksZshCompletion})
    '';
}
