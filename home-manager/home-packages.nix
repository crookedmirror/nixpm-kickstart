{ pkgs, inputs, overlays, lib, ... }: 
let
	  nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl-wrapper" { } ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    for bin in ${pkg}/bin/*; do
     wrapped_bin=$out/bin/$(basename $bin)
     echo "exec ${lib.getExe pkgs.nixgl.nixGLIntel} $bin \"\$@\"" > $wrapped_bin
     chmod +x $wrapped_bin
    done
  '';
in
{
	nixpkgs = {
		inherit overlays;
		config.allowUnfree = true;
	};

	home.packages = with pkgs; [ 
		fastfetch
                btop
		bat
		tree
		p7zip
		pkgs.nixgl.nixGLIntel

		thunderbird-latest-unwrapped

		ungoogled-chromium
		firefox_nightly #chaotic
		tor-browser-bundle-bin
		
	];

        programs.neovim.enable = true;
        programs.direnv.enable = true;
	programs.kitty = {
		enable = true;
		package = nixGLWrap pkgs.kitty;
		settings = {
			background_opacity = 0.5;
			font_family = "Hack Nerd Font";
			font_size = 13.0;
		};
	};

	#programs.firefox.phoenix = {
	#	enable = true;
	#	firefoxPackages = pkgs.firefox_nightly;
	#};

}
