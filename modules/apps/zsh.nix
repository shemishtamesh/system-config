{ ... }:

{
  programs.zsh.enable = true;
  programs.zsh = {
    setOptions = [
      "HIST_IGNORE_SPACE"
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
      "HIST_FCNTL_LOCK"
      "EXTENDED_HISTORY"
      "AUTO_PUSHD"
      "PUSHD_MINUS"
      "CDABLE_VARS"
    ];
    shellAliases = {
      n = "nvim";

      grep = "grep --color=auto";
      ls = "ls --color=auto";
      l = "exa --color=auto --icons=always --git";

      rm = "rmtrash";
      rmdir = "rmdirtrash";
      sudo = "sudo ";

      cp = "cp --interactive=always";
      mv = "mv --interactive=always";
      cp-yes = "cp";
      mv-yes = "mv";
    };
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
  };
}
