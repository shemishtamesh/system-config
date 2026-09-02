{
  lib,
  stdenvNoCC,
  fetchurl,
  gnutar,
}:

let
  version = "0.3.0";
  system = stdenvNoCC.hostPlatform.system;
  sources = {
    aarch64-darwin = {
      platform = "macos-aarch64";
      sha256 = "70f5acccce3cc8870c239c2fad3c7e2183192d76922edeb497d19e772f377f4a";
    };
    x86_64-darwin = {
      platform = "macos-x86_64";
      sha256 = "6f5ef0c28d323e5d769ce321d296ab42d10dfdb4d5899b841fe95ed5fbd9a877";
    };
    aarch64-linux = {
      platform = "linux-aarch64";
      sha256 = "98d6c98ded339ecf04ea2bf7d9cc52749ae79f2b8d07e0e3da425a0b24136f7b";
    };
    x86_64-linux = {
      platform = "linux-x86_64";
      sha256 = "fb01f60d79b4c5d25af43344a666c061641909e3fe62ba515b951be127829035";
    };
  };
  source = sources.${system} or (throw "agenmux: unsupported system ${system}");
  package = stdenvNoCC.mkDerivation {
    pname = "tmuxplugin-agenmux";
    inherit version;

    src = fetchurl {
      url = "https://github.com/snirt/agenmux/releases/download/v${version}/agenmux-${source.platform}.tar.gz";
      inherit (source) sha256;
    };

    nativeBuildInputs = [ gnutar ];
    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      pluginDir="$out/share/tmux-plugins/agenmux"
      mkdir -p "$pluginDir" "$out/bin"
      ${gnutar}/bin/tar -xzf "$src" --strip-components=1 -C "$pluginDir"
      ln -s "$pluginDir/target/release/agenmux" "$out/bin/agenmux"

      runHook postInstall
    '';

    meta = {
      description = "Monitor AI coding agents in tmux";
      homepage = "https://github.com/snirt/agenmux";
      license = lib.licenses.mit;
      platforms = builtins.attrNames sources;
      mainProgram = "agenmux";
    };
  };
in
package
// {
  rtp = "${package}/share/tmux-plugins/agenmux/agenmux.tmux";
}
