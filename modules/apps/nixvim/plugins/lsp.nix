{ pkgs, ... }:
let
  keymap = (import ../nix_functions.nix).keymap;
in
{
  programs.nixvim = {
    diagnostics.signs.text.__raw = # lua
      ''
        {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.HINT] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.WARN] = "",
        }
      '';
    plugins = {
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd = {
            enable = true;
            settings.formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
          };
          pyright.enable = true;
          rust_analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
          lua_ls = {
            enable = true;
            settings = {
              telemetry.enable = false;
              diagnostics.globals = [ "vim" ];
            };
          };
        };
        # keymaps = {
        #   lspBuf = {
        #     "<leader>la" = "code_action";
        #     "<leader>lf" = "format";
        #     "<leader>ln" = "rename";
        #     "<leader>lm" = "implementation";
        #     "<leader>li" = "incoming_calls";
        #     "<leader>lo" = "outgoing_calls";
        #     "<leader>lr" = "references";
        #     "<leader>lh" = "signature_help";
        #     "<leader>lt" = "type_definition";
        #     "<leader>lc" = "typehierarchy";
        #     "<leader>ls" = "workspace_symbol";
        #     "gd" = "definition";
        #     "gD" = "declaration";
        #   };
        #   diagnostic = {
        #     "<leader>ld" = "setqflist";
        #     "]d" = "goto_next";
        #     "[d" = "goto_prev";
        #   };
        # };
      };
    };
    keymaps = [
      (keymap "n" "<leader>la" "vim.lsp.buf.code_action()" { silent = true; })
      (keymap "n" "<leader>lf" "vim.lsp.buf.format()" { silent = true; })
      (keymap "n" "<leader>ln" "vim.lsp.buf.rename()" { silent = true; })
      (keymap "n" "<leader>lm" "vim.lsp.buf.implementation()" { silent = true; })
      (keymap "n" "<leader>li" "vim.lsp.buf.incoming_calls()" { silent = true; })
      (keymap "n" "<leader>lo" "vim.lsp.buf.outgoing_calls()" { silent = true; })
      (keymap "n" "<leader>lr" "vim.lsp.buf.references()" { silent = true; })
      (keymap "n" "<leader>lh" "vim.lsp.buf.signature_help()" { silent = true; })
      (keymap "n" "<leader>lt" "vim.lsp.buf.type_definition()" { silent = true; })
      (keymap "n" "<leader>lc" "vim.lsp.buf.typehierarchy()" { silent = true; })
      (keymap "n" "<leader>ls" "vim.lsp.buf.workspace_symbol()" { silent = true; })
      (keymap "n" "gd" "vim.lsp.buf.definition()" { silent = true; })
      (keymap "n" "gD" "vim.lsp.buf.declaration()" { silent = true; })
      (keymap "n" "<leader>ld" "vim.diagnostic.setqflist()" { silent = true; })
      (keymap "n" "]d" "vim.lsp.buf.goto_next()" { silent = true; })
      (keymap "n" "[d" "vim.lsp.buf.goto_prev()" { silent = true; })
    ];
  };
}
