{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    dyalog.url = "github:markus1189/dyalog-nixos";
    dyalog.flake = false;

    co-dfns.url = "https://github.com/Co-dfns/Co-dfns/archive/refs/tags/v4.1.2.tar.gz";
    co-dfns.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, dyalog, co-dfns }:
    flake-utils.lib.eachSystem [ "x86_64-darwin" "x86_64-linux" "i686-linux" ] (system:
      let
        compat = self: super: {
          electron_6 = super.electron;
          dbus_daemon = super.dbus;
          gdk_pixbuf = super.gdk-pixbuf;
        };
        dyalog-overlay = import "${dyalog}/overlay.nix";
        upgrade-dyalog = self: super: {
          dyalog = super.dyalog.overrideAttrs (finalAttrs: previousAttrs: rec {
            version = "18.2.45405";
            shortVersion = super.lib.concatStringsSep "." (super.lib.take 2 (super.lib.splitString "." version));
            src = super.fetchurl {
              url = "https://www.dyalog.com/uploads/php/download.dyalog.com/download.php?file=${shortVersion}/linux_64_${version}_unicode.x86_64.deb";
              sha256 = "sha256-pA/WGTA6YvwG4MgqbiPBLKSKPtLGQM7BzK6Bmyz5pmM=";
            };
            installPhase = ''
              mkdir -p $out/ $out/bin
              mv opt/mdyalog/${shortVersion}/64/unicode/* $out/
              sed -i"" "s|/opt/mdyalog/${shortVersion}/64/unicode|$out|" "$out/scriptbin/dyalogscript"
              # Fix for 'lib/cxdya63u64u.so' which for some reason needs .1 instead of packaged .2
              ln -s $out/lib/libodbcinst.so.2 $out/lib/libodbcinst.so.1
              ln -s $out/lib/libodbc.so.2 $out/lib/libodbc.so.1
            '';
          });
        };
        arrayfire-debug-symbols = self: super: {
          arrayfire = super.enableDebugging (super.arrayfire.overrideAttrs (finalAttrs: previousAttrs: {
            dontStrip = true;
          }));
        };
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            compat
            dyalog-overlay
            upgrade-dyalog
            arrayfire-debug-symbols
          ];
        };
        co-dfns-user-command = builtins.filterSource
          (path: type: path == "${co-dfns}/codfns.dyalog")
          co-dfns;
        mypkg = pkgs.writeShellScriptBin "ugglui" ''
          export AF_PATH="${pkgs.arrayfire}"
          export LD_LIBRARY_PATH="$(pwd):$LD_LIBRARY_PATH"
          export LD_LIBRARY_PATH="${pkgs.forge}/lib:$LD_LIBRARY_PATH"

          ${pkgs.dyalog}/scriptbin/dyalogscript codfns-path=${co-dfns-user-command} ${./.}/src/main.apl
          # Swap above with the following to use a locally installed co-dfns,
          # where tmpcdfns is a directory containing the codfns.dyalog file
          # and nothing else.
          #${pkgs.dyalog}/scriptbin/dyalogscript codfns-path=$(pwd)/tmpcdfns ${./.}/src/main.apl
        '';
      in
      {
        defaultPackage = mypkg;

        packages = { inherit mypkg; };

        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.dyalog
            pkgs.ride
            pkgs.arrayfire
            pkgs.forge # Needed by arrayfire when using Window()?
          ];
        };
      }
    );
}
