{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  iris = inputs.iris.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [ iris ];

  xdg.configFile."iris/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
    ui.hidden-files = true;
    keybindings = {
      select = "ctrl+y";
      navigate-up = "ctrl+p";
      navigate-down = "ctrl+n";
    };
    updater.check-on-startup = true;
    ai = {
      enabled = true;
      provider = "ollama";
      providers.ollama = {
        endpoint = "http://localhost:11434/v1/chat/completions";
        model = "qwen2.5-coder";
      };
    };
    core = {
      expand-alias = false;
      cobra-probe-allowlist = [
        "kubectl"
        "kubeadm"
        "oc"
        "helm"
        "helmfile"
        "kind"
        "k3d"
        "minikube"
        "kops"
        "eksctl"
        "clusterctl"
        "istioctl"
        "linkerd"
        "cilium"
        "argocd"
        "flux"
        "kustomize"
        "velero"
        "skaffold"
        "k9s"
        "stern"
        "crossplane"
        "kpt"
        "conftest"
        "operator-sdk"
        "kubebuilder"
        "docker"
        "docker-compose"
        "nerdctl"
        "podman"
        "buildah"
        "gh"
        "glab"
        "act"
        "goreleaser"
        "doctl"
        "civo"
        "cosign"
        "syft"
        "grype"
        "trivy"
        "cockroach"
        "hugo"
        "rclone"
        "restic"
        "buf"
        "golangci-lint"
        "task"
        "dlv"
        "ko"
        "yq"
        "cobra-cli"
      ];
    };
  };

  programs.zsh.initContent =
    let
      irisZshCompletion = pkgs.runCommand "iris-zsh-completion" { } ''
        mkdir -p "$out"
        ${iris}/bin/iris completion zsh > "$out/_iris"
      '';
    in
    lib.mkOrder 550 /* sh */ ''
      fpath+=(${irisZshCompletion})

      eval "$(${lib.getExe iris} init zsh)"
    '';
}
