{

	description = "My system configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		
		nixgl.url = "github:nix-community/nixGL";
	};

	outputs = { nixpkgs, chaotic, home-manager, nixgl, ... }@inputs:
	let
		system = "x86_64-linux";
		homeStateVersion = "25.05";
		user = "jarvis";

	in {
		homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
			pkgs = nixpkgs.legacyPackages.${system};

			extraSpecialArgs = {
				inherit inputs homeStateVersion user;
			};
			modules = [ 
				./home-manager/home.nix 
				chaotic.homeManagerModules.default
			];
		};
	};

}
