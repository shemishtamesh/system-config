{
  pkgs,
  lib,
  config,
  shared,
  ...
}:
let
  sesh = "${pkgs.sesh}/bin/sesh";
  sesh_list = "${sesh} list --icons --hide-attached --hide-duplicates";
  sesh_fzf_recycle_flag = "/tmp/sesh_switch_fzf_kill_last_session_after_switching_temporary";
  recycle_toggle = "\"if [ -f ${sesh_fzf_recycle_flag} ]; then rm ${sesh_fzf_recycle_flag}; else : > ${sesh_fzf_recycle_flag}; fi\"";
  recycle_prefix = "transform-prompt[sh -c '\\''[ -f ${sesh_fzf_recycle_flag} ] && printf \"♻️%s\" \"$FZF_PROMPT\" || printf \"%s\" \"\${FZF_PROMPT:1}\"'\\'']";
  sesh_switch = pkgs.writeShellScriptBin "sesh_switch_fzf_tmux" ''
    LAST_SESSION=$(tmux display-message -p '#S')

    selection=$(
      ${sesh_list} | ${pkgs.fzf}/bin/fzf-tmux -p 90%,90% \
        --no-sort --ansi --border-label ' sesh ' --prompt '⚡ ' \
        --header '^a ^t ^g ^x ^f ^r ^d' \
        --bind 'tab:down,btab:up' \
        --bind "start:change-prompt[⚡ ]" \
        --bind "ctrl-a:change-prompt[⚡ ]+reload(${sesh_list})+execute-silent(rm ${sesh_fzf_recycle_flag} || true)" \
        --bind "ctrl-t:change-prompt[🪟 ]+reload(${sesh_list} -t)+execute-silent(rm ${sesh_fzf_recycle_flag} || true)" \
        --bind "ctrl-g:change-prompt[⚙️ ]+reload(${sesh_list} -c)+execute-silent(rm ${sesh_fzf_recycle_flag} || true)" \
        --bind "ctrl-x:change-prompt[📁 ]+reload(${sesh_list} -z)+execute-silent(rm ${sesh_fzf_recycle_flag} || true)" \
        --bind "ctrl-f:change-prompt[🔎 ]+reload(${pkgs.fd}/bin/fd -H -d 2 -t d -E .Trash . ~)+execute-silent(rm ${sesh_fzf_recycle_flag} || true)" \
        --bind "ctrl-d:execute-silent(tmux kill-session -t {2..})+change-prompt(⚡ )+reload(${sesh_list})+execute-silent(rm ${sesh_fzf_recycle_flag} || true)" \
        --bind 'ctrl-r:execute-silent(sh -c ${recycle_toggle})+${recycle_prefix}' \
        --preview-window 'right:66%' \
        --preview '${sesh} preview {}'
    )

    ${sesh} connect "$selection"

    if [ -n "$selection" ] && [ -f ${sesh_fzf_recycle_flag} ]; then
      tmux kill-session -t "$LAST_SESSION"
    fi

    rm ${sesh_fzf_recycle_flag} || true
  '';
  nvim_telescope = lib.getExe (
    pkgs.writeShellScriptBin "nvim_telescope" ''
      # https://github.com/nvim-telescope/telescope.nvim/issues/3480
      nvim -c "lua vim.defer_fn(function() vim.cmd(':Telescope frecency workspace=CWD path_display={\'smart\'}') end, 100)"
    ''
  );
  palette = config.lib.stylix.colors.withHashtag;
