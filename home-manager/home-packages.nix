{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  nixGL = {
    #https://github.com/nix-community/nixGL/issues/114#issuecomment-2741822320
    packages = import inputs.nixgl { inherit pkgs; };
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  home.packages = with pkgs; [
    #cli
    btop
    bat
    tree
    p7zip

    nix-tree
    nix-top_abandoned # chaotic
    nixfmt-tree

    #ui
    ayugram-desktop
    gimp3

    ungoogled-chromium
    tor-browser-bundle-bin
  ];

  programs.neovim.enable = true;
  programs.direnv.enable = true;

  #TODO: on ubuntu -> not set automatically, had to execute:

  programs.alacritty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.alacritty_git; # chaotic
    settings = {
      window.opacity = lib.mkForce 0.8;
      font.normal.family = "Hack Nerd Font";
      font.size = 13.0;
      keyboard.bindings = lib.trivial.importJSON "${inputs.self}/assets/alacritty-key-bindings.json";
      terminal.shell = {
        program = "${pkgs.tmux}/bin/tmux";
        args = [
          "new-session"
          "-A"
          "-s"
          "regular"
        ];
      };
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
  };

  home.file = {
    ".tmux.conf".text = ''
      set-option -g default-shell ${pkgs.fish}/bin/fish
      set-option -ga terminal-overrides ",*256col*:Tc,alacritty:Tc"
      set -g mouse off
    '';
  };
}
