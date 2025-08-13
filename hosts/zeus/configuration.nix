{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services = {
    xserver = {
      enable = true;
      excludePackages = with pkgs; [xterm];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      xserver.xkb = {
        layout = "us";
        variant = "";
      };
    };
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    flatpak.enable = true;
    tailscale.enable = true;
  };

  security.rtkit.enable = true;

  users.users.keaton = {
    isNormalUser = true;
    description = "Keaton Hasse";
    extraGroups = ["networkmanager" "wheel"];
  };

  programs = {
    firefox.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["keaton"];
    };
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      git
      tailscale
      nixd
      alejandra
      helix
      sublime4
      sublime-merge
      ghostty
      # cider-3
      dxvk
      gnome-2048
      gnome-chess
      stockfish
      gnome-sudoku
      crosswords
      gnomeExtensions.dash-to-dock
      gnomeExtensions.caffeine
      gnomeExtensions.gsconnect
      gnomeExtensions.hide-top-bar
      gnomeExtensions.window-is-ready-remover
      gnomeExtensions.remove-world-clocks
      gnomeExtensions.appindicator
      protonvpn-gui
      transmission_4
    ];
    gnome.excludePackages = with pkgs; [gnome-tour];
  };
}
