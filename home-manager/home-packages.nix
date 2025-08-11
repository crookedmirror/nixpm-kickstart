{
  pkgs,
  inputs,
  config,
  ...
}:
{
  nixGL = {
    #https://github.com/nix-community/nixGL/issues/114#issuecomment-2741822320
    packages = import inputs.nixgl { inherit pkgs; };
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  home.packages = with pkgs; [
    fastfetch
    btop
    bat
    tree
    p7zip

    nix-tree
    nix-top_abandoned # chaotic
    nixfmt-tree

    ungoogled-chromium
    firefox_nightly # chaotic
    tor-browser-bundle-bin
  ];

  programs.neovim.enable = true;
  programs.direnv.enable = true;

  programs.kitty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.kitty;
    settings = {
      background_opacity = 0.8;
      font_family = "Hack Nerd Font";
      font_size = 13.0;
    };
  };
}
