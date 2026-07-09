{ config, pkgs, ... }:

{
  services.qbittorrent = {
    enable = true;
    openFirewall = true;
    webuiPort = 8080;

    extraArgs = [ "--confirm-legal-notice" ];

    serverConfig = {
      LegalNotice.Accepted = true;

      Preferences.WebUI.Username = "xmb03";
      Preferences.WebUI.Password_PBKDF2 = "eG1iMDNfc2FsdF8xNmIh:BJ/a2jW8LE0njGJyxqTTv6ER+7/KGFMWwswpyt74lbl5yDkIqPPtC8iHUVEkOQhOJI5WrUDd1Lzav0baJeJy4w";

      Preferences.Downloads.SavePath = "/mnt/win/win-d/Games";

      BitTorrent.Session = {
        DiskCache.Size = 64;
        DiskCache.TTL = 15;
        AsyncIOThreads = 4;
        CoalesceReadWrite = true;
        SendBufferLowWatermark = 2;
        SendBufferWatermark = 8;
        SendBufferWatermarkFactor = 50;
        QueueingSystemEnabled = false;
        MaxConnections = 200;
        MaxConnectionsPerTorrent = 40;
        GlobalMaxUploads = 30;
        SendToSocketBufferSizeMethod = 0;
        ReceiveFromSocketBufferSizeMethod = 0;
        DHT = true;
        LSD = false;
        Encryption = 1;
        AnonymousMode = true;
      };
    };
  };
}
