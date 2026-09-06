{ pkgs }:

pkgs.buildNpmPackage {
  pname = "pi-landstrip-patched";
  version = "0.18.43";

  src = pkgs.fetchFromGitHub {
    owner = "landstrip";
    repo = "landstrip";
    rev = "5da71c932a7e6e1c059ca2096935d0fe50e3d566";
    hash = "sha256-I2HM2OQi+beV+QyDMS8hNnnMe0MAmUbvs/0rk3a2XWc=";
  };

  # The repository is an npm workspace; its lockfile is at the repository root.
  npmDepsHash = pkgs.lib.fakeHash;
  npmBuildScript = "build --workspace=packages/pi-landstrip";
  nativeBuildInputs = [ pkgs.bun ];
  npmFlags = [ "--legacy-peer-deps" ];

  postBuild = ''
    ${pkgs.nodejs_22}/bin/node ${./patch.js} packages/pi-landstrip/dist/index.ts
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -a packages/pi-landstrip $out/
    cp -a node_modules $out/
    runHook postInstall
  '';

  meta.description = "Patched pi-landstrip extension";
}
