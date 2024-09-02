{
  description = "Flaked NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs =
    {
      self,
      nixpkgs,
      stylix,
      home-manager,
      nixvim,
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
            nixvim.homeManagerModules.nixvim
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
            nixvim.homeManagerModules.nixvim
            {
              home-manager.useGlobalPkgs = true;
              # home-manager.useUserPackages = true;
              home-manager.users.max = import ./home.nix;
            }
          ];
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
