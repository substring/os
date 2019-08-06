export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
MYTTY=$(tty)
if [ "$MYTTY" = "/dev/tty1" ]; then
    sudo setterm -powerdown 0 -powersave off -blank 0
    sudo gasetup
fi
