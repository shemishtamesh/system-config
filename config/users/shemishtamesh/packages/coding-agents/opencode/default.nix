{
  pkgs,
  config,
  ...
}:
let
  openrouter_key_env_var = "OPENROUTER_API_KEY";

  sandboxDir = "/tmp/opencode-sandbox";

  shared = import ../shared { openrouterKeyEnvVar = openrouter_key_env_var; };

  agentEditAllow = {
    "*" = "allow";
  }
  // shared.sensitiveEditRules;

  sandboxAllowRead = [
    "."
    sandboxDir
  ];
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

      model = "ollama/ornith";

      plugin = [
        "opencode-sandbox"
        "@enowdev/mnemosyne"
      ];

      permission = {
        "*" = "ask";

        doom_loop = "ask";

        read = {
          "*" = "allow";
          "${sandboxDir}/**" = "allow";
        };
        glob = "allow";
        grep = "allow";
        ls = "allow";
        find = "allow";

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
          "${sandboxDir}/**" = "allow";
        };
        edit = {
          "*" = "ask";
          "${sandboxDir}/**" = "allow";
        };

        bash = shared.askBash;

        webfetch = "allow";
        websearch = "allow";

        external_directory = {
          "*" = "deny";
          "${sandboxDir}/**" = "allow";
        };
      };

      agent = {
        build.disable = true;
        plan.disable = true;

        analyst = {
          mode = "primary";
          order = 1;
          description = "Read-only. OS sandbox restricts filesystem access to the current project directory.";
          prompt = "You are in read-only mode. You can read files and look for online information but not edit or run anything. Never attempt to read files that might contain secrets.";
          permission = {
            read = "allow";
            edit = "deny";
            write = "deny";
            bash = "deny";
            task = "deny";
            external_directory = {
              "*" = "deny";
              "${sandboxDir}/**" = "allow";
            };
          };
        };

        contributor = {
          mode = "primary";
          order = 2;
          description = "Ask write, no bash.";
          prompt = "You can read and write files, and look for information online. Never attempt to read files that might contain secrets.";
          permission = {
            edit = "ask";
            write = "ask";
            bash = "deny";
            task = "allow";
          };
        };

        developer = {
          mode = "primary";
          order = 3;
          description = "Read/write via tools, No bash.";
          prompt = "You can read and write files, and look for information online. Never attempt to read files that might contain secrets.";
          permission = {
            edit = agentEditAllow;
            write = agentEditAllow;
            bash = "deny";
            task = "deny";
          };
        };

        engineer = {
          mode = "primary";
          order = 4;
          description = "Auto-write, ask for bash.";
          prompt = "You can read and write files, and run commands. Prefer non-bash tools; but use bash when needed. Never attempt to read files that might contain secrets.";
          permission = {
            edit = agentEditAllow;
            write = agentEditAllow;
            task = "allow";
          };
        };

        fullstack = {
          mode = "primary";
          order = 5;
          description = "Full arbitrary bash.";
          prompt = "You have full read/write/execute access within the project. Prefer non-bash tools; but use bash when needed. Never attempt to read files that might contain secrets.";
          permission = {
            edit = agentEditAllow;
            write = agentEditAllow;
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
  home.packages =
    with pkgs;
    [
      libnotify
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      bubblewrap
      socat
    ];
  xdg.configFile."opencode-sandbox/config.json".text = builtins.toJSON {
    filesystem = {
      allowRead = sandboxAllowRead;
      allowWrite = [
        "."
        sandboxDir
      ];
    };
  };
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
