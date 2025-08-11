{ pkgs, config, ... }: {
	programs.mpv = {
		enable = true;
		package = config.lib.nixGL.wrap pkgs.mpv-vapoursynth; #chaotic
	};
}
