{ pkgs, homeStateVersion, user, ... }: {
	home = {
		username = user;
		homeDirectory = "/home/${user}";
		stateVersion = homeStateVersion;
	};
	nix.package = pkgs.nix;

	imports = [
		./modules
		./home-packages.nix
	];
}
