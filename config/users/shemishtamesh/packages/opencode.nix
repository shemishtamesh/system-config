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
        ${openrouter_key_env_var}="$(cat ${config.sops.secrets."openrouter/general_api_key".path})"
        exec ${pkgs.opencode}/bin/opencode "$@"
      ''
    );
    enableMcpIntegration = true;
    settings = {
      model = "ollama/qwen3-coder";
      permission = {
        "*" = "ask";

        doom_loop = "ask";

        read = "allow";
        glob = "allow";
        grep = "allow";
        ls = "allow";
        find = "allow";
        subagent = "allow";

        list = "allow";
        lsp = "allow";
        codesearch = "allow";
        todoread = "allow";
        todowrite = "allow";
        task = "allow";
        skill = "allow";

        write = {
          "*" = "ask";
          ".ai/*" = "allow";
        };
        edit = {
          "*" = "ask";
          ".ai/*" = "allow";
        };

        bash = {
          "*" = "ask";

          "grep *" = "allow";
          "rg *" = "allow";

          "find *" = "allow";
          "find * -exec*" = "ask";
          "find * -execdir*" = "ask";

          ls = "allow";
          "ls *" = "allow";

          exa = "allow";
          "exa *" = "allow";

          eza = "allow";
          "eza *" = "allow";

          "cat *" = "allow";
          "head *" = "allow";
          "tail *" = "allow";
          "sort *" = "allow";
          "uniq *" = "allow";
          "wc *" = "allow";
          "file *" = "allow";
          "stat *" = "allow";
          "realpath *" = "allow";
          "readlink *" = "allow";
          "strings *" = "allow";
          "od *" = "allow";
          "xxd *" = "allow";
          "hexdump *" = "allow";
          "cut *" = "allow";
          "tr *" = "allow";
          "column *" = "allow";
          "fmt *" = "allow";
          "diff *" = "allow";
          "comm *" = "allow";
          "jq *" = "allow";
          "yq *" = "allow";
          "dirname *" = "allow";
          "basename *" = "allow";
          "expand *" = "allow";
          "unexpand *" = "allow";
          "nl *" = "allow";
          "fold *" = "allow";
          "pr *" = "allow";
          "ptx *" = "allow";

          tree = "allow";
          "tree *" = "allow";

          pwd = "allow";
          "pwd *" = "allow";

          "which *" = "allow";

          env = "allow";
          "env *" = "allow";

          "echo *" = "allow";
          "printf *" = "allow";

          "timeout *" = "allow";

          true = "allow";
          false = "allow";

          "git status*" = "allow";
          "git diff*" = "allow";
          "git log*" = "allow";
          "git show*" = "allow";
          "git blame*" = "allow";
          "git branch*" = "allow";
          "git rev-parse*" = "allow";

          "nix log*" = "allow";
          "nix eval*" = "allow";
          "nix search*" = "allow";
          "nix why-depends*" = "allow";
          "nix flake show*" = "allow";
          "nix flake metadata*" = "allow";
          "nix flake check*" = "allow";
          "nix store diff-closures*" = "allow";
          "nix profile list*" = "allow";
          "nix profile history*" = "allow";
          "nix show*" = "allow";
          "nix describe*" = "allow";

          "curl *" = "allow";
        };

        webfetch = "allow";
        websearch = "allow";

        external_directory = "ask";

        path = {
          "*" = "allow";

          "**/*.envrc" = "ask";

          "**/*.env" = "deny";
          "**/*.env.local" = "deny";
          "**/*.env.prod" = "deny";

          "**/*.pem" = "deny";
          "**/*.key" = "deny";

          "~/.ssh/**" = "deny";
          "~/.secrets/**" = "deny";
          "~/.config/sops-nix/secrets/**" = "deny";
          "~/.config/sops/age/**" = "deny";
        };
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
  sops.secrets."openrouter/general_api_key" = { };
}
