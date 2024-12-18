{
  description = "Flaked NixOS Config";

  inputs = {
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stylix = {
      url = "github:danth/stylix";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
    };
    nixvim-config.url = "github:mbrydak/nixvim-config";
    #    musnix = {
    #      url = "github:musnix/musnix";
    #    };
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
              home-manager.extraSpecialArgs = {inherit inputs; };
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
            #inputs.musnix.nixosModules.musnix
            {
              home-manager.useGlobalPkgs = true;
              home-manager.extraSpecialArgs = {inherit inputs; };
              home-manager.useUserPackages = true;
              home-manager.users.max = import ./home.nix;
            }

          ];
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
