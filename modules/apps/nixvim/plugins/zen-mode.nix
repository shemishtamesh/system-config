let
  keymap = (import ../nix_functions.nix).keymap;
in
{
  programs.nixvim = {
    plugins.zen-mode = {
      enable = true;
      settings = {
        window = {
          backdrop = 1;
          width = 80;
          height = 1;
          options = {
            signcolumn = "no";
            colorcolumn = "no";
            number = false;
            relativenumber = false;
            foldcolumn = "0";
            list = false;
          };
        };
      };
    };
    plugins.twilight.enable = true;
    keymaps = [
      (keymap "n" "<leader>z" "<cmd>ZenMode | vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>"
        { }
      )
    ];
  };
}
