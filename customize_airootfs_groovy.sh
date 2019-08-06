#!/bin/bash
usermod -s /bin/bash root

groupadd --gid 1000 arcade
useradd --uid 1000 --gid 1000 --create-home --home-dir /home/arcade --shell /bin/bash --groups adm,audio,disk,games,log,network,nobody,optical,power,storage,tty,users,video,wheel arcade
echo -e "arcade\narcade" | passwd arcade
sed -i "/^# .*wheel.*NOPASSWD.*/s/^# //" /etc/sudoers

chown arcade:nobody /home/arcade
chmod 755 /home/arcade
chown -R arcade:nobody /home/roms
chmod 777 /home/roms
