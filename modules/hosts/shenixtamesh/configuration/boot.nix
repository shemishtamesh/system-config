{ config, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [
      "snd-seq"
      "snd-rawmidi"
      "v4l2loopback"
      "i2c-dev"
    ];
    supportedFilesystems = [ "ntfs" ];
    kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  };
}
