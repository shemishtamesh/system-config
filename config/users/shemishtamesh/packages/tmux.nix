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
  segments =
    if pkgs.stdenv.isLinux then
      {
        cpu = pkgs.writeShellScriptBin "cpu_segment" ''
          memory_line=$(top -b -n 1 | grep "%Cpu(s)")
          idle=$(top -b -n 1 | grep "%Cpu(s)" | grep -Po "\d*(\.\d*)? id" | awk '{print $1}')
          echo "$(echo "100 - $idle" | ${pkgs.bc}/bin/bc)% "
        '';
        memory = pkgs.writeShellScriptBin "memory_segment" ''
          memory_line=$(top -b -n 1 | grep "[KMGTPE]iB Mem")
          unit=$(echo $memory_line | grep -o "^[KMGTPE]")iB
          used=$(echo $memory_line | grep -Po '\d*(\.\d*)? used' | awk '{print $1}')
          total=$(echo $memory_line | grep -Po '\d*(\.\d*)? total' | awk '{print $1}')
          echo "$used/$total $unit "
        '';
      }
    else if pkgs.stdenv.isDarwin then
      {
        cpu = pkgs.writeShellScriptBin "cpu_segment" ''
          memory_line=$(top -l 1 | grep "CPU usage")
          idle=$(echo $memory_line | awk '{print $7}' | sed 's/%//')
          cpu_usage=$(echo "100 - $idle" | bc)
          echo "$cpu_usage% CPU"
        '';
        memory = pkgs.writeShellScriptBin "memory_segment" ''
          UNIT='G'

          memory_line=$(top -l 1 | grep "PhysMem")
          used=$(echo $memory_line | awk '{print $2}' | sed 's/[A-Za-z]//g')
          unused=$(echo $memory_line | awk '{print $8}' | sed 's/[A-Za-z]//g')

          used_unit=$(echo $memory_line | awk '{print $2}' | grep -o '[A-Za-z]')
          unused_unit=$(echo $memory_line | awk '{print $8}' | grep -o '[A-Za-z]')

          convert_memory() {
              local value=$1
              local from_unit=$2
              local to_unit=$3
              local bytes

              # Convert from the source UNIT to bytes
              case $from_unit in
                  B) bytes=$value;;
                  K) bytes=$(echo "$value * 1024" | bc);;
                  M) bytes=$(echo "$value * 1024 * 1024" | bc);;
                  G) bytes=$(echo "$value * 1024 * 1024 * 1024" | bc);;
                  T) bytes=$(echo "$value * 1024 * 1024 * 1024 * 1024" | bc);;
              esac

              # Convert from bytes to the target UNIT
              case $to_unit in
                  B) echo $bytes;;
                  K) echo $(echo "scale=2; $bytes / 1024" | bc);;
                  M) echo $(echo "scale=2; $bytes / 1024 / 1024" | bc);;
                  G) echo $(echo "scale=2; $bytes / 1024 / 1024 / 1024" | bc);;
                  T) echo $(echo "scale=2; $bytes / 1024 / 1024 / 1024 / 1024" | bc);;
              esac
          }

          used=$(convert_memory $used $used_unit $UNIT)
          unused=$(convert_memory $unused $unused_unit $UNIT)

          # total_mib=$(echo "$used_mib + $unused_mib" | bc | sed "s/0*$//g" | sed 's/\.$//g')
          used=$(echo $used | sed "s/0*$//g" | sed 's/\.$//g')
          unused=$(echo $unused | sed "s/0*$//g" | sed 's/\.$//g')

          echo " $used,  $unused ($UNIT) RAM"
        '';
      }
    else
      {
        memory = pkgs.writeShellScriptBin "memory_segment" "echo 'unsupported system'";
        cpu = pkgs.writeShellScriptBin "cpu_segment" "echo 'unsupported system'";
      };
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
        # set -as terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[%p1%d q'
        set -as terminal-overrides ',*:Ss=\E[%p:Se=\E[%p'

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
        set -g status-justify absolute-centre
        set -g status-left-length 100
        set -g status-right-length 100
        set -g status-left "#[bg=${base0D},fg=${base00}]#{session_name}#[bg=${base02},fg=${base0D}]"
        set -ag status-left " #{=|-24|…;s|$HOME|~|:pane_current_path}#[bg=${base00},fg=${base02}]"
        set -g status-right "#[bg=${base00},fg=${base02}]#[bg=${base02},fg=${base0D}]#(${lib.getExe segments.memory})"
        set -ag status-right " #[bg=${base0D},fg=${base00}]#(${lib.getExe segments.cpu})"
        set -g status-bg \${base00}
        set -g status-fg \${base07}
        set -g status-position top
        set -g status-keys vi

        set -ga update-environment 'KITTY_LISTEN_ON'
      '';
  };
  xdg.configFile."sesh/sesh.toml".text = # toml
    ''
      [default_session]
      startup_command = "tmux set-option status on && ${nvim_telescope}"
      preview_command = "exa --tree --color=auto --icons=always --git --level 3 {}"

      [[session]]
      name = "home"
      startup_command = "tmux set-option status on"
      path = "~"
      preview_command = "${pkgs.fastfetch}/bin/fastfetch --logo none"

      [[session]]
      name = "configuration"
      startup_command = "tmux rename-window system && tmux set-option status on && git pull && ${nvim_telescope}"
      preview_command = "git -C ${shared.constants.FLAKE_ROOT_TILDE} log"
      path = "${shared.constants.FLAKE_ROOT_TILDE}"
      windows = [ "nixvim" ]

      [[window]]
      name = "nixvim"
      startup_script = "git pull && ${nvim_telescope}"
      path = "~/.config/nixvim"
    '';
}
