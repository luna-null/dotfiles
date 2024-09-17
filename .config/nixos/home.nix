{ config, pkgs, ... }:
# let
#   unstableTarball = fetchTarball {
#       url = https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
#   };
# in
{
  # imports = [
  #   ./modules/spicetify.nix
  # ];

#   nixpkgs.config = {
#     packageOverrides = pkgs: {
#       unstable = import unstableTarball {
#     config = config.nixpkgs.config;
#   };


  home-manager.extraSpecialArgs = { inherit unstable };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "le";
  home.homeDirectory = "/home/le";

  xresources.properties = {
    "Xcursor.size" = 36;
    "Xcursor.theme" = "Skyrim";
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # pkgs is the set of all packages in the default home.nix implementation
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.le}!"
    # '')

	# desktop utils
	alacritty
	waybar
	wl-clipboard
	flameshot
	light
	pipewire
	swww
	gammastep
	tree
	gnupg
	radare2
	mpd-small
	nomacs
	mpv
	wev
	mako
	nwg-dock
	nwg-wrapper
	kdeconnect
	localsend
	android-file-transfer
	rofi-wayland
	keepassxc
	pulseaudio
	variety
	qbittorrent
	firefox-devedition

	# tools
	neofetch
	qdirstat
	jq
	wmname
	ripgrep
	jellyfin-ffmpeg
	htop-vim
	sysstat
	pciutils
	usbutils
	fzf
	lm_sensors

	# social media
	discord
	telegram-desktop
	element
	signal-desktop

	# games
	steam
	playonlinux

	# network & bluetooth
	bluez
	blueman
	nmap
	wireshark

	# music
	reaper
	spicetify-cli
	spotdl
	# zotify
	spotify

	# images & animation
	blender
	krita
	inkscape
	gimp

	# productivity
	thunderbird
	neomutt
	obsidian
	libreoffice
	virtualbox
	docker
	glow
	lsof

	# programming
	evcxr
	rappel
	gdb
	neovim
	ghidra
	# android-studio
  ];


  programs.git = {
    enable = true;
    userName = "luna-null";
    userEmail = "elliqua@gmail.com";
  };








  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    # ".bashrc".source = dotfiles/.bashrc;
    # ".pyrc".source = dotfiles/.pyrc;
    # ".sounds".source = dotfiles/.sounds;
    #
    # ".bash_profile".source = dotfiles/.bash_profile;
    # ".Xresources".source = dotfiles/.Xresources;
    # ".xinitrc".source = dotfiles/.xinitrc;
    # ".ghci".source = dotfiles/.ghci;
    # ".gtkrc-2.0.mine".source = dotfiles/.gtkrc-2.0.mine;

  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/le/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };



    # outputs = { nixpkgs, spicetify-nix, ...}: let # notice spicetify-nix here
    #     pkgs = import nixpkgs { system = "x84_64-linux"; };
    # in {
    #   homeConfigurations."le" =  {
    #     inherit pkgs;
    #     extraSpecialArgs = {inherit spicetify-nix;};
    #     modules = [
    #         ./home.nix
    #         ./spicetify.nix # file where you configure spicetify
    #     ];
    #   };
    # };



  # outputs = { nixpkgs, spicetify-nix, ...}: let # notice spicetify-nix here
  #     pkgs = import nixpkgs { system = "x84_64-linux"; };
  # in {
  #   homeConfigurations."le" = home-manager.lib.homeManagerConfiguration {
  #     inherit pkgs;
  #     extraSpecialArgs = {inherit spicetify-nix;};
  #     modules = [
  #         ./home.nix
  #         ./spicetify.nix # file where you configure spicetify
  #     ];
  #   };
  # };

  # Let Home Manager install and manage itself.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}

