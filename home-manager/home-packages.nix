{ pkgs, ... }: {
	nixpkgs.config.allowUnfree = true;

	home.packages = with pkgs; [ 
		fastfetch
                btop
		tor-browser-bundle-bin
	];

        programs.neovim.enable = true;
        programs.direnv.enable = true;

}
