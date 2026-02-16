{ inputs, ... }:
{
  flake.homeModules.swayidle =

    { pkgs, lib, ... }:

    let
      noctaliaPkg = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      noctaliaBin = "${noctaliaPkg}/bin/noctalia-shell";
      niriBin = "${pkgs.niri}/bin/niri";

      noctalia = cmd: "${noctaliaBin} ipc call ${cmd}";
      niriMsg = cmd: "${niriBin} msg action ${cmd}";

      lock = noctalia "lockScreen lock";
      suspend = noctalia "sessionMenu lockAndSuspend";

      displayOff = niriMsg "power-off-monitors";
      displayOn = niriMsg "power-on-monitors";

      brightness = val: noctalia "brightness set ${val}";

      seq = cmds: lib.concatStringsSep " && " cmds;
    in
    {
      services.swayidle = {
        enable = true;
        package = pkgs.swayidle;

        events = {
          before-sleep = seq [
            displayOff
            lock
          ];
          after-resume = displayOn;

          lock = seq [
            displayOff
            lock
          ];
          unlock = displayOn;
        };

        timeouts = [
          {
            timeout = 150;
            command = brightness "10";
            resumeCommand = brightness "30";
          }

          {
            timeout = 300;
            command = lock;
          }

          {
            timeout = 330;
            command = displayOff;
            resumeCommand = seq [
              displayOn
              (brightness "30")
            ];
          }

          {
            timeout = 1800;
            command = suspend;
          }
        ];
      };
    };

}
