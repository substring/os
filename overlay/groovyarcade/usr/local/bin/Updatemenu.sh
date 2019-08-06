#!/bin/bash
cd /tmp/
rm updatemenu
wget wget http://mario.groovy.org/GroovyArcade/MameWindows/WindowsATIDrivers/updatemenu
sudo cp updatemenu /opt/gasetup/core/procedures/interactive
pkill gasetup
echo "Reboot Pc or sudo gasetup"
