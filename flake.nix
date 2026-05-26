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
        concourseFly = let
          artifacts = {
            x86_64-linux = {
              arch = "amd64";
              platform = "linux";
              hash = "sha256-Oc6KJcmaFF1+UVXXP32w/HTUHj8blHnqR81tNdb3ppk=";
            };
            aarch64-linux = {
              arch = "arm64";
              platform = "linux";
              hash = "sha256-wIpb9o6YVsV8Rt8EalNCFJHUHB6h9yc7uYU+dTJfEf8=";
            };
            x86_64-darwin = {
              arch = "amd64";
              platform = "darwin";
              hash = "sha256-K8XrRI8HKunujq4OI201iSfdTwGm/MScGaGB8Ytf0+g=";
            };
            aarch64-darwin = {
              arch = "arm64";
              platform = "darwin";
              hash = "sha256-yJwC+ENHt28hmznAsW2/hwDdpZYyQSkTQwNxKg6RbK4=";
            };
          };
          artifact = artifacts.${system} or (throw "Unsupported fly platform: ${system}");
        in
          pkgs.stdenvNoCC.mkDerivation {
            pname = "fly";
            version = "8.1.1";

            src = pkgs.fetchurl {
              url = "https://ci.galoy.io/api/v1/cli?arch=${artifact.arch}&platform=${artifact.platform}";
              hash = artifact.hash;
            };

            dontUnpack = true;

            installPhase = ''
              install -D -m755 "$src" "$out/bin/fly"
            '';
          };
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
              concourseFly
            ];
          };
          formatter = alejandra;
        }
    );
}
