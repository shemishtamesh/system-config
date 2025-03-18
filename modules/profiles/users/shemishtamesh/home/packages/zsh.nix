{ pkgs, ... }:

{
  # home.packages = with pkgs; [ zsh ];
  programs.zsh = {
    enable = true;
    shellAliases = {
      n = "nvim";

      grep = "grep --color=auto";
      ls = "ls --color=auto";
      l = "exa --color=auto --icons=always --git";
      t = "exa --tree --color=auto --icons=always --git";

      rm = "rmtrash";
      rmdir = "rmdirtrash";
      sudo = "sudo ";

      c = "cp -i";
      m = "mv -i";
      li = "ln -i";

      md = "mkdir -p";
    };
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
    initExtra = # sh
      ''
        fpath=(~/.zsh/completions $fpath)
      '';
  };
  home.file.".zsh/completions/_cht" = {
    source = builtins.fetchurl {
      url = "https://cheat.sh/:zsh";
      sha256 = "sha256:097grmcz7v0v7gqgfljzwvyvr56d9kvc3m2hw5mibq226c54sf5g";
      name = "cht-sh-zsh-completion";
    };
  };
}
