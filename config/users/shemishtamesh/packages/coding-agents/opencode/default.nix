{ pkgs, config, ... }:
let
  openrouter_key_env_var = "OPENROUTER_API_KEY";

  shared = import ../shared { inherit openrouter_key_env_var; };

  agentEditAllow = {
    "*" = "allow";
  }
  // shared.sensitiveEditRules;
in
{
  programs.opencode = {
    enable = true;
    package = pkgs.writeShellScriptBin "opencode" ''
      export ${openrouter_key_env_var}
      ${openrouter_key_env_var}="$(cat ${config.sops.secrets."openrouter/general_api_key".path})"
      exec ${pkgs.opencode}/bin/opencode "$@"
    '';
    enableMcpIntegration = true;
    tui = {
      attention = {
        enable = true;
        notifications = true;
        sound = true;
      };
    };
    settings = {
      default_agent = "craft";

      model = "ollama/qwen3-coder";

      permission = {
        "*" = "ask";

        doom_loop = "ask";

        read = shared.sensitiveReadRules;
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
        question = "allow";

        write = {
          "*" = "ask";
          ".agents/memory/**/*" = "allow";
        };
        edit = "ask";

        bash = shared.askBash;

        webfetch = "allow";
        websearch = "allow";

        external_directory = shared.externalDirectoryDeny;
      };

      agent = {
        build.disable = true;
        plan.disable = true;

        audit = {
          mode = "primary";
          description = "Read-only analysis. Cannot write or execute.";
          permission = {
            edit = "deny";
            todowrite = "deny";
            bash = "deny";
            task = "deny";
            external_directory = "allow";
          };
        };

        craft = {
          mode = "primary";
          description = "Edit files in project. Cannot execute.";
          permission = {
            edit = agentEditAllow;
            bash = "deny";
            task = "deny";
          };
        };

        yolo = {
          mode = "primary";
          description = "Full read, write, and execute access.";
          permission = {
            edit = agentEditAllow;
            bash = "allow";
            task = "allow";
          };
        };
      };

      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama";
          options = {
            baseURL = shared.providers.ollama.baseUrl;
          };
          models = builtins.mapAttrs (
            name: cfg:
            if cfg ? supportsThinking && cfg.supportsThinking then
              {
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
              }
            else
              { }
          ) shared.providers.ollama.models;
        };
        openrouter = {
          options = {
            apiKey = "{env:${openrouter_key_env_var}}";
          };
        };
      };

      enabled_providers = [
        "ollama"
        "opencode"
        "openrouter"
      ];
    };
  };
  home.packages = [ pkgs.libnotify ];
  programs.zsh.initContent =
    let
      opencodeZshCompletion = pkgs.runCommand "opencode-zsh-completion" { } ''
        export HOME=$TMPDIR
        export SHELL=${pkgs.zsh}/bin/zsh
        ${pkgs.opencode}/bin/opencode completion > "$out"
      '';
    in
    "source ${opencodeZshCompletion}";
  sops.secrets."openrouter/general_api_key" = { };
}
