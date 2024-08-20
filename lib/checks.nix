{
  inputs,
  system,
  custom-hooks ? {},
  run-bash-hooks ? true,
  run-generic-hooks ? true,
  run-git-hooks ? true,
  run-json-hooks ? true,
  run-markdown-hooks ? true,
  run-nix-hooks ? true,
  run-toml-hooks ? true,
  run-typescript-hooks ? true,
  run-unit-tests ? true,
  run-yaml-hooks ? true,
}: let
  nix-hooks =
    if run-nix-hooks
    then {
      alejandra.enable = true;
      deadnix.enable = true;
      flake-checker.enable = true;
    }
    else {};

  bash-hooks =
    if run-bash-hooks
    then {
      shellcheck.enable = true;
      beautysh.enable = true;
    }
    else {};

  markdown-hooks =
    if run-markdown-hooks
    then {
      markdownlint.enable = true;
    }
    else {};

  yaml-hooks =
    if run-yaml-hooks
    then {
      check-yaml.enable = true;
      yamllint.enable = true;
      # yamlfmt.enable = true;
    }
    else {};

  toml-hooks =
    if run-toml-hooks
    then {
      check-toml.enable = true;
      taplo.enable = true;
    }
    else {};

  json-hooks =
    if run-json-hooks
    then {
      check-json.enable = true;
      pretty-format-json.enable = true;
    }
    else {};

  git-hooks =
    if run-git-hooks
    then {
      check-merge-conflicts.enable = true;
      commitizen = {
        enable = true;
        stages = ["commit-msg"];
      };
    }
    else {};

  typescript-hooks =
    if run-typescript-hooks
    then {
      eslint.enable = true;
    }
    else {};

  generic-hooks =
    if run-generic-hooks
    then {
      check-added-large-files.enable = true;
      check-case-conflicts.enable = true;
      check-executables-have-shebangs.enable = true;
      check-shebang-scripts-are-executable.enable = true;
      check-symlinks.enable = true;
      detect-aws-credentials.enable = true;
      detect-private-keys.enable = true;
      end-of-file-fixer.enable = true;
      fix-byte-order-marker.enable = true;
      forbid-new-submodules.enable = true;
      trim-trailing-whitespace.enable = true;
    }
    else {};

  unit-tests =
    if run-unit-tests
    then {
      enable = true;
      name = "Unit tests";
      entry = "nix run nixpkgs#nix-unit -- --flake .#tests";
      pass_filenames = false;
      stages = ["pre-push"];
    }
    else {};

  all-hooks =
    nix-hooks
    // bash-hooks
    // custom-hooks
    // generic-hooks
    // git-hooks
    // json-hooks
    // markdown-hooks
    // toml-hooks
    // typescript-hooks
    // unit-tests
    // yaml-hooks;
in {
  pre-commit-check = inputs.git-hooks.lib.${system}.run {
    src = ./..;
    hooks = all-hooks;
  };
}
