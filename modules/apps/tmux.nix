{ pkgs, ... }:
{
  programs.tmux.enable = true;
  programs.tmux = {
    clock24 = true;
    escapeTime = 0;
    keyMode = "vi";
    newSession = true;
    plugins = [
      pkgs.tmuxPlugins.resurrect
      pkgs.tmuxPlugins.continuum
      pkgs.tmuxPlugins.vim-tmux-navigator
    ];
  };
}
