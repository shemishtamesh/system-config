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
      proc_cpu_graphs = true;
      proc_filter_kernel = false;
      proc_aggregate = true;
      cpu_graph_upper = "user";
      cpu_graph_lower = "system";
      show_gpu_info = "Auto";
      clock_format = "%X";
      disks_filter = "";
      use_fstab = true;
      zfs_hide_datasets = false;
      io_mode = false;
      net_sync = true;
      net_iface = "";
      show_battery_watts = true;
      nvml_measure_pcie_speeds = true;
      gpu_mirror_graph = false;
    };
  };
}
