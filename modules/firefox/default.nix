# Reworked from
# https://codeberg.org/celenity/Phoenix/src/branch/pages/flake.nix
{ inputs, config, pkgs, lib, ... }:
{
	options.programs.firefox.phoenix = {
              enable =
                lib.mkEnableOption "Enable privacy & security hardening of Firefox using the Phoenix configs"
                // {
                  default = false; # TODO: [enchancement] change to true?
                };
              firefoxPackages = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ "firefox" ];
                description = "The name of Firefox packages of current pkgs to patch with phoenix config and policy.";
              };
	};
	packages."x86_64-linux" = rec {};
	config =
	let
		cfg = config.programs.firefox.phoenix;
        in
	lib.mkIf cfg.enable {
		assertions = [
			{
				assertion = !pkgs.stdenv.isDarwin;
				message = "Phoenix module has not been ported to nix-darwin yet. Contributions welcomed.";
			}
		];
		home.file."/etc/firefox/defaults/pref/phoenix-desktop.js".source = "${inputs.phoenix}/pref/phoenix-desktop.js";

	};
}
