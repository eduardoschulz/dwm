{
  description = "srsRAN Project with googletest as a dependency";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # or a specific commit
    flake-utils.url = "github:numtide/flake-utils"; # for utility functions
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };

    # Define googletest as a separate derivation
    # Define the main project derivation
    main = pkgs.stdenv.mkDerivation rec {
      pname = "dwm";
      version = "6.5"; #change this depending on which version you are building

      src = [ ./. ];

      buildInputs = [
        pkgs.xorg.libX11
        pkgs.xorg.libXinerama
        pkgs.xorg.libXft
      ];


      prePatch = ''
      sed -i "s@/usr/local@$out@" config.mk
      '';
    

    makeFlags = [ "CC=${pkgs.stdenv.cc.targetPrefix}cc" ];


    };
  in {
    packages.default = main;
    defaultPackage = main;
  });
}

