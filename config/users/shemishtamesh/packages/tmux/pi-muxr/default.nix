{
  lib,
  stdenv,
  importNpmLock,
  nodejs,
  writeShellApplication,
  tmux,
  libnotify,
}:
assert lib.versionAtLeast nodejs.version "24";
let
  nodeModules = importNpmLock.buildNodeModules {
    npmRoot = ./.;
    inherit nodejs;
    derivationArgs = {
      env.npm_config_build_from_source = "true";
    };
  };
  piPackage = "${nodeModules}/node_modules/@yuriteixeira/pi-muxr";
in
writeShellApplication {
  name = "pi-muxr";
  runtimeInputs = [
    nodejs
    tmux
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libnotify ];
  text = ''
    exec node ${piPackage}/dist/cli/index.js "$@"
  '';
  derivationArgs.passthru = { inherit piPackage; };
  meta = {
    description = "Tmux sidebar and dashboard for Pi coding sessions";
    homepage = "https://github.com/yuriteixeira/pi-muxr";
    license = lib.licenses.mit;
    mainProgram = "pi-muxr";
  };
}
