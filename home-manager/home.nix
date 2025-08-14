{
  lib,
  pkgs,
  homeStateVersion,
  user,
  config,
  inputs,
  ...
}:
{
  imports = [
    ./modules
    ./home-packages.nix
  ];

  nixpkgs = {
    config.allowUnfree = true;
  };

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
    activation.make-fish-default-shell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PATH="/usr/bin:/bin:$PATH"
      FISH_PATH="${pkgs.fish}/bin/fish"
      if [[ $(getent passwd ${user}) != *"$FISH_PATH" ]]; then
        echo "setting fish as default shell (using chsh). password might be necessay."
        if ! grep -q $FISH_PATH /etc/shells; then
          echo "adding fish to /etc/shells"
          run echo "$FISH_PATH" | sudo tee -a /etc/shells
        fi
        echo "running chsh to make fish the default shell"
        run chsh -s $FISH_PATH ${user}
        echo "fish is now set as default shell !"
      fi
    '';
    sessionPath = [ "$HOME/.local/bin" ];
    packages = [ config.nix.package ];
  };

  nix = {
    enable = true;
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    settings = lib.mkMerge [
      {
        nix-path = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
      }
    ];
  };
  programs.home-manager.enable = true;
}
