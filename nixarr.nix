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

  nixarr = {
    enable = true;

    mediaUsers = [ "keaton" ];

    vpn = {
      enable = true;
      wgConf = config.age.secrets.airvpn.path;
    };

    plex.enable = true;
    tautulli.enable = true;
    jellyfin.enable = true;
    jellyseerr.enable = true;

    autobrr.enable = false;
    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 26789;
      extraSettings = {
        rpc-host-whitelist = "transmission.${domain}";
        idle-seeding-limit-enabled = true;
        ratio-limit-enabled = true;
      };
    };

    sabnzbd = {
      enable = true;
      whitelistHostnames = [ "sabnzbd.${domain}" ];
    };

    bazarr.enable = false;
    lidarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sonarr.enable = true;

    recyclarr = {
      enable = true;
      configuration = {
        radarr = {
          sqp-1-web-1080p = {
            base_url = "http://localhost:7878";
            api_key = "!env_var RADARR_API_KEY";
            delete_old_custom_formats = true;
            replace_existing_custom_formats = true;
            include = [
              {
                template = "radarr-quality-definition-sqp-streaming";
              }
              {
                template = "radarr-quality-profile-sqp-1-web-1080p";
              }
              {
                template = "radarr-custom-formats-sqp-1-web-1080p";
              }
            ];
            quality_profiles = [
              {
                name = "SQP-1 WEB (1080p)";
                min_format_score = 10;
              }
            ];
          };
        };
        sonarr = {
          sonarr_merged = {
            base_url = "http://localhost:8989";
            api_key = "!env_var SONARR_API_KEY";
            delete_old_custom_formats = true;
            replace_existing_custom_formats = true;
            include = [
              {
                template = "sonarr-quality-definition-series";
              }
              {
                template = "sonarr-v4-quality-profile-web-1080p-alternative";
              }
              {
                template = "sonarr-v4-custom-formats-web-1080p";
              }
              {
                template = "sonarr-quality-definition-anime";
              }
              {
                template = "sonarr-v4-quality-profile-anime";
              }
              {
                template = "sonarr-v4-custom-formats-anime";
              }
            ];
            quality_profiles = [
              {
                name = "WEB-1080p";
              }
              {
                name = "Remux-1080p - Anime";
              }
            ];
            custom_formats = [
              {
                trash_ids = [
                  "026d5aadd1a6b4e550b134cb6c72b3ca"
                  "b2550eb333d27b75833e25b8c2557b38"
                  "418f50b10f1907201b6cfdf881f467b7"
                ];
                assign_scores_to = [
                  {
                    name = "Remux-1080p - Anime";
                    score = 0;
                  }
                ];
              }
            ];
          };
        };
      };
    };
  };

  virtualisation.oci-containers.containers = {
    watchstate = {
      autoStart = false;
      image = "ghcr.io/arabcoders/watchstate:latest";
      ports = [ "8081:8080" ];
      user = "1000:1000";
      volumes = [ "/data/.state/watchstate:/config:rw" ];
      # extraOptions = [ "--network=host" ];
    };

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
