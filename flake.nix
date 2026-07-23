{
  description = "Shared Haskell environment with custom Streamly versions";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/d407951447dcd00442e97087bf374aad70c04cea";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        customHaskellPackages = pkgs.haskellPackages.override {
          overrides = hself: hsuper: {
            streamly-core = hself.callCabal2nix "streamly-core" (builtins.fetchTarball {
              url = "https://hackage.haskell.org/package/streamly-core-0.3.1/streamly-core-0.3.1.tar.gz";
              sha256 = "1bk9m7h0kar6nipq36kxdhxh9g48v5828qcygxpcjdh6pqipxn4k";
            }) {};
            streamly-process = hself.callHackage "streamly-process" "0.4.1" {};
            streamly = hself.callCabal2nix "streamly" (builtins.fetchTarball {
              url = "https://hackage.haskell.org/package/streamly-0.11.1/streamly-0.11.1.tar.gz";
              sha256 = "1dxyhq8m9fr3ghpmxkh6bc37fd4f1048xckjrlpp6ybvlg0lq7g2";
            }) {};
          };
        };
      in
      {
        packages.default = customHaskellPackages.ghcWithPackages (p: [
          p.streamly-core
          p.streamly-process
        ]);
      }
    );
}
