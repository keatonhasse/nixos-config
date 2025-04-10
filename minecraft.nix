{ pkgs, inputs, ... }:

{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    #dataDir = "/data/minecraft";
    servers = {
      lovecraft = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21;
      };
    };
    managementSystem = {
      tmux.enable = false;
      systemd-socket.enable = true;
    };
  };

  virtualisation.oci-containers.containers.bedrock = {
    autoStart = true;
    environment = {
      EULA = "TRUE";
      OPS = "2533274973251167,2535406548957425";
      ALLOW_LIST_USERS = "hfialy:2533274973251167,Aldilover:2535406548957425";
    };
    image = "itzg/minecraft-bedrock-server:latest";
    ports = [ "19132:19132/udp" ];
    volumes = [ "/srv/minecraft/bedrock:/data" ];
  };
  networking.firewall.allowedUDPPorts = [ 19132 ];
}
