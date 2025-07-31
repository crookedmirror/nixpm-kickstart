{

	programs.bash = {
		enable = true;
		shellAliases = 
		let
			flakePath = "~/nix-config";
		in {
			rebuild = "sudo nixos-rebuild switch --flake ${flakePath}";
			hms = "nix run nixpkgs#home-manager -- switch --flake ${flakePath}";
		};

	};
}
