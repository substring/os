#
# ~/.bash_profile
#

export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
MYTTY=$(tty)

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ "$MYTTY" = "/dev/tty1" ]; then
    systemctl --user daemon-reload && systemctl --user enable udiskie
    sudo setterm -powerdown 0 -powersave off -blank 0
    # Only autoconfigure if no screen was set yet
    grep -qE "monitor=.+" /home/arcade/shared/configs/ga.conf || sudo sh -c 'source /opt/gatools/video/video.sh && auto_configure'
    sudo gasetup
fi
