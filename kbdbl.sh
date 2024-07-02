#!/bin/bash

# path to your kbd brightness device
DEVICE="/sys/class/leds/:white:kbd_backlight/brightness"

# if you have passwordless sudo you can uncomment sudo below otherwise you need to setup udev rules to allow your user to control brightness
#if you dont need sudo - comment the following line
#SUDO="sudo"

MIN=0
MAX=14660
STEPS=4

# Calculate step size
STEP=$(( ($MAX - $MIN) / $STEPS ))

if [ -z "$1" ]; then
	echo Usage:
	echo kbdbl.sh up - sets keyboard light up one step
	echo kbdbl.sh down - sets keyboard light down one step
exit 255
fi


if [ ! -f "$DEVICE" ]; then
	echo "No such device found (yet): $DEVICE"
	exit 1
fi

echo "Step size: $STEP"

if [ "$1" = "up" ]; then
	CUR=$(cat "$DEVICE")
	echo "Current: $CUR"
	NEXT=$(($CUR + $STEP))
	echo "Next: $CUR"
	echo $NEXT | $SUDO tee "$DEVICE"
	exit $?
fi

if [ "$1" = "down" ]; then
	CUR=$(cat "$DEVICE")
	echo "Current: $CUR"
	NEXT=$(($CUR - $STEP))
	if [ "$NEXT" -lt 0 ]; then
		NEXT=0
	fi
	echo "Next: $CUR"
	echo $NEXT | $SUDO tee "$DEVICE"
	exit $?
fi

