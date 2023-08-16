{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
    in {
      devShells.${system}.default =
        pkgs.mkShell
          {
            buildInputs = [
              pkgs.neovim
              pkgs.vim
            ];

            shellHook = ''
              echo "hello world"
              '';
          };
    };
}

