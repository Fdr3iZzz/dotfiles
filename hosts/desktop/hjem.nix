# hjem.nix
{ pkgs, user, ... }:

{
  users.users.${user}.packages = with pkgs; [
    xdg-desktop-portal-termfilechooser
  ];

  hjem.users.${user} = {
    xdg.config.files."xdg-desktop-portal-termfilechooser/config" = {
      text = ''
        [filechooser]
        cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
        env=TERMCMD=kitty -T "terminal filechooser"
      '';
    };
    xdg.config.files."xdg-desktop-portal/portals.conf" = {
      text = ''
        [preferred]
        default=gtk
        org.freedesktop.impl.portal.FileChooser=termfilechooser
      '';
    };
  };
}