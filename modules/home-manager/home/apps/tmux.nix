{ pkgs, lib, ... }:
let
  memory_segment = pkgs.writeShellScriptBin "memory_segment" ''
    memory_line=$(top -b -n 1 | grep "[KMGTPE]iB Mem")
    unit=$(echo $memory_line | grep -o "^[KMGTPE]")iB
    used=$(echo $memory_line | grep -Po '\d*(\.\d*)? used' | awk '{print $1}')
    total=$(echo $memory_line | grep -Po '\d*(\.\d*)? total' | awk '{print $1}')
    echo "$used/$total $unit RAM"
  '';
  cpu_segment = pkgs.writeShellScriptBin "cpu_segment" ''
    memory_line=$(top -b -n 1 | grep "%Cpu(s)")
    idle=$(top -b -n 1 | grep "%Cpu(s)" | grep -Po "\d*(\.\d*)? id" | awk '{print $1}')
    echo $(echo "100 - $idle" | ${pkgs.bc}/bin/bc)% CPU
  '';
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
    plugins = [
      pkgs.tmuxPlugins.better-mouse-mode
      pkgs.tmuxPlugins.vim-tmux-navigator
      pkgs.tmuxPlugins.tmux-fzf
      pkgs.tmuxPlugins.resurrect
      pkgs.tmuxPlugins.continuum
    ];
    extraConfig = # tmux
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

        # pane resize shortcuts
        bind -r H resize-pane -L
        bind -r J resize-pane -D
        bind -r K resize-pane -U
        bind -r L resize-pane -R

        # switch sessions
        bind -n C-f run-shell "tmux list-windows -F \"##I:##W\" | fzf-tmux | cut -d \":\" -f 1 | xargs tmux select-window -t"

        # status line
        set -g status-interval 1
        set -g status-justify absolute-centre
        set -g status-left-length 100
        set -g status-right-length 100
        set -g status-left "#[bg=#80a0ff,fg=#000000]#{session_name}#[bg=#303030,fg=#80a0ff]"
        set -ag status-left " #{=|-24|…;s|$HOME|~|:pane_current_path}#[bg=#000000,fg=#303030]"
        set -g status-right "#[bg=#000000,fg=#303030]#[bg=#303030,fg=#80a0ff]#(${lib.getExe memory_segment})"
        set -ag status-right " #[bg=#80a0ff,fg=#000000]#(${lib.getExe cpu_segment})"
        set -g status-bg \#000000
        set -g status-fg \#FFFFFF
        set -g status-position top
        set -g status-keys vi
      '';
  };
}
