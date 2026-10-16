{
  lib,
  stdenvNoCC,
  fetchurl,
  gnutar,
  makeWrapper,
  libnotify,
}:

let
  version = "0.8.3";
  system = stdenvNoCC.hostPlatform.system;
  sources = {
    aarch64-darwin = {
      platform = "macos-aarch64";
      sha256 = "f47a77e5f47cafc3b2450e295e74e84ae3c4b2bb5192cb4aa59c13e57f915ab5";
    };
    x86_64-darwin = {
      platform = "macos-x86_64";
      sha256 = "5b34473a1a1d742b2d1c105e7cdec991c83fa8ca4cb6f0c654ecc569e1b90bd6";
    };
    aarch64-linux = {
      platform = "linux-aarch64";
      sha256 = "20d08a4497ed8856e17450a82f6b0e51716af23d447a7cde19e31c6b8f10780e";
    };
    x86_64-linux = {
      platform = "linux-x86_64";
      sha256 = "c8d0356c009731adb055fa5c53f12ca8ad3a7234520a61775b9df881ff203b13";
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

    nativeBuildInputs = [
      gnutar
      makeWrapper
    ];
    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      pluginDir="$out/share/tmux-plugins/agenmux"
      mkdir -p "$pluginDir" "$out/bin"
      ${gnutar}/bin/tar -xzf "$src" --strip-components=1 -C "$pluginDir"
      ${lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
        wrapProgram "$pluginDir/target/release/agenmux" \
          --prefix PATH : ${lib.makeBinPath [ libnotify ]}
      ''}
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
