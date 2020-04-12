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

# Add a arcade smaba user
(echo "arcade"; echo "arcade") | smbpasswd -s -a arcade

systemctl enable smb
systemctl enable nmb
systemctl enable sshd

# Only build the default initramfs
sed -i "s/^PRESETS=.*/PRESETS=('default')/" /etc/mkinitcpio.d/linux-15khz.preset

# Solve a plymouth bug with systemd 245
# https://github.com/systemd/systemd/issues/15091#issuecomment-598184528
for f in /usr/lib/systemd/system/plymouth-*.service ; do 
  grep -q "RemainAfterExit=yes" "$f" || sudo sed -i "/\[Service\]/a RemainAfterExit=yes" "$f"
done
