pacman -S python-pydbus

~/.config/systemd/user/gnome-dbus-fix.service

systemctl --user enable gnome-dbus-fix.service

systemctl --user restart gnome-dbus-fix.service

systemctl --user status gnome-dbus-fix.service
