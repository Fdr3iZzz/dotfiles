{
  description = "A very basic flake";

  inputs = {
    # change to github:nixos/nixpkgs/nixos-23.05 for stable
    # change to github:nixos/nixpkgs/nixos-unstable for unstable
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # change to github:nix-community/home-manager/release-23.05 for stable
    # change to github:nix-community/home-manager for unstable
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {nixpkgs, ...}: let
    system = "x86_64-linux";
    user = "franz3";
  in {
    nixosConfigurations = let
      mkHost = host:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit (nixpkgs) lib;
            inherit inputs nixpkgs system user;
          };

          modules = [
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user} = {
                  imports = [
                    # common home-manager configuration
                    ./home.nix
                    # host specific home-manager configuration
                    ./hosts/${host}/home.nix
                  ];

                  home = {
                    username = user;
                    homeDirectory = "/home/${user}";
                    # do not change this value
                    stateVersion = "23.05";
                  };

                  # Let Home Manager install and manage itself.
                  programs.home-manager.enable = true;
                };
              };
            }
            # common configuration
            ./configuration.nix
            # host specific configuration
            ./hosts/${host}/configuration.nix
            # host specific hardware configuration
            ./hosts/${host}/hardware-configuration.nix
          ];
        };
    in {
      # update with `nix flake update`
      # rebuild with `nixos-rebuild switch --flake .#desktop`
      desktop = mkHost "desktop";
      # update with `nix flake update`
      # rebuild with `nixos-rebuild switch --flake .#homeserver`
      homeserver = mkHost "homeserver";
    };
    devShells.${system}.default = let
      pkgs = nixpkgs.legacyPackages.${system};
    in
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
