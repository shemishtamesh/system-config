{ lib, programs, ... }:
let
  keymap = (import ../nix_functions.nix).keymap;
  toggle_diagnostics =
    if programs.nixvim.plugins.lsp.enable then
      " | lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())"
    else
      "";
  toggle_indent_blankline = if programs.nixvim.plugins.lsp.enable then " | IBLToggle" else "";
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
            colorcolumn = "0";
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
      (keymap "n" "<leader>z" lib.concatStrings [
        "<cmd>ZenMode"
        toggle_diagnostics
        toggle_indent_blankline
        "<CR>"
      ] { silent = true; })
    ];
  };
}
