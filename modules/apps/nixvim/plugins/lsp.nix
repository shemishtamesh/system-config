{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        nil-ls.enable = true;
        # pylsp.enable = true;
        pyright.enable = true;
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
          "gd" = "definition";
          "gD" = "declaration";
        };
        diagnostic = {
          "]d" = "goto_next";
          "[d" = "goto_prev";
        };
      };
    };
  };
}
