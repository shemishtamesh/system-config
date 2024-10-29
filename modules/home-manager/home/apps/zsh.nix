{
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
    zsh-vi-mode.enable = true;
  };
}
