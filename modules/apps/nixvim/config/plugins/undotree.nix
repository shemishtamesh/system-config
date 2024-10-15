let
  keymap = (import ../nix_functions.nix).keymap;
in
{
  programs.nixvim.plugins = {
    undotree.enable = true;
    keymaps = [ (keymap "n" "<leader>u" "<cmd>UndotreeToggle<CR>" { }) ];
  }
}
