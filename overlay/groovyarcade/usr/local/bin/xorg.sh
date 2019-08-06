#!/bin/sh 

check_output()
{
	for karg in $KERNELCMD
	do
		IS_VIDEO=$(echo $karg | grep video=)
		if [ "$IS_VIDEO" != "" ]; then
			IS_THIS=$(echo $karg | grep $NAME)
			if [ "$IS_THIS" != "" ]; then
				return 1
			fi	
		fi
	done
	return 0
}

create_modes()
{
	echo
	echo "Section \"Modes\""
	echo "	Identifier      \"ArcadeModes\""
	switchres --calc 648 480 60 --monitor $MONITOR 2>/dev/null
	echo $MODELINE
	echo "EndSection"
}

#GRUB_FILE=/boot/grub/grub.conf
GRUB_FILE=/boot/syslinux/syslinux.cfg
ALTERNATE_GRUB=$3
VBLAN="#Option \"GLXVBlank\" \"true\""
#Option "GLXVBlank" "true"

PCIIDORIG=$(lspci -v|grep "VGA compatible controller"|head -1|awk {'printf("%s",$1)'})
PCIID=$(echo $PCIIDORIG | sed -e 's/\./:/'|awk {'printf("PCI:%s",$1)'})
if [[ "$(echo $PCIID|cut -d":" -f2,3,4)" =~ [a-fA-F] ]]; then
	a=$((0x$(echo $PCIID| cut -d":" -f2)))
	b=$((0x$(echo $PCIID| cut -d":" -f3)))
	c=$((0x$(echo $PCIID| cut -d":" -f4)))
		if [[ "$a" == [0-90-9] ]]; then
		a=0$a
		fi
       		if [[ "$b" == [0-90-9] ]]; then
		b=0$b
		fi
	PCIID=PCI:$a:$b:$c
fi

ALLDEVICES=$(find /sys/devices/pci0000\:00/ -iname card\*-\*)
for line in $ALLDEVICES
do
	WORDS=$(echo "$line" | sed -e 's/\// /g')
	START=0
	for dev in $WORDS
	do
		IS_DEV=$(echo $dev | grep card[0-9]-)
		if [ "$START" = "1" -a "$IS_DEV" != "" ]; then
			THISDEV=$(echo $dev | sed -e 's/card[0-9]-//g')
			if [ "$DEVICES" = "" ]; then
				DEVICES="${THISDEV}_${PCIID}"
			else
				DEVICES="$DEVICES ${THISDEV}_${PCIID}"
			fi
		fi
		if [ "$dev" = "0000:$PCIIDORIG" ]; then
			START=1
		fi
	done
done

