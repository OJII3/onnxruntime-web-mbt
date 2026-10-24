{
  description = "Development environment for onnxruntime-web-mbt";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    moonbit-overlay.url = "github:moonbit-community/moonbit-overlay";
  };

  outputs = inputs@{ flake-parts, nixpkgs, moonbit-overlay, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem = { system, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ moonbit-overlay.overlays.default ];
          };
        in {
          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.nodejs
              pkgs.moonbit-bin.latest
            ];
          };
        };
    };
}
