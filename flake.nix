{
  description = "A reusable Nix flake for adding tests (nix-unit) to a flake in a standardized way.";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };
  outputs = inputs @ {self, ...}: {
    checks = import ./lib/checks.nix;
  };
}
