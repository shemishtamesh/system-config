pkgs:

let
  nodejs = pkgs.nodejs_22;

  manifest = {
    name = "pi-extensions";
    version = "1.0.0";
    private = true;
    dependencies = {
      "@juicesharp/rpiv-ask-user-question" = "2.9.0";
      "pi-observational-memory" = "3.0.4";
      "pi-context-pruning" = "1.1.0";
      "pi-landstrip" = "0.18.43";
      "pi-permission-system" = "0.8.0";
      "pi-web-access" = "0.27.0";
      "remote-pi" = "0.7.0";

      # direct deps so npm is forced to lock them into `packages` with integrity
      "@earendil-works/chord" = "0.85.0";
      "@earendil-works/pi-agent-core" = "0.85.0";
      "@earendil-works/pi-ai" = "0.85.0";
      "@earendil-works/pi-client" = "0.85.0";
      "@earendil-works/pi-coding-agent" = "0.85.0";
      "@earendil-works/pi-protocol" = "0.85.0";
      "@earendil-works/pi-tui" = "0.85.0";
    };
    overrides = {
      "@earendil-works/pi-coding-agent" = "0.85.0";
      "@earendil-works/pi-ai" = "0.85.0";
      "@earendil-works/pi-agent-core" = "0.85.0";
      "@earendil-works/pi-tui" = "0.85.0";
      "@earendil-works/chord" = "0.85.0";
      "@earendil-works/pi-client" = "0.85.0";
      "@earendil-works/pi-protocol" = "0.85.0";
    };
  };

  manifestJson = builtins.toJSON manifest;

  # generate a lockfile
  lockForExt =
    pkgs.runCommand "pi-extensions-lock"
      {
        nativeBuildInputs = [
          nodejs
          pkgs.jq
        ];
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-mobThqKVsOKGgn7/iAE6I4z1C1VJ8aJu2IZmoaXSP3Y=";
        SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        NODE_EXTRA_CA_CERTS = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      }
      ''
        mkdir -p $out
        # redirect it somewhere writable.
        export HOME="$PWD"
        export npm_config_cache="$PWD/.npm-cache"
        cat > $out/package.json <<'EOF'
        ${manifestJson}
        EOF
        cd $out || exit
        npm install --package-lock-only --ignore-scripts --no-audit --no-fund --legacy-peer-deps

        jq '
          def keep:
            .key == ""
            or ( (.value.integrity? // "") != "" )
            or ( ((.value.resolved? // "") | test("^(git\\+|github:|gitlab:|bitbucket:)")) );
          .packages |= with_entries( select( keep ) )
        ' package-lock.json > package-lock.cleaned.json \
          && jq -e . package-lock.cleaned.json > /dev/null \
          && mv package-lock.cleaned.json package-lock.json
      '';

  # build the bundled extension tree from the generated lock
  pi-extensions = pkgs.buildNpmPackage {
    pname = "pi-extensions";
    version = "1.0.0";
    src = lockForExt;

    inherit nodejs;

    # v2 also caches registry metadata which plain `npm ci --offline` needs
    npmDepsFetcherVersion = 2;
    npmDepsHash = "sha256-ZzvWrwSRXGUND4hjdl4h4jvO9TKOwPier1yPAmEue3c=";

    dontNpmBuild = true;

    # ignore the unresolvable peer conflict
    npmFlags = [ "--legacy-peer-deps" ];

    postInstall = ''
      # deny instead of prompting for blocked access
      # never `promptOnBlock`
      sed -i 's/promptOnBlock: true/promptOnBlock: false/g' \
        "$out/lib/node_modules/pi-extensions/node_modules/pi-landstrip/dist/index.ts"

      # disable prompts, deny by default
      node -e '
        const fs = require("fs");
        const p = process.argv[1];
        let text = fs.readFileSync(p, "utf8");
        function replaceOne(re, replacement, label) {
          const matches = [...text.matchAll(re)];
          if (matches.length !== 1) {
            throw new Error("pi-landstrip patch " + label + ": expected one match, found " + matches.length);
          }
          text = text.replace(re, replacement);
        }
        // 1. deny things not in `allowRead` that are not overriden
        replaceOne(
          /^function readAllowed\(path, allowRead, denyRead, cwd\) \{\n  const deny = longestPrefixMatch\(path, denyRead, cwd\);\n  if \(deny < 0\)\n    return true;\n  return longestPrefixMatch\(path, allowRead, cwd\) >= deny;\n\}$/gm,
          "function readAllowed(path, allowRead, denyRead, cwd) {\n  const deny = longestPrefixMatch(path, denyRead, cwd);\n  const allow = longestPrefixMatch(path, allowRead, cwd);\n  if (allow < 0)\n    return false;\n  return deny < 0 || allow >= deny;\n}",
          "read allowlist"
        );
        // 2. Native Pi file tools: preserve current() results (explicit
        // allows/denies), but deny its otherwise UI-prompting fallback.
        replaceOne(
          /(\n {4}const existing = current\(\);\n {4}if \(existing\)\n {6}return existing;\n)(?: {4}if \(!ctx\.hasUI\) \{\n {6}return \{ allowed: false, prompted: false, reason: "Filesystem access requires approval" \};\n {4}\}\n)? {4}return permissionPrompts\.resolve\(current,[\s\S]*?\n {4}\}, options2\.signal\);\n {2}\}\n(?= {2}async function ensureDomainAllowed\()/g,
          "$1    return {\n      allowed: false,\n      prompted: false,\n      reason: \"Filesystem access is not allowed by sandbox policy\"\n    };\n  }\n",
          "native filesystem fallback"
        );
        // 3. Bash and Landstrip worker syscall traps: this function has
        // already separated non-filesystem (network) traps before this point.
        replaceOne(
          /(\n {4}const existing = current\(\);\n {4}if \(existing\)\n {6}return existing;\n)(?: {4}if \(!ctx\.hasUI \|\| !promptOnBlock\)\n {6}return \{ action: "deny", reason: "unprompted" \};\n)? {4}return permissionPrompts\.resolve\(current,[\s\S]*?\n {4}\}, signal\);\n {2}\}\n(?= {2}function attachWorkerTrap\()/g,
          "$1    return { action: \"deny\", reason: \"unprompted\" };\n  }\n",
          "filesystem trap fallback"
        );
        // 4. Do not turn a kernel-level filesystem denial into a second UI
        // prompt plus retry after Bash exits.
        replaceOne(
          / {4}const retryWithAccess = async \(operation, blockedPath\) => \{[\s\S]*?\n {4}\};\n(?= {4}let result;)/g,
          "    const retryWithAccess = async (_operation, _blockedPath) => null;\n",
          "bash retry fallback"
        );
        fs.writeFileSync(p, text);
      ' "$out/lib/node_modules/pi-extensions/node_modules/pi-landstrip/dist/index.ts"
    '';

    meta = {
      description = "Declaratively built pi extensions (landstrip, web-access, remote-pi, memory, context-pruning, permission-system, ask-user-question)";
      platforms = nodejs.meta.platforms;
    };
  };
in
pi-extensions
