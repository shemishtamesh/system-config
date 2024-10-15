{
  programs.nixvim.plugins.lsp = {
    enable = true;
    servers = {
      nil-ls.enable = true;
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
  };
}
