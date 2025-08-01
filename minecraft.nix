{ ... }:

{
  users = {
    users.minecraft = {
      description = "minecraft";
      home = "/data/minecraft";
      createHome = true;
      homeMode = "770";
      isSystemUser = true;
      group = "minecraft";
      uid = 991;
    };
    groups.minecraft.gid = 990;
  };

  virtualisation.quadlet = {
    containers = {
      # lovecraft = {
      #   containerConfig = {
      #     image = "itzg/minecraft-server";
      #     environments = {
      #       EULA = "TRUE";
      #       TYPE = "FABRIC";
      #       UID = "991";
      #       GID = "990";
      #     };
      #     publishPorts = [ "25565:25565" ];
      #     volumes = [ "/data/minecraft/lovecraft:/data" ];
      #   };
      # };
      bedrock = {
        containerConfig = {
          image = "itzg/minecraft-bedrock-server";
          environments = {
            DEBUG = "TRUE";
            EULA = "TRUE";
            OPS = "2533274973251167,2535406548957425";
            ALLOW_LIST_USERS = "hfialy:2533274973251167,Aldilover:2535406548957425";
          };
          publishPorts = [ "19132:19132/udp" ];
          volumes = [ "/data/minecraft/bedrock:/data" ];
        };
      };
      create = {
        containerConfig = {
          image = "itzg/minecraft-server";
          environments = {
           EULA = "TRUE";
            UID = "991";
            GID = "990";
            TYPE = "NEOFORGE";
            VERSION = "1.21.1";
            MEMORY = "4G";
          };
          publishPorts = [ "25566:25565" ];
          volumes = [ "/data/minecraft/create:/data" ];
        };
      };
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 25565 25566 19132 ];
    allowedTCPPorts = [ 25565 25566 ];
  };
}