in
{
  stylix.targets.tmux.enable = true;
  programs.tmux = {
    enable = true;
    sensibleOnTop = false; # temporary fix until https://github.com/tmux-plugins/tmux-sensible/pull/75
    clock24 = true;
    escapeTime = 0;
    keyMode = "vi";
    shortcut = "Space";
    historyLimit = 5000;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = vim-tmux-navigator;
        extraConfig = # tmux
          ''
            # clear with vim-tmux-navigator
            bind C-l send-keys 'C-l'
          '';
      }
      {
        plugin = tmux-fzf;
        extraConfig = # tmux
          ''
            TMUX_FZF_LAUNCH_KEY="C-f"
            # bind-key "a" run-shell -b "${tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/session.sh switch"
          '';

      }
      better-mouse-mode
      {
        plugin = resurrect;
        extraConfig = # tmux
          ''
            set -g @resurrect-capture-pane-contents 'on'

            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-processes '"~nvim->nvim"'
            resurrect_dir="$HOME/.local/share/tmux/resurrect"
            set -g @resurrect-dir $resurrect_dir
            set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g;s|/nix/store/.*nvim|nvim|g" $target | ${pkgs.moreutils}/bin/sponge $target'
          '';
      }
      {
        plugin = continuum;
        extraConfig = # tmux
          "set -g @continuum-restore 'on'";
      }
    ];
    extraConfig =
      with palette; # tmux
      ''
        # fix colors
        set -g default-terminal "$TERM"
        set-option -sa terminal-overrides ",$TERM*:Tc"

        # reload config file
        bind r source-file ~/.config/tmux/tmux.conf \; display ".tmux.conf reloaded"

        # disable suspend
        bind C-z resize-pane -Z

        # make selection mode more like vim
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection
        bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
        ${
          if lib.last (lib.splitString "-" pkgs.stdenv.system) == "darwin" then
            # tmux
            ''
              bind -T copy-mode-vi y send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
              bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"
            ''
          else
            ""
        }

        # allow passthrough to let images render correctly with presenterm and nvim zen mode in wezterm
        set -g allow-passthrough on

        # start new panes and windows in the same directory
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        # pane resize shortcuts
        bind -r H resize-pane -L
        bind -r J resize-pane -D
        bind -r K resize-pane -U
        bind -r L resize-pane -R

        # add/switch/kill sessions
        bind-key "a" run-shell "${sesh_switch}/bin/sesh_switch_fzf_tmux"
        bind-key "C-c" display-popup -E 'echo "project to clone:" && ${sesh} clone --cmdDir "$HOME/projects" $(head -n 1) || tmux display-message "Already exists"'
        bind-key "M-c" display-popup -E 'echo "test to clone:" && ${sesh} clone --cmdDir "$HOME/tests" $(head -n 1) || tmux display-message "Already exists"'
        bind-key "C-S-x" kill-session

        # go to last session/window/pane
        bind-key "C-p" run-shell "${sesh} last || tmux display-message 'No last session'"
        bind-key "C-w" last-window
        bind-key "C-e" last-pane

        # status line
        set -g status off
        bind -r F set-option status
        set -g status-interval 1
        set -g status-left ""
        set -g status-right ""
        set -g status-keys vi

        # vim-tpipeline
        set -g focus-events on
        set -g status-style bg=default
        set -g status-left-length 99
        set -g status-right-length 99
        set -g status-justify absolute-centre

        # prefix the session name to the first window
        set -g window-status-format '#{?window_index,#[default],#[fg=${base0D}]#[bold]#S#[fg=${base03}]#[nobold] |} #I:#W#F'
        set -g window-status-current-format '#{?window_index,#[default],#[fg=${base0D}]#[bold]#S#[fg=${base03}]#[nobold] |} #[fg=${base0D}]#I:#W#F#[default]'

        set -g status-bg \${base01}

        set -ga update-environment 'KITTY_LISTEN_ON'
      '';
  };
  xdg.configFile."sesh/sesh.toml".text = # toml
    ''
      [default_session]
      startup_command = "tmux set-option status on && clear"
      preview_command = "exa --tree --color=auto --icons=always --git --level 3 {}"

      [[session]]
      name = "home"
      startup_command = "tmux set-option status on && clear"
      path = "~"
      preview_command = "${pkgs.fastfetch}/bin/fastfetch --logo none"

      [[session]]
      name = "configuration"
      startup_command = "tmux rename-window system && tmux set-option status on && git pull && clear && ${nvim_telescope}"
      preview_command = "git -C ${shared.constants.FLAKE_ROOT_TILDE} log"
      path = "${shared.constants.FLAKE_ROOT_TILDE}"
      windows = [ "nixvim" ]

      [[window]]
      name = "nixvim"
      startup_script = "git pull && clear && ${nvim_telescope}"
      path = "~/.config/nixvim"
    '';
}
