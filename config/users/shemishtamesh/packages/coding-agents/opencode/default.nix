{ pkgs, config, ... }:
let
  openrouter_key_env_var = "OPENROUTER_API_KEY";

  shared = import ../shared { openrouterKeyEnvVar = openrouter_key_env_var; };

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
        enabled = true;
        notifications = true;
        sound = true;
      };
    };
    settings = {
      default_agent = "analyst";

      model = "ollama/qwen3-coder";

      permission = {
        "*" = "ask";

        doom_loop = "ask";

        read = shared.sensitiveReadRules // {
          "/tmp/opencode-sandbox/**" = "allow";
        };
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
          "/tmp/opencode-sandbox/**" = "allow";
        };
        edit = {
          "*" = "ask";
          "/tmp/opencode-sandbox/**" = "allow";
        };

        bash = shared.askBash;

        webfetch = "allow";
        websearch = "allow";

        external_directory = shared.externalDirectoryDeny // {
          "/tmp/opencode-sandbox/**" = "allow";
        };
      };

      agent = {
        build.disable = true;
        plan.disable = true;

        advisor = {
          mode = "primary";
          order = 1;
          description = "Read-only. No execute.";
          prompt = "You are in read-only mode. You can read files and run commands to help you with that but you can not and must not try to change the state of anything/write/edit.";
          permission = {
            edit = "deny";
            write = "deny";
            bash = shared.denyBash;
            task = "deny";
          };
        };

        analyst = {
          mode = "primary";
          order = 2;
          description = "Read-only. Run read commands.";
          prompt = "You are in read-only mode. Run read-only commands. Prefer non-bash tools; use bash when more efficient.";
          permission = {
            edit = "deny";
            write = "deny";
            task = "deny";
          };
        };

        editor = {
          mode = "primary";
          order = 3;
          description = "Ask-write. Run read/write commands.";
          prompt = "You can read and write files freely. You can run read and write commands (e.g. cat, hostname, sed, tee), but not arbitrary code. Prefer non-bash tools; use bash when more efficient for reading or writting.";
          permission = {
            edit = "ask";
            write = "ask";
            task = "allow";
          };
        };

        writter = {
          mode = "primary";
          order = 4;
          description = "Auto-write. Run commands.";
          prompt = "You can read and write files, and run commands. Prefer non-bash tools; but use bash when needed.";
          permission = {
            edit = agentEditAllow;
            task = "allow";
          };
        };

        yolo = {
          mode = "primary";
          order = 5;
          description = "Full access within project.";
          prompt = "You have full read/write/execute access within the project. Prefer non-bash tools; but use bash when needed.";
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
