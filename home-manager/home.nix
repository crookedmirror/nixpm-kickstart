{
  lib,
  pkgs,
  homeStateVersion,
  user,
  ...
}:
{
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
    activation.make-fish-default-shell = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              PATH="/usr/bin:/bin:$PATH"
              #FISH_PATH="/home/${user}/.nix-profile/bin/fish"
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
  };
  nix.package = pkgs.nix;

  imports = [
    ./modules
    ./home-packages.nix
  ];
}
