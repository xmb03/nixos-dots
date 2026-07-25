{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    daemon.settings = {
      registry-mirrors = [
        "https://dh-mirror.gitverse.ru"
        "https://dockerhub.timeweb.cloud"
        "https://mirror.gcr.io"
      ];
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
    };
  };

  users.users.xmb03.extraGroups = [ "docker" ];
}
