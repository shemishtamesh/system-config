{ pkgs, ... }:

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

        # pane resize shortcuts (same as vim)
        bind -r H resize-pane -L
        bind -r J resize-pane -D
        bind -r K resize-pane -U
        bind -r L resize-pane -R
      '';
  };
}
