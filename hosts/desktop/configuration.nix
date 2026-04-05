# desktop specific configuration
{
  config,
  pkgs,
  user,
  ...
}: {
	# nix.optimise.automatic = true; # optimize the nix store
	# nix.gc = { # automatic garbage collection
	# 	automatic = true;
	# 	dates = "weekly";
	# 	options = "--delete-older-than 30d";
	# };
	# system.autoUpgrade = {
	# 	enable = true;
	# 	flake = inputs.self.outPath;
	# 	flags = [
	# 		"-L" # print build logs
	# 	];
	# 	dates = "02:00";
	# 	randomizedDelaySec = "45min";
	# };

	powerManagement.enable = true;
	hardware.bluetooth = {
		enable = true;
		powerOnBoot = true;
		settings = {
			General = {
				Experimental = true;
			};
		};
	};

	programs.hyprland.enable = true;

	services.displayManager.ly = {
		enable = true;
		settings = {
			animation = "none";
			battery_id = "BAT0";
			auto_login_user = "franz3";
			bigclock = "en";
			brightness_down_key = "F6";
			brightness_up_key = "F7";
			session_log = ".local/state/ly-session.log";
		};
	};
	services.udisks2.enable = true;
	services.gvfs.enable = true;
	services.xserver.videoDrivers = ["modesetting"];
	services.auto-cpufreq.enable = true;
	services.thermald.enable = true;

	hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver     # laptop hardware optimization?
      vpl-gpu-rt             # laptop hardware optimization?
      intel-compute-runtime  # laptop hardware optimization?
    ];
  };

	environment.sessionVariables = {
		LIBVA_DRIVER_NAME = "iHD";     # laptop hardware optimization?
		NIXOS_OZONE_WL = "1";
		GTK_USE_PORTAL = "1"; # make librewolf use xdg portal
	};


	environment.systemPackages = with pkgs; [
		rofi # app launcher
		wl-clipboard # clipboard
		wallust # generate colors from image
		wget # web requests
		dunst # notification daemon
		libnotify # send notifications
		grim # take screen
		slurp # capture screen
		ly # display manager
		android-tools
		kdePackages.xdg-desktop-portal-kde
		xdg-desktop-portal-termfilechooser
		bluetui
		file
		ffmpeg-full
		gimp
		imagemagick
		obsidian
		brightnessctl
		texliveFull
		texstudio
		teams-for-linux
		qpdf
		playerctl
	];

	fonts.packages = with pkgs; [
		nerd-fonts.symbols-only
		font-awesome
	];
}
