{ inputs, ... }:
{
  flake.homeModules.noctalia =
    { pkgs, ... }:
    let
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/rachitve6h2g/Wallpapers/main/Shinchan.png";
        hash = "sha256-CP9uGyslZ19wCaglMb1UG+NmcU/GxN5HDXSdrO5jAlw=";
      };
    in
    {
      imports = [ inputs.noctalia.homeModules.default ];
      home.file.".face".source = image;
      home.packages = [
        # Use it to just see the diff and move the differences here.
        (pkgs.writeShellScriptBin "noctalia-diff" ''
          nix shell nixpkgs#jq nixpkgs#colordiff \
          -c bash -c "colordiff -u --nobanner \
          <(jq -S . ~/.config/noctalia/settings.json) \
          <(noctalia-shell ipc call state all | jq -S .settings)"
        '')
      ];

      programs.noctalia-shell = {
        enable = true;
        systemd.enable = true;
        settings = {
          # configure noctalia here
          bar = {
            density = "compact";
            position = "right";
            showCapsule = false;
            widgets = {
              left = [
                {
                  id = "ControlCenter";
                  useDistroLogo = true;
                }

                {
                  id = "Network";
                }

                {
                  id = "Bluetooth";
                }
              ];

              center = [
                {
                  hideUnoccupied = false;
                  id = "Workspace";
                  labelMode = "none";
                }
              ];

              right = [
                {
                  alwaysShowPercentage = true;
                  id = "Battery";
                  warningThreshold = 40;
                }

                {
                  formatHorizontal = "HH:mm";
                  formatVertical = "HH mm";
                  id = "Clock";
                  useMonospacedFont = true;
                  usePrimaryColor = true;
                }
              ];
            };

            general = {
              avatarImage = "/home/krish/.face";
              radiusRatio = 0.2;
            };
          };
        };
      };

    };
}
