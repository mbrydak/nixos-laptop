{
  description = "Flaked NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stylix = {
      url = "github:danth/stylix/release-24.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
    };
    nixvim-config.url = "github:mbrydak/nixvim-config";
  };

  outputs =
    {
      self,
      nixpkgs,
      stylix,
      home-manager,
      nixvim-config,
      ...
    }@inputs:
    {

      nixosConfigurations = {
        t480 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/t480/configuration.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              # home-manager.useUserPackages = true;
              home-manager.users.max = import ./home.nix;
            }
          ];
        };
        hp840 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          system = "x86_64-linux";
          modules = [
            ./hosts/hp840/configuration.nix
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.max = import ./home.nix;
            }

          ];
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
