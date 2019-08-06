#!/bin/bash
# Author: Ves
# Date: 06/01/12
# Version 0.1
# Created for GroovyArcade
cd /tmp/
rm Groovy* groovy* Update*
clear
echo "Updating GroovyMame"
echo "Actualizando GroovyMame" 
echo "" 

wget http://mario.groovy.org/GroovyArcade/MameWindows/WindowsATIDrivers/UpdateGroovyMame32
ls UpdateGroovyMame32 &>/dev/null
url=`cat $_`
echo ""
echo ""
wget $url 
version=`ls Groovy*`
ls Groovy* 
sudo tar jxvf $version -C /usr/local/bin/

echo "Update Completed to $version"
echo "Actualizacion Terminada a $version"
