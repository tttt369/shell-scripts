{
  description = "patch windows";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.wimlib
          pkgs.hivex
          pkgs.fuse3
          pkgs.p7zip
          pkgs.xorriso
        ];
      };
    };
}
