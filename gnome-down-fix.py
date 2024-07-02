#!/usr/bin/env python3

from pydbus import SessionBus
from gi.repository import GLib
import subprocess

def handle_signal(*args):
    print("D-Bus signal received:", args)
    subprocess.run("/home/user/t2-kbd-bl/kbdbl.sh down", shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

bus = SessionBus()
loop = GLib.MainLoop()

# Adjust the interface and signal name as needed
bus.subscribe(iface="org.gnome.SettingsDaemon.Power.Keyboard", signal="BrightnessChanged", signal_fired=handle_signal)

try:
    loop.run()
except KeyboardInterrupt:
    loop.quit()
