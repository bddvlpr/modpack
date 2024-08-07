{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = {
        pkgs,
        lib,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [packwiz];
        };

        apps.serve = let
          serveScript = pkgs.writeScriptBin "serve" ''
            ${lib.getExe pkgs.packwiz} serve
          '';
        in {
          type = "app";
          program = serveScript;
        };
      };
    };
}
