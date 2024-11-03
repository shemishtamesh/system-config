{
  pkgs,
  lib,
  config,
  ...
}:
let
  memory_segment = pkgs.writeShellScriptBin "memory_segment" ''
    memory_line=$(top -b -n 1 | grep "[KMGTPE]iB Mem")
    unit=$(echo $memory_line | grep -o "^[KMGTPE]")iB
    used=$(echo $memory_line | grep -Po '\d*(\.\d*)? used' | awk '{print $1}')
    total=$(echo $memory_line | grep -Po '\d*(\.\d*)? total' | awk '{print $1}')
    echo "$used/$total $unit "
  '';
  cpu_segment = pkgs.writeShellScriptBin "cpu_segment" ''
    memory_line=$(top -b -n 1 | grep "%Cpu(s)")
    idle=$(top -b -n 1 | grep "%Cpu(s)" | grep -Po "\d*(\.\d*)? id" | awk '{print $1}')
    echo $(echo "100 - $idle" | ${pkgs.bc}/bin/bc)% 
  '';
  palette = config.lib.stylix.colors.withHashtag;
in
{
  stylix.targets.tmux.enable = true;
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
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
            bind-key "a" run-shell -b "${tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/session.sh switch"
          '';

      }
      {
        plugin = resurrect;
        extraConfig = # tmux
          ''
            set -g @resurrect-capture-pane-contents 'on'

            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-processes '~nvim->nvim'
            resurrect_dir="$HOME/.local/share/tmux/resurrect"
            set -g @resurrect-dir $resurrect_dir
            set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s| --cmd .*-vim-pack-dir||g; s|/etc/profiles/per-user/$USER/bin/||g; s|/home/$USER/.nix-profile/bin/||g" $target | ${pkgs.moreutils}/bin/sponge $target'

          '';
      }
      {
        plugin = continuum;
        extraConfig = # tmux
          "set -g @continuum-restore 'on'";
      }
      better-mouse-mode
    ];
    extraConfig =
      with palette; # tmux
      ''
        # fix colors
        set -g default-terminal "screen-256color"

        # reload config file
        bind r source-file ~/.config/tmux/tmux.conf \; display ".tmux.conf reloaded"

        # make selection mode more like vim
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection
        bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

        # start new panes and windows in the same directory
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        # pane resize shortcuts
        bind -r H resize-pane -L
        bind -r J resize-pane -D
        bind -r K resize-pane -U
        bind -r L resize-pane -R

        # status line
        set -g status-interval 1
        set -g status-justify absolute-centre
        set -g status-left-length 100
        set -g status-right-length 100
        set -g status-left "#[bg=${base0D},fg=${base00}]#{session_name}#[bg=${base02},fg=${base0D}]"
        set -ag status-left " #{=|-24|…;s|$HOME|~|:pane_current_path}#[bg=${base00},fg=${base02}]"
        set -g status-right "#[bg=${base00},fg=${base02}]#[bg=${base02},fg=${base0D}]#(${lib.getExe memory_segment})"
        set -ag status-right " #[bg=${base0D},fg=${base00}]#(${lib.getExe cpu_segment})"
        set -g status-bg \${base00}
        set -g status-fg \${base07}
        set -g status-position top
        set -g status-keys vi
      '';
  };
}
