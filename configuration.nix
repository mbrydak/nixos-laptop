# `Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.nameservers = ["1.1.1.1" "1.1.1.1"];
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };
  virtualisation.docker.enable = true;
#  services.resolved = {
#    enable = true;
#    dnssec = "false";
#    domains = ["~."];
#    fallbackDns = ["1.1.1.1#one.one.one.one" "1.1.1.1#one.one.one.one"];
#  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
      sessionCommands = ''
        $(lib.getBin pkgs.xorg.xrandr)/bin/xrandr --setprovideroutputsource 2 0
      '';
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
        lxappearance
      ];
    };
#    videoDrivers = [ "intel" "displaylink" ];
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "DRI" "2"
      Option "TearFree" "true"
    '';
  };

  services.picom.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  programs.ssh.startAgent = true;

  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};

  services.autorandr = {
    enable = true;
  };

  # Configure keymap in X11
  services.xserver.layout = "pl";
    services.xserver.xkbOptions = "caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraConfig = "
      load-module module-switch-on-connect
      load-module module-bluetooth-discover
    ";
  };

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Enable bluetooth service
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.max = {
    initialPassword = "nixos123";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      chromium
      emacs
      ansible
      python311
      arandr
      rocketchat-desktop
      slack
      spotify
      bitwarden
      poppler_utils
      bash-completion
      sshuttle
      libgen-cli
      sshpass
      git
      scrot
      dive
      file
      du-dust
      direnv
      puppet-lint
      unzip
      zip
      poetry
      alacritty
      stow
      croc
      tmux
      pavucontrol
      neovim
      emacs
      ripgrep
      fd
      tig
      tree
      neofetch
      obsidian
      nodejs_20
      vscode-fhs
      gimp
      k3d
      nix-index
      cloudflare-warp
      kubectl
      lens
      k9s
      kubernetes-helm
      fluxcd
      gnumake
      qutebrowser
      websocat
      pciutils
      xclip
      glow
      dig
      inetutils
      traceroute
      rsync
      okular
      tealdeer
      zellij
      bat
      killall
      feh
      gccgo13
      yq
      jq
      rustup
      zoxide
      fzf
      go
      jless
      rofi
      rofi-rbw
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    blueberry
    networkmanager_dmenu
    networkmanagerapplet
  ];

  environment.shellAliases = {libgen = "libgen-cli";};

  environment.pathsToLink = ["/libexec"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  #programs.gnupg.agent = {
  #  enable = true;
  #   enableSSHSupport = true;
  #};
  programs.dconf.enable = true;
  programs.bash.interactiveShellInit = "neofetch";


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  networking.firewall = {
  allowedUDPPorts = [ 5353 ]; # For device discovery
  allowedUDPPortRanges = [{ from = 32768; to = 61000; }];   # For Streaming
};
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?


  # enable xdg desktop integration

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
}


