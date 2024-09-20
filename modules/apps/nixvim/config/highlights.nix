{
  autoCmd = [
    {
      event = "TextYankPost";
      command = /* lua */ ''
        lua vim.highlight.on_yank({ higroup = "Visual", timeout = 120 })
      '';
    }
  ];
}
