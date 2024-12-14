{
  programs.nixvim.plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      quickfile.enabled = true;
      dashboard.enabled = false;
    };
  };
}
