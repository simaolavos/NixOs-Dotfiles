{

  description = "My Nix configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

    outputs = { self, nixpkgs, ...}@inputs:
    let 
      baseModules = [
        inputs.agenix.nixosModules.default
      ];
    in {
      nixosConfigurations = {
        rnl-simaolavos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = baseModules ++ [./hosts/rnl-simaolavos.nix];
        };
      };
    };
  }
