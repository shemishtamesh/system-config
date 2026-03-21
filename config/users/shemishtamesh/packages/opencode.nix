{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.opencode = {
    enable = true;
    package = (
      pkgs.writeShellScriptBin "opencode" ''
        export BROWSER=true
        export OPENCODE_SERVER_PASSWORD="$(cat ${config.sops.secrets.opencode_server_password.path})"
        exec ${lib.getExe pkgs.opencode} "$@"
      ''
    );
    enableMcpIntegration = true;
    web = {
      enable = true;
      extraArgs = [
        "--hostname"
        "0.0.0.0"
      ];
    };
    settings = {
      model = "ollama/qwen3-coder";
      permission = {
        external_directory = {
          "*" = "ask";
        };
        "*" = "ask";

        doom_loop = "ask";

        edit = "ask";

        bash = {
          "*" = "ask";

          # allow with no arguments or with arguments without allowing other
          # programs that could match (with "command*", e.g. "ls*" matches "lsblk")
          grep = "allow";
          "grep *" = "allow";

          ls = "allow";
          "ls *" = "allow";

          cat = "allow";
          "cat *" = "allow";

          head = "allow";
          "head *" = "allow";

          tail = "allow";
          "tail *" = "allow";

          wc = "allow";
          "wc *" = "allow";

          file = "allow";
          "file *" = "allow";

          tree = "allow";
          "tree *" = "allow";

          pwd = "allow";
          "pwd *" = "allow";

          which = "allow";
          "which *" = "allow";

          env = "allow";
          "env *" = "allow";

          "git status*" = "allow";
          "git diff*" = "allow";
          "git log*" = "allow";
          "git show*" = "allow";
          "git blame*" = "allow";
          "git branch*" = "allow";
          "git rev-parse*" = "allow";
        };

        read = "allow";
        glob = "allow";
        grep = "allow";
        list = "allow";

        lsp = "allow";
        codesearch = "allow";

        webfetch = "allow";
        websearch = "allow";

        todoread = "allow";
        todowrite = "allow";
        task = "allow";
        skill = "allow";
      };
      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          options = {
            baseURL = "http://localhost:11434/v1";
          };
          models = {
            qwen3-coder = {
              tools = true;
            };
          };
        };
      };
    };
  };
  programs.zsh.initContent =
    let
      opencodeZshCompletion = pkgs.runCommand "opencode-zsh-completion" { } ''
        export HOME=$TMPDIR  # requires HOME for some reason
        export SHELL=${pkgs.zsh}/bin/zsh  # otherwise it gives a bash version
        ${pkgs.opencode}/bin/opencode completion > "$out"
      '';
    in
    "source ${opencodeZshCompletion}";
  sops.secrets = {
    opencode_server_password = { };
  };
}
