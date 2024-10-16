{ pkgs, ... }:
let
    keymap = (import ../nix_functions.nix).keymap;
in {
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers = {
        nil-ls = {
          enable = true;
          extraOptions.formatting.command = [ "${pkgs.nixfmt-rfc-style}" ];
        };
        pylsp.enable = true;
        rust-analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };
        lua-ls = {
          enable = true;
          settings.telemetry.enable = false;
        };
      };
      keymaps = {
        lspBuf = {
          "<leader>la" = "code_action";
          "<leader>lf" = "format";
          "<leader>ln" = "rename";
          "<leader>lm" = "implementation";
          "<leader>li" = "incoming_calls";
          "<leader>lo" = "outgoing_calls";
          "<leader>lr" = "references";
          "<leader>lh" = "signature_help";
          "<leader>lt" = "type_definition";
          "<leader>lc" = "typehierarchy";
          "<leader>ls" = "workspace_symbol";
        };
      };
    };
    keymaps = [
      (keymap "n" "gd" "<cmd>lua vim.lsp.buf.definition()<CR>" { })
      (keymap "n" "gD" "<cmd>lua vim.lsp.buf.declaration()<CR>" { })

      (keymap "n" "]d" "<cmd>lua vim.diagnostic.goto_next()<CR>" { })
      (keymap "n" "[d" "<cmd>lua vim.diagnostic.goto_prev()<CR>" { })
    ];
  };
}
