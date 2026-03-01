# desktop specific configuration
{
  config,
  pkgs,
  user,
  ...
}: {
	programs.hyprland.enable = true;
	services.displayManager.ly = {
		enable = true;
		settings = {
			animation = "none";
			battery_id = "BAT0";
			auto_login_user = "franz3";
			bigclock = "en";
		};
	};
	services.udisks2.enable = true;
	services.gvfs.enable = true;

	environment.systemPackages = with pkgs; [
		rofi
		wl-clipboard
		wallust
		wget
		kitty
		alacritty
		dunst
		libnotify
		grim
		slurp
		ly
		ueberzugpp
		android-tools
	];

	fonts.packages = with pkgs; [
		font-awesome
	];
}
