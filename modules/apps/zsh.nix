{ ... }:

{
  programs.zsh.enable = true;
  programs.zsh.shellAliases = {
    n = "nvim";

    grep = "grep --color=auto";
    ls = "ls --color=auto";
    l = "exa --color=auto --icons=always --git";

    rm = "rmtrash";
    rmdir = "rmdirtrash";
    sudo = "sudo ";

    cp = "cp --interactive=always";
    mv = "mv --interactive=always";
    rm = "rm --interactive=always";
    cp-yes = "cp";
    mv-yes = "mv";
    rm-yes = "rm";
  };
}

