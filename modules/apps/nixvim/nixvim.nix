{
  programs.nixvim.enable = true;
  imports = [ ./options.nix ./keymaps.nix ./highlights.nix ./plugins.nix ];
}
