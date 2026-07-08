{ config, pkgs, lib, ... }:

{
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  services.thermald.enable = true;

  hardware.nvidia.powerManagement.enable = true;

  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        energy_performance_preference = "power";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        energy_performance_preference = "performance";
        turbo = "auto";
      };
    };
  };

  powerManagement.powertop.enable = true;

  services.upower = {
    enable = true;
    percentageLow = 15;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "PowerOff";
  };

  services.udev.extraRules = let
    ac-refresh = pkgs.writeShellScript "ac-refresh" ''
      SESSION=$(${pkgs.systemd}/bin/loginctl list-sessions --no-legend \
        | ${pkgs.gawk}/bin/awk '/xmb03/{print $1;exit}')
      [ -z "$SESSION" ] && exit 0
      RATE=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/AC/online)
      DISPLAY=:0 XAUTHORITY=/home/xmb03/.Xauthority \
        ${pkgs.sudo}/bin/sudo -u xmb03 \
        ${pkgs.xrandr}/bin/xrandr --output eDP-1 --mode 1920x1200 --rate $([ "$RATE" = "1" ] && echo 165 || echo 60.09)
    '';
  in ''
    ACTION=="change", SUBSYSTEM=="power_supply", ATTR{type}=="Mains", RUN+="${ac-refresh}"
  '';
}
