{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = ''
      set-option -ga terminal-overrides ",*256col*:Tc,alacritty:Tc"
      set -g mouse off
    '';
  };
}
