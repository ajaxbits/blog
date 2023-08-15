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
        stagingUrl = "https://staging--ajaxbits-blog.netlify.app";

        blog = pkgs.stdenv.mkDerivation {
          pname = "ajaxbits";
          version = "0.0.0";
          src = ./.;
          nativeBuildInputs = [pkgs.zola];
          buildPhase = ''
            zola build
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
        packages.default = blog;
        packages.staging = config.packages.default.overrideAttrs (old: {
          version = "staging";
          buildPhase = ''
            zola build --base-url="${stagingUrl}"
          '';
        });
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            zola
            alejandra.defaultPackage.${system}
            nodejs
            nodePackages.uglify-js
          ];
        };
      };
    };
}
