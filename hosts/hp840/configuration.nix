# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Nix config
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.extraOptions = ''
    trusted-users = root max
  '';

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nix.optimise.automatic = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-8ca1acab-c74d-4bfb-9230-d66684026ef6".device = "/dev/disk/by-uuid/8ca1acab-c74d-4bfb-9230-d66684026ef6";
  networking.hostName = "hp840"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.hosts = {
    "192.168.11.28" = [ "bastion" ];
    "192.168.11.167" = [ "cntm" ];
    "127.0.0.1" = [ "vault.vault" ];
    #  "192.168.0.77" = ["k8s-master-0.homelab.home"];
    #  "192.168.0.116" = ["k8s-master-1.homelab.home"];
    #  "192.168.0.220" = ["k8s-master-2.homelab.home"];
    #  "192.168.0.27" = ["k8s-worker-0.homelab.home"];
    #  "192.168.0.232" = ["k8s-worker-1.homelab.home"];
    #  "192.168.0.84" = ["k8s-worker-2.homelab.home"];
    #  "192.168.0.201" = ["pve.homelab.home"];
    #  "192.168.0.57" = ["pihole.homelab.home"];
    #  "192.168.0.78" = ["k8s-lb.homelab.home"];
  };

  networking.nameservers = [ "192.168.0.57" ];

  stylix.enable = true;

  stylix.image = ./wallpaper/motorcycle-anime-girl.png;

  stylix.polarity = "dark";

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.flatpak.enable = true;
  services.resolved.enable = true;

  # environment.etc."paperless-admin-pass".text = "admin";
  # services.paperless = {
  #   enable = true;
  #   passwordFile = "/etc/paperless-admin-pass";
  #   settings = {
  #     PAPERLESS_CONSUMER_IGNORE_PATTERN = [
  #       ".DS_STORE/*"
  #       "desktop.ini"
  #     ];
  #     PAPERLESS_OCR_LANGUAGE = "pol+eng";
  #     PAPERLESS_OCR_USER_ARGS = {
  #       optimize = 1;
  #       pdfa_image_compression = "lossless";
  #     };
  #   };
  # };

  services.k3s = {
    enable = false;
    package = pkgs.k3s_1_30;
    extraFlags = "--disable traefik";
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver = {
    enable = true;
    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
      };
      mouse.accelProfile = "flat";
    };

    windowManager = {
      awesome = {
        enable = true;
      };
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          i3status
          i3lock
          i3blocks
          lxappearance
        ];
      };
    };

    videoDrivers = [
      "intel"
      "modesetting"
    ];
    deviceSection = ''
      Option "DRI" "2"
      Option "TearFree" "true"
    '';
  };

  environment.pathsToLink = [
    "/libexec"
    "/share/zsh"
  ];

  #musnix = {
  #  enable = true;
  #  rtcqs.enable = true;
  #  soundcardPciId = "00:1f.3";
  #  kernel.realtime = true;
  #};
  documentation = {
    nixos.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
  };

  services.locate.enable = true;

  services.ollama = {
    enable = true;
  };

  #services.open-webui = {
  #  enable = true;
  #  environment = {
  #    SCARF_NO_ANALYTICS = "True";
  #    DO_NOT_TRACK = "True";
  #    ANONYMIZED_TELEMETRY = "False";
  #    WEBUI_AUTH = "False";
  #  };
  #};

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # services.picom.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.ssh.startAgent = true;
  programs.xwayland.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID"; # set the runtime directory
  security.pam.services.gdm-password.enableGnomeKeyring = true;
  security.pki.certificateFiles = [
    ./certs/ca-chain.crt
    ./certs/ca.crt
  ];

  # services.printing = {
  #   enable = true;
  #   drivers = with pkgs; [ brlaser ];
  # };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # If you want to use JACK applications, uncomment this

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    wireplumber = {
      enable = true;
      package = pkgs.wireplumber;
    };
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # services.blueman.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "pl";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable sound with pipewire.

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.max = {
    isNormalUser = true;
    description = "max";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "scanner"
      "lp"
      "libvirtd"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ ];
  };
  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    mako
    libnotify
    xterm
    rofi
    inputs.nixvim-config.packages.${system}.default
    k3s_1_30
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    jost
    ibm-plex
    openmoji-color
    noto-fonts
    noto-fonts-color-emoji
    font-awesome
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    # pkgs.xdg-desktop-portal-gnome
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  services.xserver.displayManager = {
    # defaultSession = "none+awesome";
    defaultSession = "hyprland";
  };

  # enalbe zsh
  programs.zsh.enable = true;

  # List services that you want to enable:
  # Enable Docker

  virtualisation = {
    docker.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      UseDns = true;
      PasswordAuthentication = true;
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 5353 ];
    allowedUDPPortRanges = [
      {
        from = 32768;
        to = 61000;
      }
    ];
    allowedTCPPorts = [
      8010
      6443
      10250
      6379
      80
      443
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
