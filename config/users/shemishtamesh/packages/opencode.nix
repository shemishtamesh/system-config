{
  config,
  # inputs,
  # host,
  pkgs,
  ...
}:
let
  # stable-pkgs = import inputs.nixpkgs-stable {
  #   system = host.system;
  #   config.allowUnfree = true;
  # };
  # opencode = stable-pkgs.opencode;
in
{
  programs.opencode = {
    enable = true;
    package = (
      pkgs.writeShellScriptBin "opencode" ''
        OPENCODE_SERVER_PASSWORD=$(cat ${config.sops.secrets.opencode_server_password.path}) ${pkgs.opencode} "$@"
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

          "grep*" = "allow";
          "ls*" = "allow";

          "git status*" = "allow";
          "git diff*" = "allow";
          "git log*" = "allow";
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
  # programs.zsh.initContent =
  #   let
  #     opencodeZshCompletion = pkgs.runCommand "opencode-zsh-completion" { } ''
  #       export HOME=$TMPDIR  # requires HOME for some reason
  #       export SHELL=${pkgs.zsh}/bin/zsh  # otherwise it gives a bash version
  #       ${opencode}/bin/opencode completion > "$out"
  #     '';
  #   in
  #   "source ${opencodeZshCompletion}";
}
