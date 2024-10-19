{ pkgs, ... }:
{
  programs.tmux.enable = true;
  programs.tmux = {
    clock24 = true;
    escapeTime = 0;
    keyMode = "vi";
    newSession = true;
    shortcut = " ";
    plugins = [
      pkgs.tmuxPlugins.resurrect
      pkgs.tmuxPlugins.continuum
      pkgs.tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig = # tmux
      ''
        set -g mouse on
      '';
  };
}
