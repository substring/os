export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$PATH
xhost +
xset s noblank
xset m 5/2 0
setxkbmap es
if [ ! -f "/home/arcade/.advance/MAME.xml" ]; then
	xmessage -buttons "" -timeout 5 -center Generating Mame XML Games Database &
	groovymame -listxml > ~/.advance/MAME.xml
fi

openbox --config-file ~/.config/GAop.xml &
advmenu
