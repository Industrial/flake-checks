# flake-checks

A reusable Nix flake for adding tests (`nix-unit`) to a flake in a standardized way.

## Usage

```nix
{
  description = "A reusable Nix flake for adding tests (nix-unit) to a flake in a standardized way.";
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
      flake-checks.checks {inherit inputs system pkgs;});
  };
}