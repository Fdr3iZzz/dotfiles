# dotfiles
Test dotfiles for NixOS ~~in a VM~~

# Wanted on Desktop/ Waybar:

### Essential Waybar:
- time
- date
- battery
- network status
- volume
- notification count
- work mode toggle status
- current selected workspace
- applications on workspace
- time
- date
- power
- brightness/ backlight
- network info (e.g. connection type, network name, ip)
- bluetooth
- volume
- storage
- cpu load
- memory
- system temperature
- weather
- music
- keyboard lang
- keyboard state (e.g. caps, numblock, fn lock)
- system tray
- power profile
- 

# ToDo:

- [x] switch from alaccritty to kitty for better yazi support (preview)
- [x] replace cliphist with ~~[clipvault](https://github.com/rolv-apneseth/clipvault)~~ chose [stash](https://github.com/notashelf/stash) instead
    - [ ] fix image preview not working with rofi
    - [ ] exclude KeePassXC from clipboard history
- [ ] customize waybar
- [ ] fix multi monitor setup
- [ ] move hyprland config to home manager
- [ ] notification for low battery, audio volume change and brightness change
- [x] fix swap to allow hibernation
- [ ] librewolf extensions
    - [x] install extensions
    - [x] auto configure (sponsorblock, keepassxc)
    - [ ] order toolbar
- [x] search engine
- [x] fix librewolf not opening folder
- [ ] neovim
- [x] syncthing
- [ ] add things to menu launcher (rofi)
    - bluetui
    - nmtui
    - wifi captive portal (http://neverssl.com/)
    - ``sudo nixos-rebuild switch --flake ~/nixos/config#desktop`` (nh os switch)
    - ``nix flake update --flake ~/nixos-config``
    - ``nix-collect-garbage --delete-older-than 30d`` (nh clean all)
    - wallpaper switcher
- [ ] change discord extension settings
- [ ] install and set up jetbrains ide's
- [ ] install logic works, assembler etc. using wine (or proton/ similar)
- [ ] configure obsidian
- [ ] configure texStudio (or better alternative, e.g. vim)
- [ ] configure keepassxc
- [ ] configure zathura (zoom with vim, return to default zoom)
- [ ] configure yazi

# Finishing Touches:

- [ ] theming
    - [ ] color schemes based on wallpaper
    - [ ] icons
    - [ ] font
    - [ ] hyprland margins/ borders
- [ ] add keybindings to Hyprland to make it more usable
- [ ] install all needed applications
- [ ] clean up configs
- [ ] stream line android file transfer and general mounting

# Advanced:
- [ ] use existing pub/priv key for syncthing to obtain static device id to rename device (https://github.com/Mic92/sops-nix)

# Maybe:

- [ ] switch to [hjme](https://github.com/feel-co/hjem) and [hjme-impure](https://github.com/Rexcrazy804/hjem-impure) (for faster dev)
- [ ] replace KeePassXC with e.g. pass + rofi
    - [ ] how to handle otp/ extra info/ hardware key support