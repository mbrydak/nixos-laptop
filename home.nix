{
  config,
  pkgs,
  inputs,
  ...
}:

{
  nixpkgs.config.allowUnfreePredicate = pkg: true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    keyboard = {
      options = [ "caps:escape" ];
    };

    username = "max";
    homeDirectory = "/home/max";
    stateVersion = "24.05"; # Please read the comment before changing.
    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.config/emacs/bin"
    ];

    packages = with pkgs; [
      ansible
      tenacity
      arandr
      archi
      argocd
      autotiling
      bat
      bitwarden
      brightnessctl
      cardinal
      cloudflare-warp
      croc
      csview
      dmenu
      delve
      devbox
      dig
      direnv
      discord
      distrobox
      du-dust
      fd
      feh
      firefox
      fluxcd
      foliate
      freshfetch
      fzf
      gh
      git
      git-lfs
      glow
      gnumake
      go
      google-chrome
      gparted
      k3d
      graphviz
      hddtemp
      htop
      ibm-plex
      inetutils
      jless
      jost
      jq
      k9s
      killall
      kind
      kubectl
      kubernetes-helm
      kustomize
      libgen-cli
      libreoffice
      llama-cpp
      lm_sensors
      mermaid-cli
      gnome.nautilus
      (nerdfonts.override { fonts = [ "Hack" ]; })
      networkmanager
      networkmanager-openconnect
      nil
      nix-index
      obsidian
      okular
      openconnect
      openssl
      pavucontrol
      pcmanfm
      picom
      resumed
      ripgrep
      rsync
      scrot
      shutter
      slack
      spotify
      ssm-session-manager-plugin
      starship
      tealdeer
      teams-for-linux
      tenacity
      thunderbird
      traceroute
      transmission_4
      tree
      unzip
      usbutils
      vcv-rack
      vlc
      xorg.xbacklight
      yq-go
      zap
      zathura
      zeal
      zip
      zoxide
      zotero
    ];
    sessionVariables = {
      TERM = "xterm-256color";
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/max/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.

  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
      };

      urgency_normal = {
        timeout = 10;
      };
    };
  };
  programs = {
    home-manager.enable = true;
    autorandr = {
      enable = true;
    };
  };
  # Let Home Manager install and manage itself.

  fonts = {
    fontconfig = {
      enable = true;
    };
  };

  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
      userSettings = {
        "files.autoSave" = "onFocusChange";
        "editor.formatOnSave" = true;
        "workbench.sideBar.location" = "right";
      };
    };
    qutebrowser = {
      enable = true;
    };
    waybar = {
      enable = true;
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    ranger = {
      enable = true;
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      autocd = true;
      enableVteIntegration = true;
      shellAliases = {
        gitroot = "cd $(git rev-parse --show-toplevel)";
        nv = "nvim";
        k = "kubectl --";
      };
      history = {
        ignoreDups = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "aws"
        ];
      };
      sessionVariables = {
        TERM = "xterm-256color";
      };
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      changeDirWidgetCommand = "fd --type d . $HOME";
      fileWidgetCommand = "fd --type d .";
      tmux = {
        enableShellIntegration = true;
      };
    };
    git = {
      enable = true;
      delta.enable = true;
      userEmail = "maxbrydak@gmail.com";
      userName = "mbrydak";
    };

    alacritty = {
      enable = true;
      settings = pkgs.lib.mkForce {
        font = {
          normal = {
            family = "Hack Nerd Font Mono";
          };
        };
        window = {
          opacity = 0.9;
        };
      };
    };
    tmux = {
      enable = true;
      terminal = "xterm-256color";
      clock24 = true;
      mouse = true;
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-boot 'on'
            set -g @continuum-save-interval '1'
          '';
        }
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.catppuccin
      ];
    };
    zellij = {
      enable = false;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    helix = {
      enable = true;
      extraPackages = [
        pkgs.marksman
        pkgs.terraform-ls
        pkgs.nil
        pkgs.rust-analyzer
        pkgs.gopls
      ];
      languages = {
        language = [
          {
            name = "rust";
            auto-format = true;
          }
          {
            name = "hcl";
            auto-format = true;
          }
        ];
      };
    };
    rofi = {
      enable = true;
      terminal = "alacritty";
      extraConfig = {
        modes = "window,drun,run,ssh";
        show-icons = true;
      };
      # theme = "gruvbox-dark-soft";
    };

    hyprlock = {
      enable = true;
    };

  };
  xsession.windowManager = {
    awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks
        luadbi-mysql
      ];
    };
    i3 = {
      enable = true;
      config = {
        defaultWorkspace = "workspace number 3";
        bars = [
          {
            mode = "dock";
            hiddenState = "hide";
            workspaceButtons = true;
            workspaceNumbers = true;
            statusCommand = "${pkgs.i3status}/bin/i3status";
            trayOutput = "primary";
            colors = {
              background = "#000000";
              statusline = "#ffffff";
              separator = "#666666";
              focusedWorkspace = {
                border = "#4c7899";
                background = "#285577";
                text = "#ffffff";
              };
              activeWorkspace = {
                border = "#333333";
                background = "#5f676a";
                text = "#ffffff";
              };
              inactiveWorkspace = {
                border = "#333333";
                background = "#222222";
                text = "#888888";
              };
              urgentWorkspace = {
                border = "#2f343a";
                background = "#900000";
                text = "#ffffff";
              };
              bindingMode = {
                border = "#2f343a";
                background = "#900000";
                text = "#ffffff";
              };
            };

            # fonts = {
            #   names = [ "Hack" ];
            #   size = 11.0;
            # };

          }
        ];

        # fonts = {
        #   names = [ "Hack" ];
        #   size = 11.0;
        # };

        gaps = {
          smartGaps = true;
          bottom = 5;
          horizontal = 5;
          inner = 5;
          left = 5;
          outer = 5;
          right = 5;
          vertical = 5;
        };

        workspaceAutoBackAndForth = true;
        workspaceOutputAssign = [
          {
            output = "HDMI1";
            workspace = "3";
          }
          {
            output = "eDP1";
            workspace = "2";
          }
          {
            output = "DP-2";
            workspace = "1";
          }
        ];
        modifier = "Mod4";
        keybindings =
          let
            modifier = config.xsession.windowManager.i3.config.modifier;
          in
          pkgs.lib.mkOptionDefault {
            "${modifier}+Control+Left" = "focus output left";
            "${modifier}+Control+Right" = "focus output right";
            "${modifier}+Control+Shift+Left" = "move output left";
            "${modifier}+Control+Shift+Right" = "move output right";
            "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status";
            "XF86AudioLowerVolume " = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status";
            "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status";
            "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status";
            "XF86MonBrightnessUp" = "exec --no-stsartup-id brightnessctl set +10%";
            "XF86MonBrightnessDown" = "exec --no-stsartup-id brightnessctl set 10%-";
          };
        startup = [
          {
            command = "dex --autostart --environment i3";
            always = false;
            notification = false;
          }
          {
            command = "xss-lock --transfer-sleep-lock -- i3lock --nofork";
            always = false;
            notification = false;
          }
          {
            command = "nm-applet";
            always = false;
            notification = false;
          }
          {
            command = "i3wsr";
            always = true;
            notification = false;
          }
          {
            command = "i3altlayout";
            always = true;
            notification = false;
          }
        ];
        terminal = "alacritty";
      };
    };

  };
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:escape" ];
    };
  };
  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   settings = {
  #     "$mainMod" = "SUPER";
  #     "exec-once" = "waybar & hyprpaper & qutebrowser";
  #     general = {
  #       gaps_in = 5;
  #       gaps_out = 10;
  #       border_size = 2;
  #       layout = "dwindle";
  #     };
  #     input = {
  #       kb_layout = "pl";
  #       touchpad = {
  #         natural_scroll = "yes";
  #       };
  #     };
  #     decoration = {
  #       rounding = 10;
  #       blur = {
  #         enabled = true;
  #         size = 3;
  #         passes = 1;
  #       };
  #       drop_shadow = "yes";
  #       shadow_range = 4;
  #       shadow_render_power = 3;

  #     };
  #     dwindle = {
  #       pseudotile = "yes";
  #       preserve_split = "yes";

  #     };
  #     bind = [
  #       "$mainMod, Q, exec, alacritty"
  #       "$mainMod, C, killactive,"
  #       "$mainMod, M, exit,"
  #       "$mainMod, E, exec, dolphin"
  #       "$mainMod, V, togglefloating,"
  #       "$mainMod, R, exec, wofi --show drun"
  #       "$mainMod, P, pseudo," # dwindle
  #       "$mainMod, J, togglesplit," # dwindle

  #       # Move focus with mainMod + arrow keys
  #       "$mainMod, left, movefocus, l"
  #       "$mainMod, right, movefocus, r"
  #       "$mainMod, up, movefocus, u"
  #       "$mainMod, down, movefocus, d"

  #       # Switch workspaces with mainMod + [0-9]
  #       "$mainMod, 1, workspace, 1"
  #       "$mainMod, 2, workspace, 2"
  #       "$mainMod, 3, workspace, 3"
  #       "$mainMod, 4, workspace, 4"
  #       "$mainMod, 5, workspace, 5"
  #       "$mainMod, 6, workspace, 6"
  #       "$mainMod, 7, workspace, 7"
  #       "$mainMod, 8, workspace, 8"
  #       "$mainMod, 9, workspace, 9"
  #       "$mainMod, 0, workspace, 10"

  #       # Move active window to a workspace with mainMod + SHIFT + [0-9]
  #       "$mainMod SHIFT, 1, movetoworkspace, 1"
  #       "$mainMod SHIFT, 2, movetoworkspace, 2"
  #       "$mainMod SHIFT, 3, movetoworkspace, 3"
  #       "$mainMod SHIFT, 4, movetoworkspace, 4"
  #       "$mainMod SHIFT, 5, movetoworkspace, 5"
  #       "$mainMod SHIFT, 6, movetoworkspace, 6"
  #       "$mainMod SHIFT, 7, movetoworkspace, 7"
  #       "$mainMod SHIFT, 8, movetoworkspace, 8"
  #       "$mainMod SHIFT, 9, movetoworkspace, 9"
  #       "$mainMod SHIFT, 0, movetoworkspace, 10"

  #       # Scroll through existing workspaces with mainMod + scroll
  #       "$mainMod, mouse_down, workspace, e+1"
  #       "$mainMod, mouse_up, workspace, e-1"

  #       # Move/resize windows with mainMod + LMB/RMB and dragging

  #     ];
  #     bindm = [
  #       "$mainMod, mouse:272, movewindow"
  #       "$mainMod, mouse:273, resizewindow"

  #     ];
  #   };
  # };
}
