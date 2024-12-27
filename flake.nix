{
  description = "Utils";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in
        with pkgs; {
          packages = rec {
            gh-token = pkgs.buildGoModule rec {
              pname = "gh-token";
              version = "v2.0.1";

              src = pkgs.fetchFromGitHub {
                owner = "Link-";
                repo = "gh-token";
                rev = version;
                sha256 = "sha256-GoPdnZowkXowaJ1yBjxPqUz+S7FDeqovChwNZzOHosM=";
              };

              vendorHash = "sha256-QiaGdHpDeuiX6QDLX2G4rx73QasWwQ3q8BYbv/Tws8c=";
            };
          };

          devShells.default = mkShell {
            nativeBuildInputs = [
              ytt
              alejandra
            ];
          };
          formatter = alejandra;
        }
    );
}
