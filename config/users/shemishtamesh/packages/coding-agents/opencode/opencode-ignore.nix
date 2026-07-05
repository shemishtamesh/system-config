{ pkgs, ... }:
let
  forkSrc = pkgs.fetchFromGitHub {
    owner = "shemishtamesh";
    repo = "opencode-ignore";
    rev = "e04fdcf8a70b56ae53bcb6757cc1d0791af5e226";
    hash = "sha256-kuYuncFHvp/UGuuKzxvN/Z3/6hKlPlkQwp49IHq2GHM=";
  };

  ignorePkg = pkgs.fetchurl {
    name = "ignore-7.0.5.tgz";
    url = "https://registry.npmjs.org/ignore/-/ignore-7.0.5.tgz";
    hash = "sha256-6C1sOd5f/aeDkc/gZqFkGzI2fq1j0G1HAOm9NaqEwoA=";
  };

  opencodeIgnorePlugin = pkgs.stdenv.mkDerivation {
    pname = "opencode-ignore";
    version = "1.1.0-fork";
    src = forkSrc;
    nativeBuildInputs = [
      pkgs.bun
      pkgs.gnutar
    ];
    buildPhase = ''
      mkdir -p node_modules/ignore
      tar xzf ${ignorePkg} -C node_modules/ignore --strip-components=1

      bun build ./index.ts --outdir ./dist --target node
      # OpenCode requires default export — the fork only has named export
      echo 'export default OpenCodeIgnore;' >> dist/index.js
    '';
    installPhase = ''
      mkdir -p $out
      cp dist/index.js $out/index.js
      cat > $out/package.json << 'EOF'
{
  "name": "opencode-ignore",
  "version": "1.1.0-fork",
  "type": "module",
  "main": "./index.js"
}
EOF
    '';
  };
in
opencodeIgnorePlugin
