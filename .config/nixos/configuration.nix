# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    # ./system-modules/kickstart.nixvim/nixvim.nix
    # ./home-manager/home.nix
    # ./system-modules/musnix
        # This includes the Lix NixOS module in your configuration along with the
    # matching version of Lix itself.
    #
    # The sha256 hashes were obtained with the following command in Lix (n.b.
    # this relies on --unpack, which is only in Lix and CppNix > 2.18):
    # nix store prefetch-file --name source --unpack https://git.lix.systems/lix-project/lix/archive/2.91.0.tar.gz
    #
    # Note that the tag (e.g. 2.91.0) in the URL here is what determines
    # which version of Lix you'll wind up with.
    # (let
    #   module = fetchTarball {
    #     name = "source";
    #     url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
    #     sha256 = "sha256-zNW/rqNJwhq2lYmQf19wJerRuNimjhxHKmzrWWFJYts=";
    #   };
    #   lixSrc = fetchTarball {
    #     name = "source";
    #     url = "https://git.lix.systems/lix-project/lix/archive/2.91.0.tar.gz";
    #     sha256 = "sha256-Rosl9iA9MybF5Bud4BTAQ9adbY81aGmPfV8dDBGl34s=";
    #   };
    #   # This is the core of the code you need; it is an exercise to the
    #   # reader to write the sources in a nicer way, or by using npins or
    #   # similar pinning tools.
    #   in import "${module}/module.nix" { lix = lixSrc; }
    # )
  ];

  # musnix.enable = true;
  nixpkgs = {
    # You can add overlays here
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      # experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      # flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    # channel.enable = true;

    package = pkgs.lix;
    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };


  # Bootloader
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        configurationLimit = 50;
        theme = pkgs.stdenv.mkDerivation 
	{
          pname = "distro-grub-themes";
          version = "3.1";
          src = pkgs.fetchFromGitHub 
	  {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "v3.1";
            hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
          };
        installPhase = "cp -r customize/nixos $out";
	};
      };
      timeout = 10;
    };
  };


  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LANGUAGE = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
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

  environment = {
    systemPackages = with pkgs; [
  ### development
      pkg-config
      gnumake
      git
      lazygit
      # zoxide
      fd
      yarn
      wget
      curl
      rustup
      # ghc
      # stack
      python3
      # octave
      gcc
      clang
      clang-tools
      perl
      # clojure
      # elixir
      pciutils
      go
      # nodejs_22
      unzip
      evcxr
      rappel
      gdb
      luarocks
      # ghidra
      # android-studio
      neovim-unwrapped
      radare2
      devenv
      dolphin

    ### desktop utils
      swayfx
      # swaynotificationcenter
      mako
      deadd-notification-center
      libnotify
      alacritty
      waybar
      wl-clipboard
      flameshot
      light
      waypaper
      swww
      gammastep
      tree
      gnupg
      mpd-small
      nomacs
      wev
      nwg-wrapper
      kdeconnect
      localsend
      android-file-transfer
      rofi-wayland
      keepassxc
      variety
      qbittorrent
      firefox-devedition
      lf
      xdg-utils
      xdg-desktop-portal
      xdg-desktop-portal-wlr
      dotnetCorePackages.sdk_9_0
      vesktop
      gst_all_1.gstreamer


    ### tools
      neofetch
      qdirstat
      jq
      wmname
      ripgrep
      ffmpeg-full
      htop-vim
      sysstat
      pciutils
      usbutils
      fzf
      lm_sensors
      flatpak
      ueberzugpp
      xorg.xauth
      nix-index
      dbus

    ### social media
      discord
      telegram-desktop
      element-desktop
      signal-desktop
      mastodon

    ### games
      steam
      playonlinux

    ### network & bluetooth
      bluez
      blueman
      nmap
      wireshark

    ### music
      reaper
      spicetify-cli
      spotdl
      # spotify
      strawberry
      vlc
      cava
      pavucontrol
      pulseaudioFull
      pipewire
      wireplumber
      playerctl
      zotify

    ### images & animation
      blender
      krita
      inkscape
      gimp

    ### productivity
      thunderbird
      # obsidian
      libreoffice
      virtualbox
      docker
      glow
      lsof

    ];
    etc = {
      "hosts" = lib.mkForce {
	text = ''
127.0.0.1 localhost
::1 localhost
127.0.0.2 f
::1 f
# Block spotify ads
127.0.0.1 media-match.com
127.0.0.1 adclick.g.doublecklick.net
127.0.0.1 www.googleadservices.com
127.0.0.1 open.spotify.com
127.0.0.1 pagead2.googlesyndication.com
127.0.0.1 desktop.spotify.com
127.0.0.1 googleads.g.doubleclick.net
127.0.0.1 pubads.g.doubleclick.net
127.0.0.1 audio2.spotify.com
127.0.0.1 www.omaze.com
127.0.0.1 omaze.com
127.0.0.1 bounceexchange.com
# 127.0.0.1 spclient.wg.spotify.com
127.0.0.1 securepubads.g.doubleclick.net
127.0.0.1 8.126.154.104.bc.googleusercontent.com
127.0.0.1 104.154.126.8
	'';
      };
    };
    extraOutputsToInstall = [ "dev" ];
    variables = {
      PATH = "${pkgs.clang-tools}/bin:$PATH";
    };
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    source-code-pro
  ];

  swapDevices = [{
    device = "/home/le/.local/opt/swapfile";
    size = 8 * 1024; # 16GB
  }];

  users.users = {
    le = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFRf6oqCiQGUvmjJTyNOl0G8Jap+wvca3B6H2a9Esizh le@f"
      ];

      extraGroups = [ 
        "wheel" 
        "networkmanager" 
        "audio" 
        "video" 
        "docker"
        "pipewire"
      ];
    }; 
  };


  hardware = {
    bluetooth = {
      enable = true; # enables support for Bluetooth
      # package = pkgs.pulseaudioFull;
      # settings.General = {
      #   Enable = "Source,Sink,Media,Socket";
      #   Experimental = true;
      # };
      powerOnBoot = true;
    };
    pulseaudio = {
      enable = false;
      support32Bit = true;    ## If compatibility with 32-bit applications is desired.
      configFile = pkgs.runCommand "default.pa" {} ''
        sed 's/module-udev-detect$/module-udev-detect tsched=0/' \
          ${pkgs.pulseaudioFull}/etc/pulse/default.pa > $out
      '';
    };

  };

  networking = {
    hostName = "f";
    # Enable networking
    networkmanager.enable = true;
    # # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


    # # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # # Or disable the firewall altogether.
    # firewall.enable = false;
  };
  
  security = {
    # rtkit is optional but recommended
    rtkit.enable = true;
    polkit.enable = true;
  };

  virtualisation = {
    # docker.enable = true;
    # libvirtd.enable = true;
  };
  # xdg.icons.enable = true;
  # xdg.mime.defaultApplications = {
  #   "x-scheme-handler/http" = [ "firefox-devedition.desktop" ];
  #   "x-scheme-handler/https" = [ "firefox-devedition.desktop" ];
  #   "text/html" = [ "firefox-devedition.desktop" ];
  # };
  xdg.portal = {
    config = {
      sway = {
        default = ["wlr"];
        # "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
      };
    };
    enable = true;
    wlr.enable = true;
    extraPortals = [
      # pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };
  services = {
    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "";
    };
    # Enable CUPS to print documents
    printing.enable = true;

    # This setups a SSH server. Very important if you're setting up a headless system.
    # Feel free to remove if you don't need it.
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        # Opinionated: use keys only.
        # Remove if you want to SSH using passwords
        PasswordAuthentication = true;
      };
    };
    jack = {
      jackd.enable = false;
      # support ALSA only programs via ALSA JACK PCM plugin
      alsa.enable = false;
      # support ALSA only programs via loopback device (supports programs like Steam)
      loopback = {
        enable = true;
        # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
        #dmixConfig = ''
        #  period_size 2048
        #'';
      };
    };
    pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      # jack.enable = true;
    #   wireplumber.configPackages = [
    #     (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
    #       monitor.bluez.properties = {
    #         bluez5.enable-sbc-xq = true
    #         bluez5.enable-msbc = true
    #         bluez5.enable-hw-volume = true
    #         bluez5.roles = [ a2dp_sink a2dp_source a2dp_source bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
    #         bluez5.codecs  = [ sbc sbc_xq aac ldac aptx aptx_hd aptx_ll aptx_ll_duplex faststream faststream_duplex lc3plus_h3 opus_05 opus_05_51 opus_05_71 opus_05_duplex opus_05_pro lc3 ]
    #       }
    #     '')
    #   ];
    };
    gnome = {
      gnome-keyring.enable = true;
    };
    flatpak.enable = true;
    blueman.enable = true;
    # hydra.enable = true;
    # xdg-desktop-portal.enable = true;
    # mpris-proxy.enable = true; 
  };

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    light = {
      enable = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        openssl
      ];
    };
    steam.enable = true;
    # nixvim.enable = true;
    # firefox.enable = true;
    dconf.enable = true;
  };
  # systemd.user.services.pipewire-pulse.path = [ pkgs.pulseaudio ];
  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
