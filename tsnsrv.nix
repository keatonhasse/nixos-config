{ config, inputs, ... }:

{
  imports = [ inputs.tsnsrv.nixosModules.default ];

  age.secrets.tsnsrv.file = ./secrets/tsnsrv.age;

  services.tsnsrv = {
    enable = true;
    defaults = {
      authKeyPath = config.age.secrets.tsnsrv.path;
      urlParts.host = "100.88.174.24";
    };
    services = {
      plex.urlParts.port = 32400;
      jellyfin = {
        urlParts.port = 8096;
        funnel = true;
      };
      transmission.urlParts.port = 9091;
      #sbnzbd.urlParts.port = 8080;
      #bazarr.urlParts.port = 6767;
      lidarr.urlParts.port = 8686;
      prowlarr.urlParts.port = 9696;
      radarr.urlParts.port = 7878;
      readarr.urlParts.port = 8787;
      sonarr.urlParts.port = 8989;
      jellyseerr = {
        urlParts.port = 5055;
        funnel = true;
      };
      paperless.urlParts.port = 28981;
    };
  };
}
