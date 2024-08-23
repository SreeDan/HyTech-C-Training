{
    description = "my super special flake for neb's tutorials";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
        nixutils.url = "github:numtide/flake-utils";
        easy_cmake.url = "github:RCMast3r/easy_cmake";
    };
    outputs = {
        self, nixpkgs, nixutils, easy_cmake
    }:
    let
      hello_lib_overlay = final: prev: {
        hello_lib = final.callPackage ./default.nix { };
      };
      my_overlays = [ hello_lib_overlay ];
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ self.overlays.default ];
      };
    in 
    {
     overlays.default = nixpkgs.lib.composeManyExtensions my_overlays;

      packages.x86_64-linux =
        rec {
          hello_lib = pkgs.hello_lib;
          default = hello_lib;
        };

      devShells.x86_64-linux.default =
        pkgs.mkShell rec {
          # Update the name to something that suites your project.
          name = "nix-devshell";
          packages = with pkgs; [
            # Development Tools
            cmake
            hello_lib
          ];

          # Setting up the environment variables you need during
          # development.
          shellHook =
            let
              icon = "f121";
            in
            ''
              export PS1="$(echo -e '\u${icon}') {\[$(tput sgr0)\]\[\033[38;5;228m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]} (${name}) \\$ \[$(tput sgr0)\]"
            '';
        }; 
    };
    # let
    #   derivations = import ./default.nix;
    # in 
    #   overlays = [
    #     (final: prev: {
    #       hello_package = derivations.myDerivation1;
    #     })
    #   ];

  #   let
  #     hello_lib_overlay = final: prev: {
  #       hello_lib = final.callPackage ./default.nix { };
  #     };
  #   # The set of systems to provide outputs for
  #   allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

  #   # A function that provides a system-specific Nixpkgs for the desired systems
  #   forAllSystems = f: nixpkgs.lib.genAkttrs allSystems (system: f {
  #     pkgs = import nixpkgs { inherit system; };
  #   });
  # in {
  #   packages = forAllSystems ({ pkgs }: {
  #     default = {
  #       # Package definition
  #       hello_nix_package
  #     };
  #   });
  # };
}