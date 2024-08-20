# flake-checks

A reusable Nix flake for adding checks to a flake in a standardized way. It
defined one pre-commit check that I use in all my flakes.

## Usage

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    for-all-systems.url = "github:Industrial/for-all-systems";
    for-all-systems.inputs.nixpkgs.follows = "nixpkgs";
    flake-checks.url = "github:Industrial/flake-checks";
    flake-checks.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs @ {self, for-all-systems, flake-checks, ...}: let
    forAllSystems = for-all-systems.forAllSystems {inherit nixpkgs;};
  in {
    checks = forAllSystems ({
      system,
      pkgs,
    }:
      flake-checks.checks {inherit inputs system;});
  };
}
```

## Options

| Name                 | Default | Description                              |
| -------------------- | ------- | ---------------------------------------- |
| run-nix-hooks        | true    | Wether to run the nix hooks.             |
| run-bash-hooks       | true    | Wether to run the bash hooks.            |
| run-markdown-hooks   | true    | Wether to run the markdown hooks.        |
| run-yaml-hooks       | true    | Wether to run the yaml hooks.            |
| run-toml-hooks       | true    | Wether to run the toml hooks.            |
| run-json-hooks       | true    | Wether to run the json hooks.            |
| run-git-hooks        | true    | Wether to run the git hooks.             |
| run-typescript-hooks | true    | Wether to run the typescript hooks.      |
| run-generic-hooks    | true    | Wether to run the generic hooks.         |
| run-unit-tests       | true    | Wether to run the unit tests (nix-unit). |
| custom-hooks         | {}      | Add your own hooks.                      |
