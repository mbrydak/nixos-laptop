{
  description = "Flaked NixOS Config";

  outputs = { self, nixpkgs }: {

    nixosConfigurations.t480 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };

  };
}
