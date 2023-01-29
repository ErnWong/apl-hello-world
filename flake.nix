{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    dyalog.url = "github:markus1189/dyalog-nixos";
    dyalog.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, dyalog }:
    flake-utils.lib.eachSystem [ "x86_64-darwin" "x86_64-linux" "i686-linux" ] (system:
      let
        #overlay = (import dyalog).overlay;
        compat = self: super: {
          electron_6 = super.electron;
          dbus_daemon = super.dbus;
          gdk_pixbuf = super.gdk-pixbuf;
        };
        overlay = (import (dyalog.outPath + "/overlay.nix"));
        pkgs = import nixpkgs { inherit system; overlays = [ compat overlay ]; };
      in
      {
        #defaultPackage = mypkg;

        #packages = { inherit mypkg runTests; };

        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.dyalog pkgs.ride ];
        };
      }
    );
}
