{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    escapeTime = 0;
    keyMode = "vi";
    shortcut = "Space";
    historyLimit = 5000;
    mouse = true;
    # plugins = [
    #   # pkgs.tmuxPlugins.better-mouse-mode
    #   pkgs.tmuxPlugins.vim-tmux-navigator
    #   # pkgs.tmuxPlugins.resurrect
    #   # pkgs.tmuxPlugins.continuum
    # ];
    extraConfig = # tmux
      ''
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection
        bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
      '';
  };
}
