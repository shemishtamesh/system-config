{ pkgs, host, ... }:

{
  home.shell.enableZshIntegration = true;
  programs.zsh = {
    enable = true;
    shellAliases = {
      n = "nvim";
      g = "git";

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
    initContent = # sh
      ''
        setopt HIST_IGNORE_SPACE
        setopt HIST_IGNORE_DUPS
        setopt SHARE_HISTORY
        setopt HIST_FCNTL_LOCK
        setopt EXTENDED_HISTORY
        setopt AUTO_PUSHD
        setopt PUSHD_MINUS
        setopt CDABLE_VARS
        setopt promptsubst
        setopt autocd

        export HISTSIZE=100000
        export SAVEHIST=100000

        # completions
        fpath=(~/.zsh/completions $fpath)
        autoload -U compinit && compinit   # load + start completion
        zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'
        autoload -U compinit
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
        zstyle ':completion:*' menu select
        zmodload zsh/complist
        compinit
        _comp_options+=(globdots)

        # vi mode
        bindkey -v
        export KEYTIMEOUT=1
        # Change cursor shape for different vi modes.
        function zle-keymap-select {
          if [[ ''${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
            echo -ne '\e[1 q'
          elif [[ ''${KEYMAP} == main ]] || [[ ''${KEYMAP} == viins ]] \
            || [[ ''${KEYMAP} = "" ]] || [[ $1 = 'beam' ]]; then
            echo -ne '\e[5 q'
          fi
        }
        zle -N zle-keymap-select
        zle-line-init() {
          zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
          echo -ne "\e[5 q"
        }
        zle -N zle-line-init
        echo -ne '\e[5 q' # Use beam shape cursor on startup.
        preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


        # Edit line in vim with ctrl-e:
        autoload edit-command-line; zle -N edit-command-line
        bindkey '^e' edit-command-line

        ${
          if pkgs.lib.last (pkgs.lib.splitString "-" host.system) == "darwin" then
            ''
              eval "$(/opt/homebrew/bin/brew shellenv)"
            ''
          else
            ""
        }
      '';
  };
  home.file.".zsh/completions/_cht".source = builtins.fetchurl {
    url = "https://cheat.sh/:zsh";
    sha256 = "sha256:097grmcz7v0v7gqgfljzwvyvr56d9kvc3m2hw5mibq226c54sf5g";
    name = "cht-sh-zsh-completion";
  };
}
