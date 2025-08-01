{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./tsnsrv.nix
    ./nixarr.nix
    ./minecraft.nix
    ./miniflux.nix
    ./paperless.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
    blacklistedKernelModules = [ "iwlwifi" ];
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  systemd.network.enable = true;
  networking = {
    hostName = "anton";
    useNetworkd = true;
    enableIPv6  = false;
    nameservers = [ "194.242.2.2" ];
    firewall = {
      allowedTCPPorts = [ 22 80 443 ];
      trustedInterfaces = [ "tailscale0" ];
    };
  };

  time.timeZone = "America/Chicago";

  users.users.keaton = {
    isNormalUser = true;
    description = "keaton";
    extraGroups = [ "wheel" "docker" "minecraft" ];
  };
  services.getty.autologinUser = "keaton";
  security.sudo.wheelNeedsPassword = false;

  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      tailscale
      inputs.agenix.packages."x86_64-linux".default
      git
      helix
      libnatpmp
      nil
      nixfmt-rfc-style
      unzip
    ];
    variables.EDITOR = "hx";
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services = {
    openssh.enable = true;
    tailscale.enable = true;
    audiobookshelf.enable = false;
    invidious.enable = false;
  };

  system.stateVersion = "24.05";
}
