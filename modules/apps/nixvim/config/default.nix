{
  programs.nixvim.enable = true;
  stylix.targets.nvim.enable = false;
  imports = [
    ./options.nix
    ./keymaps.nix
    ./highlights.nix
    ./plugins.nix
  ];
}
