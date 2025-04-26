{
  programs.btop = {
    enable = true;
    settings = {
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
      vim_keys = true;
      graph_symbol_gpu = "default";
      shown_boxes = "proc cpu mem net gpu0";
      proc_sorting = "cpu direct";
      update_ms = 100;
    };
  };
}
