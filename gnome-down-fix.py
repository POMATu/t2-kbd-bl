#!/usr/bin/env python3

from pydbus import SessionBus
from gi.repository import GLib
import subprocess
import os

def handle_signal(*args):
    print("D-Bus signal received:", args)
    subprocess.run(script_dir + "/kbdbl.sh down", shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

bus = SessionBus()
loop = GLib.MainLoop()

# Adjust the interface and signal name as needed
bus.subscribe(iface="org.gnome.SettingsDaemon.Power.Keyboard", signal="BrightnessChanged", signal_fired=handle_signal)

try:
    script_dir = os.path.dirname(os.path.abspath(__file__))
    loop.run()
except KeyboardInterrupt:
    loop.quit()
