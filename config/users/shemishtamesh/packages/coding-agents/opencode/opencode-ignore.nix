{ pkgs, ... }:
let
  forkSrc = pkgs.fetchFromGitHub {
    owner = "shemishtamesh";
    repo = "opencode-ignore";
    rev = "73ad34ad766bf5b5990a019e9d7f38032b5e23de";
    hash = "sha256-kuYuncFHvp/UGuuKzxvN/Z3/6hKlPlkQwp49IHq2GHM=";
  };

  ignorePkg = pkgs.fetchurl {
    name = "ignore-7.0.5.tgz";
    url = "https://registry.npmjs.org/ignore/-/ignore-7.0.5.tgz";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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
      mkdir -p node_modules
      tar xzf ${ignorePkg} -C node_modules/ignore --strip-components=1

      bun build ./index.ts --outdir ./dist --target node
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
