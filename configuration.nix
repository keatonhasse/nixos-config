{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./tsnsrv.nix
    ./nixarr.nix
    ./minecraft.nix
    ./paperless.nix
  ];

  #nixpkgs.config.permittedInsecurePackages = [
  #  "dotnet-sdk-6.0.428"
  #  "aspnetcore-runtime-6.0.36"
  #];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  networking.hostName = "anton";

  systemd.network.enable = true;
  networking.useNetworkd = true;
  networking.enableIPv6  = false;
  boot.blacklistedKernelModules = [ "iwlwifi" ];
  networking.nameservers = [ "194.242.2.2" ];

  time.timeZone = "America/Chicago";

  users.users.keaton = {
    isNormalUser = true;
    description = "keaton";
    extraGroups = [ "wheel" "docker" "minecraft" ];
  };
  services.getty.autologinUser = "keaton";
  security.sudo.wheelNeedsPassword = false;

#  users.users.braxton = {
#    isNormalUser = true;
#    group = "media";
#    createHome = false;
#  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    tailscale
    inputs.agenix.packages."x86_64-linux".default
    git
    helix
    nil
    nixfmt-rfc-style
    neovim
    tmux
    lshw
    unzip
    libnatpmp
  ];

  environment.variables.EDITOR = "hx";

  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };

  services.samba = {
    enable = false;
    openFirewall = true;
    settings = {
      "global" = {
        "fruit:aapl" = "yes";
        "vfs objects" = "catia fruit streams_xattr";
        "veto files" = "/._*/.DS_Store/";
        "delete veto files" = "yes";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "music" = {
        "path" = "/data/braxton/music";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "streamer";
        "force group" = "media";
      };
    };
  };

  services.audiobookshelf = {
    enable = false;
  };

  services.invidious = {
    enable = false;
  };

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  system.stateVersion = "24.05";
}
