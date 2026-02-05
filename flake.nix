
{

	description = "My Nix configurations";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";

		agenix = {
			url = "github:ryantm/agenix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, ...}@inputs: {
		nixosConfigurations.rnl-simaolavos = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				./configuration.nix
				inputs.agenix.nixosModules.default
				inputs.home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.simaolavos = import ./home.nix;
						backupFileExtension = "backup";
					};
				}
			];
		};
	};
}
