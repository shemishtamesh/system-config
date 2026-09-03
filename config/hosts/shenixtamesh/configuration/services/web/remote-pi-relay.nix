{ ... }:
{
  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers.remote-pi-relay = {
    image = "jacobmoura7/remote-pi-relay:latest";
    ports = [ "4047:3000" ];
    volumes = [ "remote-pi-relay-data:/data" ];
    environment = {
      REMOTEPI_RELAY_PORT = "3000";
      RUST_LOG = "info";
    };
    extraOptions = [ "--restart=unless-stopped" ];
  };

  networking.firewall.allowedTCPPorts = [ 4047 ];
}
