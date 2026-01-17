{
  pkgs,
  inputs,
  host,
  ...
}:
let
  stable-pkgs = import inputs.nixpkgs-stable {
    inherit (host) system;
    config.allowUnfree = true;
  };
in
{
  services = {
    blueman.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="wheel", MODE="0660"
    ''; # external monitor brightness control

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome = {
      evolution-data-server.enable = true;
      gnome-online-accounts.enable = true;
      gnome-keyring.enable = true;
    }; # for noctalia shell calendar events

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
      wireplumber.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    pulseaudio.enable = false;
    playerctld.enable = true;

    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      openFirewall = true;
      environmentVariables = {
        OLLAMA_HOST = "0.0.0.0";
      };
      loadModels = [ "qwen2.5-coder:7b" ];
    };
    open-webui = {
      enable = true;
      package = stable-pkgs.open-webui;
      environment = {
        OLLAMA_API_BASE_URL = "http://localhost:11434";
        OLLAMA_CONTEXT_LENGTH = 65536;
      };
      host = "0.0.0.0";
    };
  };
}
