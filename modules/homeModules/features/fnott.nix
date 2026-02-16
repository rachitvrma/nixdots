{
  flake.homeModules.fnott =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      services.fnott = {
        enable = true;
        settings = lib.mkAfter {
          main = {
            play-sound = "pw-play --volume 0.6 \${filename}";
            sound-file = "${pkgs.kdePackages.ocean-sound-theme}/share/sounds/ocean/stereo/message-attention.oga";
            icon-theme = config.stylix.icons.light;

            border-radius = 50;
            scaling-filter = "lanczos3";
            layer = "top";
            default-timeout = 3;
          };

          critical = {
            sound-file = "${pkgs.kdePackages.ocean-sound-theme}/share/sounds/ocean/stereo/dialog-error-serious.oga";
            layer = "overlay";
            idle-timeout = 5;
          };
        };

        extraFlags = [
          "-s" # Disable logging to syslog
        ];
      };
    };
}
