{ system ? builtins.currentSystem, typhonPackage ? ~/typhon/default.nix }:
let
  nixpkgs = import <nixpkgs> { inherit system; };
  stdenv = nixpkgs.stdenv;
  lib = nixpkgs.lib;
  typhon = nixpkgs.callPackage typhonPackage {};
  typhonVm = typhon.typhonVm;
  mast = typhon.mast;
  json = stdenv.mkDerivation rec {
    name = "monte-json";
    buildInputs = [ typhonVm mast ];
    buildPhase = ''
      ${typhonVm}/mt-typhon -l ${mast}/mast ${mast}/mast/montec -mix -format mast $src/json.mt json.mast
      '';
    installPhase = ''
      mkdir -p $out/mast
      cp json.mast $out/mast/
      '';
    doCheck = false;
    # Cargo-culted.
    src = builtins.filterSource (path: type: lib.hasSuffix ".mt" path) ./.;
  };
  jobs = with nixpkgs; { monte-json = json; };
in
  jobs
