export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$PATH
xhost +
xset -dpms
xset s off
xset m 5/2 0

openbox --config-file ~/.config/GAop.xml &
/opt/galauncher/startfe.sh
