{
  programs.nixvim.enable = true;
  stylix.targets.nixvim.enable = false;
  imports = [
    ./options.nix
    ./keymaps.nix
    ./highlights.nix
    ./plugins.nix
  ];
}
