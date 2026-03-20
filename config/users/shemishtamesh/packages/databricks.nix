{ pkgs, ... }:

{
  home = let databricks-cli = pkgs.databricks-cli {
    packages = [ databricks-cli ];
    file.".zsh/completions/_databricks".source =
      let
        databricksZshCompletion = pkgs.runCommand "databricks-zsh-completion" { } ''
          mkdir -p "$out"
          ${databricks-cli}/bin/databricks completion zsh > "$out/_databricks"
        '';
      in
      "${databricksZshCompletion}/_databricks";
  };
}
