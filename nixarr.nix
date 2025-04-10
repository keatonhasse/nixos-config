{ config, pkgs, inputs, ... }:
let
  domain = "tailc0593.ts.net";
in
{
  imports = [ inputs.nixarr.nixosModules.default ];

  age.secrets.airvpn.file = ./secrets/airvpn.age;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-sdk
      intel-compute-runtime
      intel-media-driver
    ];
  };

  #systemd = {
  #  timers."restart-torrenter" = {
  #    wantedBy = [ "timers.target" ];
  #    timerConfig = {
  #      OnCalendar = "daily";
  #      Unit = "restart-torrenter.service";
  #    };
  #  };

  #  services."restart-torrenter" = {
  #    script = ''
  #      systemctl restart wg.service
  #      systemctl restart transmission.service
  #    '';
  #    serviceConfig = {
  #      Type = "oneshot";
  #      User = "root";
  #    };
  #  };
  #};

  nixarr = {
    enable = true;

    mediaUsers = [ "keaton" ];

    vpn = {
      enable = true;
      wgConf = config.age.secrets.airvpn.path;
    };

    plex.enable = false;
    jellyfin.enable = true;
    jellyseerr.enable = true;

    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 26789;
      extraSettings = {
        rpc-host-whitelist = "transmission.${domain}";
        #alt-speed-time-enabled = true;
        #alt-speed-time-begin = 0;
        #alt-speed-time-end = 420;
        idle-seeding-limit-enabled = true;
        ratio-limit-enabled = true;
      };
      #privateTrackers.cross-seed.enable = true;
    };

    sabnzbd = {
      enable = false;
      whitelistHostnames = [ "sabnzbd.${domain}" ];
    };

    bazarr.enable = false;
    lidarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sonarr.enable = true;

    recyclarr = {
      enable = false;
    };
  };

  virtualisation.oci-containers.containers = {
    watchstate = {
      autoStart = true;
      image = "ghcr.io/arabcoders/watchstate:latest";
      ports = [ "8080:8080" ];
      user = "1000:1000";
      volumes = [ "/data/.state/watchstate:/config:rw" ];
      extraOptions = [ "--network=host" ];
    };
    #recyclarr = {
    #  autoStart = true;
    #  environment = {
    #    TZ = "America/Chicago";
    #  };
    #  image = "ghcr.io/recyclarr/recyclarr:latest";
    #  volumes = [ "/data/.state/nixarr/recyclarr:/config" ];
    #  extraOptions = [ "--network=host" ];
    #};

    flaresolverr = {
      autoStart = true;
      environment = {
        TZ = "America/Chicago";
      };
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      ports = [ "127.0.0.1:8191:8191" ];
    };
  };
}
