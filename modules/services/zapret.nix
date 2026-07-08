{ config, pkgs, ... }: 

{
  services.zapret = {
    enable = true;
    configureFirewall = true;
    httpSupport = true; 
    udpSupport = false; 
    params = [
      "--dpi-desync=fake,multidisorder"
      "--dpi-desync-split-pos=1,midsld"
      "--dpi-desync-repeats=11"
      "--dpi-desync-fooling=badseq"
      "--dpi-desync-fake-tls=0x00000000"
      "--dpi-desync-fake-tls=!"
      "--dpi-desync-fake-tls-mod=rnd,dupsid,sni=www.google.com"
    ];

    whitelist = [
      # GitLab       
      "gitlab.com"
      "*.gitlab.com"
      "gitlab-static.net"
      "*.gitlab-static.net"
      "gitlab.io"
      "*.gitlab.io"
      "gl-cdn.com"
      "*.gl-cdn.com"
      "web-ide.gitlab-static.net"
      "*.cdn.web-ide.gitlab-static.net"

      # GitHub 
      "github.com"
      "*.github.com"
      "githubusercontent.com"
      "*.githubusercontent.com"
      "githubassets.com"
      "*.githubassets.com"
      "github.dev"
      "*.github.dev"
      "github.io"
      "*.github.io"
      "github.blog"
      "*.github.blog"

      # SoundCloud       
      "soundcloud.com"
      "*.soundcloud.com"
      "sndcdn.com"
      "*.sndcdn.com"
      "soundcloud-assets.com"
      "*.soundcloud-assets.com"
      "sndcdn.net" 
      "*.sndcdn.net"
    ];
  };
}
