#!/bin/bash

search_device() {
# path to your kbd brightness device
for i in /sys/class/leds/:white:kbd_backlight/brightness \
         /sys/class/leds/apple::kbd_backlight/brightness
do
  if [[ -f ${i} ]]
  then
  DEVICE=${i}
  fi
done
}

search_device

# if you have passwordless sudo you can uncomment sudo below otherwise you need to setup udev rules to allow your user to control brightness
#if you dont need sudo - comment the following line
SUDO="sudo"

MIN=0
MAX=14660
STEPS=4
BACKUP=/tmp/kbd.bl

# Calculate step size
STEP=$(( ($MAX - $MIN) / $STEPS ))

if [ -z "$1" ]; then
	echo Usage:
	echo kbdbl.sh up - sets keyboard light up one step
	echo kbdbl.sh down - sets keyboard light down one step
	exit 255
fi


if [ "$1" == "restore" ];
then
echo RESTORING KBD


count=0
while [[ -z "$DEVICE" && $count -lt 5 ]]; do
  echo "Iteration $((count + 1))"
sleep 1
search_device
  ((count++))
done


echo RESTORING KBD to $DEVICE from $BACKUP
cat "$BACKUP"

        if [ -f "$BACKUP" ]; then
                cat "$BACKUP" | $SUDO tee "$DEVICE"
	else
		echo cant find backup
        fi
	exit
fi


if [ ! -f "$DEVICE" ]; then
	echo "No such device found (yet): $DEVICE"
	exit 1
fi


if [ "$1" == "backup" ];
then
        cat "$DEVICE" | tee "$BACKUP"
	exit
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

