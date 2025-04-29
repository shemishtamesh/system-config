# taken from here https://github.com/nix-darwin/nix-darwin/issues/1182#issuecomment-2485401568
{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    docker
  ];

  services.colima = {
    enable = true;
    createDockerSocket = true;
    groupMembers = [
      "my-username"
    ];
  };
}
