{
  programs.nixvim.plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      quickfile.enabled = false;
      dashboard.enabled = true;
    };
  };
}
