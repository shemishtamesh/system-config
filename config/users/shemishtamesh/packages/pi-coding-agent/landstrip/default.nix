{ pkgs }:
let
  version = "0.19.2";
  platform =
    {
      "x86_64-linux" = {
        npmPlatform = "linux-x64";
        hash = "sha512-4UUtD3ZRsjb0NZd1QI+rYDOgTA16Q/Z7mE9cuOpqXqPVKmFGAwqcoDhb9BiKX5C6EItPvhOjnR+lbLHiteu22g==";
      };
      "aarch64-darwin" = {
        npmPlatform = "darwin-arm64";
        hash = "sha512-vsFOXPnXOk920nd5CwM0uL+ZyIxLEWDJp80FJBflI4GaE9HXwFH6LwHQQlxxcaMzLiswzjixm4nyyfZGHyg6+A==";
      };
    }
    .${pkgs.stdenv.hostPlatform.system}
      or (throw "Unsupported landstrip platform: ${pkgs.stdenv.hostPlatform.system}");
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "landstrip";
  inherit version;
  src = pkgs.fetchurl {
    url = "https://registry.npmjs.org/@landstrip/landstrip-${platform.npmPlatform}/-/landstrip-${platform.npmPlatform}-${version}.tgz";
    inherit (platform) hash;
  };
  sourceRoot = "package";
  nativeBuildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.autoPatchelfHook ];
  buildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.stdenv.cc.cc.lib ];
  installPhase = ''
    runHook preInstall
    install -Dm755 bin/landstrip "$out/bin/landstrip"
    runHook postInstall
  '';
}
