#!/bin/bash

ntfss=$(blkid -c /dev/null -t TYPE=ntfs | cut -d ':' -f 1 >> /tmp/hdd.txt)
vfats=$(blkid -c /dev/null -t TYPE=vfat | cut -d ':' -f 1 >> /tmp/hdd.txt)
ext3=$(blkid -c /dev/null -t TYPE=ext3 | cut -d ':' -f 1 >> /tmp/hdd.txt)
ext4=$(blkid -c /dev/null -t TYPE=ext4 | cut -d ':' -f 1 >> /tmp/hdd.txt)

while read curline; do
	echo Mount $curline
	dirr=$(echo $curline | cut -c 6- | sed -e 's/\///g')
	mkdir /media/disk-$dirr > /dev/null 2>&1 &
	mount /dev/$dirr /media/disk-$dirr > /dev/null 2>&1 &
	ntfslabel=$(blkid -c /dev/null -t TYPE=ntfs | grep $curline | grep LABEL)
	if [ $ntfslabel ]; then
	ntfsuuid=$(blkid -c /dev/null -t TYPE=ntfs | grep $curline | cut -d '"' -f 4)
	else
	ntfsuuid=$(blkid -c /dev/null -t TYPE=ntfs | grep $curline | cut -d '"' -f 2)
	fi
echo $ntfsuuid 
done < /tmp/hdd.txt
rm /tmp/hdd.txt
echo Mount Local Disk Done!


