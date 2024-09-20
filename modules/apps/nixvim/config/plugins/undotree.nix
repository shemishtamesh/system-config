let
  keymap = (import ../nix_functions.nix).keymap;
in
{
  plugins.undotree.enable = true;
  keymaps = [ (keymap "n" "<leader>u" "<cmd>UndotreeToggle<CR>" { }) ];
}
