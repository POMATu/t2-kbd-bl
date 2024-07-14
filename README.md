Keyboard backlight controls workaround for gnome + maintaining same level of backlight across suspend and reboots (all in one because everything is related here)

# installing python library
pacman -S python-pydbus

# preparations

change /home/user everywhere to the path where this folder is in

# standalone Gnome fix

mkdir -p ~/.config/systemd/user/

### place that file to this path
~/.config/systemd/user/gnome-dbus-fix.service

### enable

```
systemctl --user enable gnome-dbus-fix.service
systemctl --user restart gnome-dbus-fix.service
systemctl --user status gnome-dbus-fix.service
```

After this your keyboard backlight gonna work regardless of whether gnome controls work or got bugged out

# Unfucking touchbar on boot unconditionally 

(Only works with old apple-touchbar driver, NOT tiny-dfr)

### place the file 
/etc/systemd/system/touchbar-poke.service

### execute as root

```
sudo su
systemctl enable touchbar-poke.service
systemctl restart touchbar-poke.service
systemctl status touchbar-poke.service
```

You should see your touchbar reload, now this service gonna start every boot. Your kbd brightness will stay same across reboot. If you want brightness to not persist across reboot then change backup file from `/home/user/.kbdbl` to `/tmp/.kbdbl`

# Unfucking touchbar on suspend + restoring keyboard brightness state

this is just upgraded suspend-fix-t2.service that also reloads touchbar correctly (tested on MBP 2019 16,1 and archlinux) and restores kbd brightness 

### place the file 
/etc/systemd/system/suspend-fix-t2.service

### execute as root
```
sudo su
systemctl enable suspend-fix-t2.service
systemctl restart suspend-fix-t2.service
systemctl status suspend-fix-t2.service
```
now try suspend and see its working
