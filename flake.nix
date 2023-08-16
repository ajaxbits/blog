{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    alejandra,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: let
        lib = pkgs.lib;
        stagingUrl = "http://127.0.0.1:8080";

        blogBuilder = {rootUrl ? false, drafts ? false}:
          pkgs.stdenv.mkDerivation {
            pname = "ajaxbits";
            version =
              if (builtins.isString rootUrl)
              then "test"
              else "0.0.0";
            src = ./.;
            nativeBuildInputs = [
              pkgs.zola
              pkgs.nodePackages.npm
              pkgs.nodePackages.uglify-js
              pkgs.openssl
            ];
            buildPhase = ''
              set -euo pipefail
              export HOME=$(pwd)

              zola build \
                ${(lib.optionalString (builtins.isString rootUrl) "--base-url=${rootUrl}")} \
                ${(lib.optionalString drafts "--drafts")} 

              npm run abridge

              zola build \
                ${(lib.optionalString (builtins.isString rootUrl) "--base-url=${rootUrl}")} \
                ${(lib.optionalString drafts "--drafts")} 
            '';
            installPhase = "cp -r public $out";

            meta = with lib; {
              description = "My website";
              homepage = "https://blog.ajaxbits.com";
              changelog = "https://github.com/ajaxbits/blog/commits/main";
              licence = licences.agpl3Only;
              maintainers = [
                {
                  name = "Alex Jackson";
                  email = "contact@ajaxbits.com";
                  github = "ajaxbits";
                  githubId = 45179933;
                  keys = [
                    {fingerprint = "ED00BE54AAF8A59F4E409560798DF4ACC8A798B3";}
                  ];
                }
              ];
            };
          };
      in {
        packages.default = config.packages.prod;
        apps.default = config.apps.prod-preview;

        packages.prod = blogBuilder {};

        packages.prod-preview = blogBuilder {rootUrl = stagingUrl;};

        packages.staging = blogBuilder {rootUrl = stagingUrl; drafts = true;};

        apps.prod = {
          type = "app";
          program = pkgs.writeShellScriptBin "server" ''
            ${pkgs.python3Minimal}/bin/python3 -m http.server 8080 \
              --directory ${config.packages.prod}
          '';
        };

        apps.prod-preview = {
          type = "app";
          program = pkgs.writeShellScriptBin "server" ''
            ${pkgs.python3Minimal}/bin/python3 -m http.server 8080 \
              --directory ${config.packages.prod-preview}
          '';
        };

        apps.staging = {
          type = "app";
          program = pkgs.writeShellScriptBin "server" ''
            ${pkgs.python3Minimal}/bin/python3 -m http.server 8080 \
              --directory ${config.packages.staging}
          '';
        };

        devShells.default = pkgs.mkShell {
          packages =
            config.packages.prod.nativeBuildInputs
            ++ [
              alejandra.defaultPackage.${system}
            ];
        };
      };
    };
}
