{
  networking = {
    networkmanager.enable = true;

    nameservers = [
      # adguard
      # "94.140.14.14"
      # "94.140.15.15"
      # "2a10:50c0::ad1:ff"
      # "2a10:50c0::ad2:ff"

      "1.1.1.1" # cloudflair
      "8.8.8.8" # google
    ];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";

    # Open ports in the firewall.
    firewall = {
      allowedTCPPorts = [
        8080 # open-webui
      ];
      allowedTCPPortRanges = [
        {
          # KDE Connect
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          # KDE Connect
          from = 1714;
          to = 1764;
        }
      ];
    };
  };
}
