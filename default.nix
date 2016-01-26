{ system ? builtins.currentSystem, typhonPackage ? ~/typhon/default.nix }:
let
  nixpkgs = import <nixpkgs> { inherit system; };
  stdenv = nixpkgs.stdenv;
  lib = nixpkgs.lib;
  typhon = nixpkgs.callPackage typhonPackage {};
  typhonVm = typhon.typhonVm;
  mast = typhon.mast;
  json = typhon.montePackage rec {
    name = "json";
    version = "0.0.0.0";
    buildPhase = ''
      ${typhonVm}/mt-typhon -l ${mast}/mast ${mast}/mast/montec -mix -format mast $src/json.mt json.mast
      '';
    installPhase = ''
      mkdir -p $out/mast
      cp json.mast $out/mast/
      '';
    # Cargo-culted.
    src = builtins.filterSource (path: type: lib.hasSuffix ".mt" path) ./.;
  };
  mtpkg = with nixpkgs; { monte-json = json; };
in
  mtpkg
