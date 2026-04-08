{ pkgs, config, ... }:
let
  openrouter_key_env_var = "OPENROUTER_API_KEY";
in
{
  programs.opencode = {
    enable = true;
    package = (
      pkgs.writeShellScriptBin "opencode" ''
        export ${openrouter_key_env_var}
        ${openrouter_key_env_var}="$(cat ${config.sops.secrets.openrouter_general_api_key.path})"
        exec ${pkgs.opencode}/bin/opencode "$@"
      ''
    );
    enableMcpIntegration = true;
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

          echo = "allow";
          "echo *" = "allow";

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
      enabled_providers = [
        "ollama"
        "opencode"
        "openrouter"
      ];
      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama";
          options = {
            baseURL = "http://localhost:11434/v1";
          };
          models = {
            qwen3-coder = { };
            "gemma4:26b" = {
              options = {
                thinking = {
                  type = "enabled";
                  textVerbosity = "low";
                };
              };
              variants = {
                high = {
                  thinking.reasoningEffort = "high";
                };
                low = {
                  thinking."reasoningEffort" = "low";
                };
              };
            };
          };
        };
        openrouter = {
          options = {
            apiKey = "{env:${openrouter_key_env_var}}";
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
  sops.secrets.openrouter_general_api_key = { };
}
