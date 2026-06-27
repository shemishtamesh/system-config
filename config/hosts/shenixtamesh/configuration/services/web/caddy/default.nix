{
  host,
  ...
}:
let
  external_silverbullet_port = 8443;
  external_openwebui_port = 8444;
in
{

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      allowInterfaces = [ "wlp7s0" ];
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };

    caddy = {
      enable = true;
      openFirewall = true;

      virtualHosts = {
        "https://${host.hostname}.local:${toString external_silverbullet_port}".extraConfig = ''
          tls internal
          reverse_proxy 127.0.0.1:3030
        '';

        "https://${host.hostname}.local:${toString external_openwebui_port}".extraConfig = ''
          tls internal
          reverse_proxy 127.0.0.1:8080
        '';
      };
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [
        external_silverbullet_port
        external_openwebui_port
      ];
    };
  };

  security.pki.certificateFiles = [
    ./caddy-root.crt
  ];
  systemd.tmpfiles.rules = [
    "d /var/lib/caddy/.local/share/caddy/pki/authorities/local 0755 caddy caddy - -"
    "C /var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt 0444 caddy caddy - ${./caddy-root.crt}"
  ];

  sops.secrets."caddy/root_key" = {
    path = "/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.key";
    owner = "caddy";
    group = "caddy";
    mode = "0400";
  };
}
