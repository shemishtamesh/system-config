{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [ databricks-cli ];
    file.".zsh/completions/_databricks".source =
      let
        databricksZshCompletion = pkgs.runCommand "databricks-zsh-completion" { } ''
          mkdir -p $out
          ${pkgs.databricks-cli}/bin/databricks completion zsh > $out/_databricks
        '';
      in
      "${databricksZshCompletion}/_databricks";
  };
}
