{
  services = {
    pulseaudio.enable = false;
    blueman.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="wheel", MODE="0660"
    ''; # external monitor brightness control

    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;

    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      xkb = {
        # Configure keymap in X11
        layout = "us";
        variant = "";
      };

      videoDrivers = [ "nvidia" ];
    };
    printing.enable = true; # Enable CUPS to print documents.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    syncthing = {
      enable = true;
      user = "shemishtamesh";
      dataDir = "/home/shemishtamesh/Documents";
      configDir = "/home/shemishtamesh/.config/syncthing";
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        devices = {
          "Pixel 7 Pro" = {
            id = "Q35X57O-SPYHCOF-6N3HLH4-OQUN6M7-7D7X7T4-DXI7ZCK-JTWUOSX-2YE3IAH";
          };
          "work_pc" = {
            id = "QK20V3H-G5ZZKKA-STI2UJN-SWTWVOG-2SBLZ2A-T6MUGD4-Z2E0M5U-QJNOJQD";
          };
        };
        folders = {
          "general_vault" = {
            path = "/home/shemishtamesh/Documents/general_vault";
            devices = [
              "Pixel 7 Pro"
              "work_pc"
            ];
          };
        };
      };
    };
    ollama = {
      enable = true;
      openFirewall = true;
      environmentVariables = {
        OLLAMA_HOST = "0.0.0.0";
      };
      loadModels = [ "qwen2.5-coder:7b" ];
      acceleration = "cuda";
    };
    open-webui = {
      enable = true;
      environment.OLLAMA_API_BASE_URL = "http://localhost:11434";
      host = "0.0.0.0";
    };
  };
}
