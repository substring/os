export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
MYTTY=$(tty)
if [ "$MYTTY" = "/dev/tty1" ]; then
    sudo setterm -powerdown 0 -powersave off -blank 0
    # Only autoconfigure if no screen was set yet
    grep -qE "monitor=.+" /home/arcade/switchres.conf || sudo sh -c 'source /opt/gatools/video/video.sh && auto_configure'
    sudo gasetup
fi
