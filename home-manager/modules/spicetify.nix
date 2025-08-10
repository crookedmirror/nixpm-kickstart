{
    lib,
    pkgs,
    inputs,
    ...
}: {
    programs = with lib.mkDefault; {
        spicetify.enable = true;
        spicetify.enabledExtensions = with inputs.spicetify.legacyPackages.${pkgs.system}.extensions; [
            adblock
            hidePodcasts
            shuffle
        ];
        spicetify.theme = lib.mkForce inputs.spicetify.legacyPackages.${pkgs.system}.themes.text;
    };
}