mount -a -t ext2
if [ -f "$ALTERNATE_GRUB" ]; then
	KERNELCMD=$(cat $ALTERNATE_GRUB | grep -v ^\# | grep -i "APPEND " | head -1)
elif [ -f "/boot/syslinux/syslinux.cfg" ]; then
	KERNELCMD=$(cat $GRUB_FILE | grep -v ^\# | grep -i "APPEND " | head -1)
else
	KERNELCMD=$(cat /proc/cmdline)
fi

HAS_VIDEO=$(echo $KERNELCMD | grep video=)
MONITOR=$1
INTERFACE=$2
if [ "$HAS_VIDEO" = "" -a "$INTERFACE" = "" ]; then
	# No video interface setup with 15khz
	echo "# No video= in kernel command line, assuming multisync SVGA"
	#echo "$VBLAN"
	exit
fi

if [ "$MONITOR" = "" ]; then
	MONITOR=generic
elif [ "$MONITOR" = "multi" -a "$INTERFACE" = "" ]; then
	# Let xorg decide for multisync monitors
	echo "# Multisync SVGA monitor doesn't need a config"
	exit
fi

if [ "$INTERFACE" = "" ]; then
	INTERFACE=ALL
else
	#KERNELCMD="video=${INTERFACE}"
	echo "# Interface $INTERFACE specified"
fi

#VBLAN="#Option \"GLXVBlank\" \"true\""
DRIVER=radeon
LSPCI=$(lspci -v | grep $PCIIDORIG)
IS_RAGE=$(echo $LSPCI | grep -i " Rage 128 ")
IS_ATI=$(echo $LSPCI | grep -i "amd/ati")
IS_NVIDIA=$(echo $LSPCI | grep -i " nvidia ")
IS_INTEL=$(echo $LSPCI | grep -i " intel ")
IS_MGA=$(echo $LSPCI | grep -i " mga ")
if [ "$IS_RAGE" != "" ]; then
	DRIVER=r128
elif [ "$IS_ATI" != "" ]; then
	DRIVER=radeon
elif [ "$IS_NVIDIA" != "" ]; then
	DRIVER=nouveau
	VBLAN="Option \"GLXVBlank\" \"true\""
elif [ "$IS_INTEL" != "" ]; then
	DRIVER=intel
elif [ "$IS_MGA" != "" ]; then
	DRIVER=mga
else
	echo "# Unsupported video card!!!"
	exit
fi

MONITORS=
for device in $DEVICES
do
	NAME=$(echo $device | awk -F _ {'print $1'})
	PCIID=$(echo $device | awk -F _ {'print $2'})
	#echo "$NAME $PCIID"
	if ! check_output ; then
		XNAME=
		if [ "$NAME" = "DVI-I-1" ]; then
			XNAME=DVI-0
		elif [ "$NAME" = "DVI-I-2" ]; then
			XNAME=DVI-1
		elif [ "$NAME" = "VGA-1" ]; then
			XNAME=VGA-0
		elif [ "$NAME" = "VGA-2" ]; then
			XNAME=VGA-1
		fi

		if [ "$MONITOR" = "" ]; then
			MONITORS="$XNAME"
		else
			MONITORS="$MONITORS $XNAME"
		fi
	fi
done

echo "# Config for $MONITOR Monitor and $DRIVER Video Card"

for monitor in $MONITORS
do
	echo
	echo "Section \"ServerLayout\""
	echo "	Identifier \"General\""
	echo "	Screen	0	\"Screen0\" 0 0"
	echo "	InputDevice	\"WiiMote0\""
	echo "	InputDevice	\"WiiMote1\""
	echo "EndSection"
	echo
	echo "Section \"InputDevice\""
	echo "	Identifier \"WiiMote0\""
	echo "	Driver \"evdev\""
	echo "	Option \"Device\" \"/dev/input/event7\""
	echo "	Option \"SendCoreEvents\" \"True\""
	echo "EndSection"
	echo
	echo "Section \"InputDevice\""
	echo "	Identifier \"WiiMote1\""
	echo "	Driver \"evdev\""
	echo "	Option \"Device\" \"/dev/input/event8\""
	echo "	Option \"SendCoreEvents\" \"True\""
	echo "EndSection"
	echo

	echo
	echo "Section	\"Monitor\""
	echo "	Identifier	\"$monitor\""
	echo "	VendorName	\"Unknown\""
	echo "	ModelName	\"Unknown\""
	echo
	echo "	HorizSync	15-50"
	echo "	VertRefresh	40-80"
	echo
	echo "	Option		\"DPMS\"	\"False\""
	echo
	echo "	Option		\"DefaultModes\"	\"False\""
	echo "	UseModes        \"ArcadeModes\""
	echo "EndSection"
done

echo
echo "Section \"Device\""
echo "	Identifier	\"Card0\""
echo "	VendorName	\"Unknown\""
echo "	BoardName	\"Unknown\""
echo
echo "	Driver		\"$DRIVER\""
echo "  	$VBLAN"
echo "	#Option		\"ShadowPrimary\"	\"on\""
echo "	BusID		\"${PCIID}\""
echo
echo "	Option		\"ModeDebug\"	\"true\""
echo 
#echo "	Option          \"monitor-DVI-0\" \"DVI-0\"
#	Option          \"monitor-DVI-1\" \"DVI-0\"
#	Option          \"monitor-DVI-2\" \"DVI-0\"
#	Option          \"monitor-VGA-0\" \"VGA-0\"
#	Option          \"monitor-VGA-1\" \"VGA-0\"
#	Option          \"monitor-VGA-2\" \"VGA-0\"
#"

for monitor in $MONITORS
do
	echo "	Option		\"monitor-${monitor}\"	\"${monitor}\""
done
echo "EndSection"

# Screen Section
NUMBER=0
for monitor in $MONITORS
do
echo "
Section \"Screen\"
        Identifier \"Screen${NUMBER}\"
        Device     \"Card0\"
        Monitor    \"$monitor\"
        DefaultDepth    24
        SubSection \"Display\"
                Viewport   0 0
                Depth     8
        EndSubSection
        SubSection \"Display\"
                Viewport   0 0
                Depth     16
        EndSubSection
        SubSection \"Display\"
                Viewport   0 0
                Depth     24
        EndSubSection
	EndSection
"
NUMBER=$(expr $NUMBER + 1)
done

# Print out modeline
create_modes
#/boot/grub/grub.conf
