#!/bin/bash
usermod -s /bin/bash root

groupadd --gid 1000 arcade
useradd --uid 1000 --gid 1000 --create-home --home-dir /home/arcade --shell /bin/bash --groups adm,audio,disk,games,input,log,network,nobody,optical,power,storage,tty,users,video,wheel arcade
echo -e "arcade\narcade" | passwd arcade
sed -i "/^# .*wheel.*NOPASSWD.*/s/^# //" /etc/sudoers

chown arcade:nobody /home/arcade
chmod 755 /home/arcade
chmod 700 /home/arcade/.ssh

chown -R arcade:nobody /home/roms
chmod -R 777 /home/roms

systemctl enable smb
systemctl enable nmb
systemctl enable sshd
