# desktop specific home-manager configuration
{
  config,
  pkgs,
  inputs,
  user,
  ...
}: 
let
	spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.system};
	stashPkgs = inputs.stash.packages.${pkgs.stdenv.system}.stash;
	heliumPkgs = inputs.helium.packages.${pkgs.stdenv.system}.default;
	hyprlandPkgs = inputs.hyprland.packages.${pkgs.stdenv.system}.hyprland;
	hyprPortalPkgs = inputs.hyprland.packages.${pkgs.stdenv.system}.xdg-desktop-portal-hyprland;
	flakePath = "~/nixos-config";
in
{
	home.packages = [
		stashPkgs
		heliumPkgs
	];
	systemd.user.services.stash = {
		Unit = {
			Description = "Stash Watch Daemon";
			After = [ "graphical-session.target" ];
			PartOf = [ "graphical-session.target" ];
		};

    Service = {
      ExecStart = "${stashPkgs}/bin/stash watch";
      Restart = "on-failure";
			PassEnvironment = "WAYLAND_DISPLAY";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
	};
	# set default applications
	# https://specifications.freedesktop.org/mime-apps/latest/default
	# file --mime-type -b $file_name
	# ls /run/current-system/sw/share/applications # for global packages
	# ls /etc/profiles/per-user/franz3/share/applications # for user packages
	# ls ~/.nix-profile/share/applications # for home-manager packages
	xdg = {
		portal = {
			enable = true;
			extraPortals = with pkgs; [
				xdg-desktop-portal-termfilechooser
				kdePackages.xdg-desktop-portal-kde
			];
			config = {
				common = {
					"default" = "kde";
					"org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
					"org.freedesktop.impl.portal.GlobalShortcuts" = "hyprland";
					"org.freedesktop.impl.portal.ScreenCast" = "hyprland";
					"org.freedesktop.impl.portal.Screenshot" = "hyprland";
					
  			};
			};
		};

		userDirs = {
			enable = true;
			createDirectories = true;
		};

		configFile."xdg-desktop-portal-termfilechooser/config" = {
  		force = true;
			text =
			''
				[filechooser]
				cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
			'';
		};

		mimeApps = {
			enable = true;
			defaultApplications = {
				"inode/directory" = "yazi.desktop";
				"x-scheme-handler/file" = "yazi.desktop";
				"application/pdf" = "zathura.desktop";
				"video/*" = "mpv.desktop";
				"image/*" = "swayimg.desktop";
				"audio/*" = "mpv.desktop";
				"text/html" = "librewolf.desktop";
      			"x-scheme-handler/http" = "librewolf.desktop";
				"x-scheme-handler/https" = "librewolf.desktop";
				"x-scheme-handler/about" = "librewolf.desktop";
				"x-scheme-handler/unknown" = "librewolf.desktop";
			};
		};

		desktopEntries.yazi = {
			name = "Yazi";
			comment = "Terminal File Manager";
			exec = "kitty yazi %F";
			terminal = false; # false because terminal emu sets window
			type = "Application";
			categories = [ "System" "FileManager" ];
			mimeType = [ "inode/directory" ];
		};
	};

	programs = {
		mpv.enable = true;
		keepassxc.enable = true;
		zed-editor.enable = true;
		hyprlock.enable = true;
		swayimg.enable = true;
		fastfetch.enable = true;
		zathura.enable = true;
		nh = {
			enable = true;
			flake = flakePath;
			osFlake = flakePath;
			homeFlake = flakePath;
		};

		kitty = {
			enable = true;
			enableGitIntegration = true;
			settings = {
				confirm_os_window_close = -1;
			};
		};

		vesktop = {
			enable = true;
			settings = {
				appBadge = true;
				arRPC = true;
				checkUpdates = true;
				customTitleBar = false;
				disableMinSize = true;
				minimizeToTray = true;
				tray = true;
				hardwareAcceleration = true;
				discordBranch = "stable";
			};
			vencord.settings.plugins = {
				MessageLogger = {
					enabled = true;
					ignoreSelf = true;
				};
				FakeNitro.enabled = true;
				AnonymiseFileNames.enabled = true;
				BetterSessions.enabled = true;
				BetterSettings.enabled = true;
				CallTimer.enabled = true;
				ClearURLs.enabled = true;
				FavoriteEmojiFirst.enabled = true;
				FixImagesQuality.enabled = true;
				FixYoutubeEmbeds.enabled = true;
				ImageZoom.enabled = true;
				YoutubeAdblock.enabled = true;
				NotTypingAnimation.enabled = true;
				SilentTyping.enabled = true;
				BetterFolders.enabled = true;
				AlwaysAnimate.enabled = true;
				AlwaysTrust.enabled = true;
				BlurNSFW.enabled = true;
				Dearrow.enabled = true;
				ForceOwnerCrown.enabled = true;
				FixCodeblockGap.enabled = true;
				NoOnboardingDelay.enabled = true;
				NoProfileThemes.enabled = true;
				NoUnblockToJump.enabled = true;
				OpenInApp.enabled = true;
				ShowHiddenChannels.enabled = true;
				SpotifyCrack.enabled = true;
				Summaries.enabled = true;
				Translate.enabled = true;
				UserMessagesPronouns.enabled = true;
				USRBG.enabled = true;
      		};
		};

		waybar = {
			enable = true;
			style = ''
				* {
					font-family: Roboto, Helvetica, Arial, sans-serif, "Font Awesome 7 Free";
    			font-size: 13px;
				}
			'';
		};

		librewolf = {
			enable = true;
			profiles = {
				"default" = {
					id = 0;
					isDefault = true;
					settings = {
						# about:config
						"widget.use-xdg-desktop-portal.file-picker" = 1;
						"extensions.autoDisableScopes" = 0;
						# forcefully hardcode the toolbar layout (general firefox layout I guess?)
						# about:support -> Profile dir -> prefs.js
						"browser.uiCustomization.state" = ''
							# copy from browser.uiCustomization.state (e.g. {"placements":...)
						'';
					};
					bookmarks = {
						force = true;
						settings = [
							{
								name = "Toolbar";
								toolbar = true;
								bookmarks = [
									{
										name = "Nix Packages";
										url = "https://search.nixos.org/packages?channel=unstable";
										keyword = "nix"; 
									}
									{
										name = "Nix Home Manager";
										url = "https://home-manager-options.extranix.com/?query=&release=master";
										keyword = "nix"; 
									}
									{
										name = "Luke Smith Programs";
										url = "https://lukesmith.xyz/programs/";
										keyword = "luke smith";
									}
								];
							}
						];
					};
					extensions = {
						# dont froce for now until its possible to set up/ link KeePassXC with its extension using nix
						# force = true;
						# https://nur.nix-community.org/repos/rycee/
						packages = with pkgs.nur.repos.rycee.firefox-addons; [
							violentmonkey
							dearrow
							sponsorblock
							keepassxc-browser
							# still dont care about cookies
							# translator
							# fast forward thingy
							# youtube shorts
							# youtube dislikes
							# clear urls (remove tracking, shorten)
						];
						# wait till available: https://github.com/nix-community/home-manager/issues/8094
						# find extension id at about:support
						# check extension devtools at about:debugging#/runtime/this-firefox
						# settings = {
						# 	"sponsorBlocker@ajay.app".settings = {
						# 		categorySelections = [
						# 			{"name"="sponsor"; "option"=2;}
						# 			{"name"="poi_highlight"; "option"=0;}
						# 			{"name"="exclusive_access"; "option"=0;}
						# 			{"name"="chapter"; "option"=0;}
						# 			{"name"="selfpromo"; "option"=2;}
						# 			{"name"="interaction"; "option"=2;}
						# 			{"name"="intro"; "option"=2;}
						# 			{"name"="preview"; "option"=2;}
						# 			{"name"="hook"; "option"=2;}
						# 			{"name"="music_offtopic"; "option"=2;}
						# 		];
						# 	};
						# };
					};
					search = {
						default = "ddg";
						force = true;
					
						engines = {
							"ddg" = {
								urls = [{
									template = "https://duckduckgo.com/";
									params = [
										{ name = "q"; value = "{searchTerms}"; }
									];
								}];
							};
						};
        	};
				};
			};
		};

		vscode = {
			enable = true;
			package = pkgs.vscodium;
			profiles.default.extensions = with pkgs.vscode-extensions; [
				jnoortheen.nix-ide
				catppuccin.catppuccin-vsc
				catppuccin.catppuccin-vsc-icons
			];
		};

		yazi = {
			enable = true;
			plugins = {
				gvfs = pkgs.yaziPlugins.gvfs;
			};
		};

		spicetify = {
			enable = true;
			enabledExtensions = with spicePkgs.extensions; [
				adblockify
				hidePodcasts
				shuffle
				groupSession
				fullAlbumDate
				listPlaylistsWithSong
				wikify
				autoVolume
				showQueueDuration
				betterGenres
				history
				playNext
				skipAfterTimestamp
				allOfArtist
				oldCoverClick
				aiBandBlocker
				extendedCopy
			];
			theme = spicePkgs.themes.comfy;
			# colorScheme = "";
		};
	};

	services = {
		# cliphist.enable = true;
		awww.enable = true;
		hyprpolkitagent.enable = true;
		udiskie.enable = true;

		# generate hash for username/ pass
		# nix-shell -p apacheHttpd --run "htpasswd -nbB franz3 password"
		syncthing = {
			enable = true;
			settings = {
				gui = {
					user = "franz3";
					password = "$2y$05$Nllpj7aU4lQTwKQgnUJPm.vgeApQc.lAIAXJnNn2BcLujixojBVTO";
				};
				devices = {
					"phone" = {
						id = "MBZANWQ-YQOKUA7-MXL7EU2-EDJBHEE-PXMCWQN-XOVRJYL-ZQAWFSB-ACVH7A3";

					};
					"desktop" = {
						id = "WBNFUAJ-KALDUUK-67TUT4R-D65O75B-3ZVT6YG-27NWAKT-GRMXKTB-HOUNZAF";
					};
				};
				folders = {
					"Uni" = {
						id = "glkx4-dw2vf";
						path = "${config.xdg.userDirs.documents}/Uni";
						devices = [
							"phone"
							"desktop"
						];
						versioning.type = "trashcan";
					};
					"KeePass" = {
						id = "5tfdw-tzmzk";
						path = "${config.xdg.userDirs.documents}/KeePass";
						devices = [
							"phone"
							"desktop"
						];
						versioning.type = "staggered";
					};
					"Obsidian" = {
						id = "mhxhh-nvzhp";
						path = "${config.xdg.userDirs.documents}/Obsidian";
						devices = [
							"phone"
							"desktop"
						];
						versioning.type = "trashcan";
					};
					"GDrive" = {
						id = "d7nn3-hqmcd";
						path = "${config.xdg.userDirs.documents}/GDrive";
						devices = [
							"desktop"
						];
						versioning.type = "trashcan";
					};
				};
			};
		};
	};

	wayland.windowManager.hyprland = {
		enable = true;
		package = hyprlandPkgs;
		portalPackage = hyprPortalPkgs;
		xwayland.enable = true;

		settings = {
			"$mod" = "SUPER";
			"$menu" = "rofi -show drun";
			"$terminal" = "kitty";
			"$fileManager" = "yazi";
			"$browser" = "librewolf";
			"ecosystem:no_update_news" = true;
		
			bind = [
				"$mod, r, exec, $menu"
				"$mod, q, exec, $terminal"
				"$mod, c, killactive"
				''$mod, s, exec, grim -g "$(slurp)" - | wl-copy -t image/png''
				"$mod, l, exec, hyprlock"
				"$mod, f, fullscreen"
				"$mod, v, exec, stash list | rofi -dmenu | stash decode | wl-copy"
				# screenshot 
 				'', Print, exec, grim -g "$(slurp)" - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of the region taken" -t 1000'' # screenshot of a region 
 				''SHIFT, Print, exec, grim - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of whole screen taken" -t 1000'' # screenshot of the whole screen
			];
			input = {
				kb_layout = "de";

				follow_mouse = "1";

				sensitivity = "0";

				touchpad = {
					natural_scroll = true;
				};
			};

			windowrule = [
				"match:class $browser, workspace 2"
			];

			exec-once = [
				"awww-daemon"
				"systemctl --user start hyprpolkitagent"
				"dunst"
				"wl-paste --watch cliphist store"
				"$terminal"
				"$browser"
				"waybar"
			];
		};

		# Default Config:
		extraConfig = ''
			# This is an example Hyprland config file.
			# Refer to the wiki for more information.
			# https://wiki.hypr.land/Configuring/

			# Please note not all available settings / options are set here.
			# For a full list, see the wiki

			# You can split this configuration into multiple files
			# Create your files separately and then link them to this file like this:
			# source = ~/.config/hypr/myColors.conf


			################
			### MONITORS ###
			################

			# See https://wiki.hypr.land/Configuring/Monitors/
			monitor=,preferred,auto,auto


			###################
			### MY PROGRAMS ###
			###################

			# See https://wiki.hypr.land/Configuring/Keywords/

			# Set programs that you use


			#################
			### AUTOSTART ###
			#################

			# Autostart necessary processes (like notifications daemons, status bars, etc.)
			# Or execute your favorite apps at launch like this:

			# exec-once = $terminal
			# exec-once = nm-applet &
			# exec-once = waybar & hyprpaper & firefox


			#############################
			### ENVIRONMENT VARIABLES ###
			#############################

			# See https://wiki.hypr.land/Configuring/Environment-variables/

			env = XCURSOR_SIZE,24
			env = HYPRCURSOR_SIZE,24


			###################
			### PERMISSIONS ###
			###################

			# See https://wiki.hypr.land/Configuring/Permissions/
			# Please note permission changes here require a Hyprland restart and are not applied on-the-fly
			# for security reasons

			# ecosystem {
			#   enforce_permissions = 1
			# }

			# permission = /usr/(bin|local/bin)/grim, screencopy, allow
			# permission = /usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow
			# permission = /usr/(bin|local/bin)/hyprpm, plugin, allow


			#####################
			### LOOK AND FEEL ###
			#####################

			# Refer to https://wiki.hypr.land/Configuring/Variables/

			# https://wiki.hypr.land/Configuring/Variables/#general
			general {
				gaps_in = 2
				gaps_out = 5

				border_size = 2

				# https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
				col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
				col.inactive_border = rgba(595959aa)

				# Set to true enable resizing windows by clicking and dragging on borders and gaps
				resize_on_border = false

				# Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
				allow_tearing = false

				layout = dwindle
			}

			# https://wiki.hypr.land/Configuring/Variables/#decoration
			decoration {
				rounding = 10
				rounding_power = 2

				# Change transparency of focused and unfocused windows
				active_opacity = 1.0
				inactive_opacity = 1.0

				shadow {
					enabled = true
					range = 4
					render_power = 3
					color = rgba(1a1a1aee)
				}

				# https://wiki.hypr.land/Configuring/Variables/#blur
				blur {
					enabled = true
					size = 3
					passes = 1

					vibrancy = 0.1696
				}
			}

			# https://wiki.hypr.land/Configuring/Variables/#animations
			animations {
				enabled = yes, please :)

				# Default curves, see https://wiki.hypr.land/Configuring/Animations/#curves
				#        NAME,           X0,   Y0,   X1,   Y1
				bezier = easeOutQuint,   0.23, 1,    0.32, 1
				bezier = easeInOutCubic, 0.65, 0.05, 0.36, 1
				bezier = linear,         0,    0,    1,    1
				bezier = almostLinear,   0.5,  0.5,  0.75, 1
				bezier = quick,          0.15, 0,    0.1,  1

				# Default animations, see https://wiki.hypr.land/Configuring/Animations/
				#           NAME,          ONOFF, SPEED, CURVE,        [STYLE]
				animation = global,        1,     10,    default
				animation = border,        1,     5.39,  easeOutQuint
				animation = windows,       1,     4.79,  easeOutQuint
				animation = windowsIn,     1,     4.1,   easeOutQuint, popin 87%
				animation = windowsOut,    1,     1.49,  linear,       popin 87%
				animation = fadeIn,        1,     1.73,  almostLinear
				animation = fadeOut,       1,     1.46,  almostLinear
				animation = fade,          1,     3.03,  quick
				animation = layers,        1,     3.81,  easeOutQuint
				animation = layersIn,      1,     4,     easeOutQuint, fade
				animation = layersOut,     1,     1.5,   linear,       fade
				animation = fadeLayersIn,  1,     1.79,  almostLinear
				animation = fadeLayersOut, 1,     1.39,  almostLinear
				animation = workspaces,    1,     1.94,  almostLinear, fade
				animation = workspacesIn,  1,     1.21,  almostLinear, fade
				animation = workspacesOut, 1,     1.94,  almostLinear, fade
				animation = zoomFactor,    1,     7,     quick
			}

			# Ref https://wiki.hypr.land/Configuring/Workspace-Rules/
			# "Smart gaps" / "No gaps when only"
			# uncomment all if you wish to use that.
			# workspace = w[tv1], gapsout:0, gapsin:0
			# workspace = f[1], gapsout:0, gapsin:0
			# windowrule {
			#     name = no-gaps-wtv1
			#     match:float = false
			#     match:workspace = w[tv1]
			#
			#     border_size = 0
			#     rounding = 0
			# }
			#
			# windowrule {
			#     name = no-gaps-f1
			#     match:float = false
			#     match:workspace = f[1]
			#
			#     border_size = 0
			#     rounding = 0
			# }

			# See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more
			dwindle {
				pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
				preserve_split = true # You probably want this
			}

			# See https://wiki.hypr.land/Configuring/Master-Layout/ for more
			master {
				new_status = master
			}

			# https://wiki.hypr.land/Configuring/Variables/#misc
			misc {
				force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
				disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
			}


			#############
			### INPUT ###
			#############

			# See https://wiki.hypr.land/Configuring/Gestures
			gesture = 3, horizontal, workspace

			# Example per-device config
			# See https://wiki.hypr.land/Configuring/Keywords/#per-device-input-configs for more
			device {
				name = epic-mouse-v1
				sensitivity = -0.5
			}


			###################
			### KEYBINDINGS ###
			###################

			# See https://wiki.hypr.land/Configuring/Keywords/
			$mainMod = SUPER # Sets "Windows" key as main modifier

			# Example binds, see https://wiki.hypr.land/Configuring/Binds/ for more
			bind = $mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit
			bind = $mainMod, E, exec, $fileManager
			bind = $mainMod, P, pseudo, # dwindle
			bind = $mainMod, J, layoutmsg, togglesplit # dwindle

			# Move focus with mainMod + arrow keys
			bind = $mainMod, left, movefocus, l
			bind = $mainMod, right, movefocus, r
			bind = $mainMod, up, movefocus, u
			bind = $mainMod, down, movefocus, d

			# Switch workspaces with mainMod + [0-9]
			bind = $mainMod, 1, workspace, 1
			bind = $mainMod, 2, workspace, 2
			bind = $mainMod, 3, workspace, 3
			bind = $mainMod, 4, workspace, 4
			bind = $mainMod, 5, workspace, 5
			bind = $mainMod, 6, workspace, 6
			bind = $mainMod, 7, workspace, 7
			bind = $mainMod, 8, workspace, 8
			bind = $mainMod, 9, workspace, 9
			bind = $mainMod, 0, workspace, 10

			# Move active window to a workspace with mainMod + SHIFT + [0-9]
			bind = $mainMod SHIFT, 1, movetoworkspace, 1
			bind = $mainMod SHIFT, 2, movetoworkspace, 2
			bind = $mainMod SHIFT, 3, movetoworkspace, 3
			bind = $mainMod SHIFT, 4, movetoworkspace, 4
			bind = $mainMod SHIFT, 5, movetoworkspace, 5
			bind = $mainMod SHIFT, 6, movetoworkspace, 6
			bind = $mainMod SHIFT, 7, movetoworkspace, 7
			bind = $mainMod SHIFT, 8, movetoworkspace, 8
			bind = $mainMod SHIFT, 9, movetoworkspace, 9
			bind = $mainMod SHIFT, 0, movetoworkspace, 10

			# Example special workspace (scratchpad)
			bind = $mainMod, S, togglespecialworkspace, magic
			bind = $mainMod SHIFT, S, movetoworkspace, special:magic

			# Scroll through existing workspaces with mainMod + scroll
			bind = $mainMod, mouse_down, workspace, e+1
			bind = $mainMod, mouse_up, workspace, e-1

			# Move/resize windows with mainMod + LMB/RMB and dragging
			bindm = $mainMod, mouse:272, movewindow
			bindm = $mainMod, mouse:273, resizewindow

			# Laptop multimedia keys for volume and LCD brightness
			bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
			bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
			bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
			bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
			bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
			bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

			# Requires playerctl
			bindl = , XF86AudioNext, exec, playerctl next
			bindl = , XF86AudioPause, exec, playerctl play-pause
			bindl = , XF86AudioPlay, exec, playerctl play-pause
			bindl = , XF86AudioPrev, exec, playerctl previous

			##############################
			### WINDOWS AND WORKSPACES ###
			##############################

			# See https://wiki.hypr.land/Configuring/Window-Rules/ for more
			# See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

			# Example windowrules that are useful

			windowrule {
				# Ignore maximize requests from all apps. You'll probably like this.
				name = suppress-maximize-events
				match:class = .*

				suppress_event = maximize
			}

			windowrule {
				# Fix some dragging issues with XWayland
				name = fix-xwayland-drags
				match:class = ^$
				match:title = ^$
				match:xwayland = true
				match:float = true
				match:fullscreen = false
				match:pin = false

				no_focus = true
			}

			# Hyprland-run windowrule
			windowrule {
				name = move-hyprland-run

				match:class = hyprland-run

				move = 20 monitor_h-120
				float = yes
			}
			'';
	};
	
	home.pointerCursor = {
		gtk.enable = true;
		package = pkgs.bibata-cursors;
		name = "Bibata-Modern-Classic";
		size = 16;
	};
	
	gtk = {
		enable = true;
		theme = {
			package = pkgs.flat-remix-gtk;
			name = "Flat-Remix-GTK-Grey-Darkest";
		};
		iconTheme = {
			package = pkgs.adwaita-icon-theme;
			name = "Adwaita";
		};
		font = {
			name = "Sans";
			size = 11;
		};
	};
}
