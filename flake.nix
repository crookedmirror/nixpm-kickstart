{

	description = "My system configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs, home-manager, ... }@inputs:
		let
			system = "x86_64-linux";
			homeStateVersion = "24.11";
			user = "crooked";
			
		in {
		homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
			pkgs = nixpkgs.legacyPackages.${system};
			extraSpecialArgs = {
				inherit inputs homeStateVersion user;
			};
			modules = [ 
				./home-manager/home.nix 
			];
		};
	};

}
