{
  pkgs,
  host,
  lib,
  ...
}:
let
  darwin = pkgs.lib.last (pkgs.lib.splitString "-" host.system) == "darwin";
  nvim_telescope = lib.getExe (
    pkgs.writeShellScriptBin "nvim_telescope" ''
      # https://github.com/nvim-telescope/telescope.nvim/issues/3480
      nvim -c "set filetype=man | lua vim.defer_fn(function() vim.cmd(':Telescope man_pages sections=[\'ALL\']') end, 100)"
    ''
  );
in
{
  home.shell.enableZshIntegration = true;
  programs.zsh = {
    enable = true;
    shellAliases = {
      g = "git";
      n = "nvim";
      nm = nvim_telescope;

      grep = "grep --color=auto";
      ls = "ls --color=auto";
      l = "exa --color=auto --icons=always --git";
      lg = "exa --color=auto --icons=always --git --git-ignore --all";
      t = "exa --tree --color=auto --icons=always --git";
      tg = "exa --tree --color=auto --icons=always --git --git-ignore --all";

      rm = "rmtrash";
      rmdir = "rmdirtrash";

      c = "cp -i";
      m = "mv -i";
      li = "ln -i";

      md = "mkdir -p";
      mdz = "(){mkdir -p $1 && z $1}";

      sudo = "sudo "; # allow aliases in sudo
      sd = "sudo --login --user=$USER";

      o = if darwin then "open" else "xdg-open";
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

        # # vi mode
        # bindkey -v
        # export KEYTIMEOUT=1
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
          if darwin then
            ''
              eval "$(/opt/homebrew/bin/brew shellenv)"
            ''
          else
            ""
        }
      '';
  };
}
