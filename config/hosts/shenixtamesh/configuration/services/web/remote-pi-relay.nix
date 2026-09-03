{ ... }:
{
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";

  virtualisation.oci-containers.containers.remote-pi-relay = {
    image = "docker.io/jacobmoura7/remote-pi-relay:latest";
    ports = [ "4047:3000" ];
    volumes = [ "remote-pi-relay-data:/data" ];
    environment = {
      REMOTEPI_RELAY_PORT = "3000";
      RUST_LOG = "info";
    };
  };

  networking.firewall.allowedTCPPorts = [ 4047 ];
}
