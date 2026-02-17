{
  flake.nixosModules.sddm =
    { pkgs, ... }:
    let
      sddmTheme = (
        pkgs.sddm-astronaut.override {
          embeddedTheme = "post-apocalyptic_hacker";
        }
      );
    in
    {
      services.displayManager.sddm = {
        enable = true;

        # Enables experimental Wayland support
        wayland.enable = true;
        theme = "sddm-astronaut-theme";

        # See https://wiki.nixos.org/wiki/SDDM_Themes
        # It needs to be here...
        extraPackages = [ sddmTheme ];
      };

      # ... as well as here
      environment.systemPackages = [ sddmTheme ];
    };
}
