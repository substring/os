#!/bin/bash
clear

function listado(){
clear

dir=$(pwd | sed 's/ /·/g') 

while :
	do
	echo "Select the emulator you want to associate with $valor path:"
	echo "1 MAME"
	echo "2 Super Nintendo"
	echo "3 Nintendo Entertainment System"
	echo "4 Nintendo 64"
	echo "5 Sega Genesis / Megadrive"
	echo "6 Sega Master System"
	echo "7 Atari 2600"
	echo "8 UME - BIOS"
	echo "9 UME - Super Nintendo"
	echo "10 UME - Nintendo Entertainment System"
	echo "11 UME - Nintendo 64"
	echo "12 UME - Sega Genesis / Megadrive"
	echo "13 UME - Sega Master System"
	echo "14 UME - Atari 2600"
	echo "15 Set all paths to default "
	echo "16 Exit"
	echo -n "Enter option: "
	read opcion
	case $opcion in
	1)
		$ejecuta $dir Mame;
		echo "$dir added as MAME "$valor" path";
		sleep 2
		clear;;
	2)
		$ejecuta $dir Snes;
		echo "$dir added as Super Nintendo "$valor" path";
		sleep 2
		clear;;
	3)
		$ejecuta $dir Nes;
		echo "$dir added as Nintendo Entertainment System "$valor" path";
		sleep 2
		clear;;
	4)
		$ejecuta $dir N64;
		echo "$dir added as Nintendo 64 "$valor" path";
		sleep 2
		clear;;
	5)
		$ejecuta $dir Mg/Gs;
		echo "$dir added as Sega Megadrive/Genesis "$valor" path";
		sleep 2
		clear;;
	6)
		$ejecuta $dir Ms;
		echo "$dir added as Sega Master System "$valor" path";
		sleep 2
		clear;;
	7)
		$ejecuta $dir Atari;
		echo "$dir added as Atari 2600 "$valor" path";
		sleep 2
		clear;;
	8)
		$ejecuta $dir UME-Bios;
		echo "$dir added as UME - BIOS "$valor" path";
		sleep 2
		clear;;

	9)
		$ejecuta $dir UME-Snes;
		echo "$dir added as UME - Super Nintendo "$valor" path";
		sleep 2
		clear;;
	10)
		$ejecuta $dir UME-Nes;
		echo "$dir added as UME - Nintendo Entertainment System "$valor" path";
		sleep 2
		clear;;
	11)
		$ejecuta $dir UME-N64;
		echo "$dir added as UME - Nintendo 64 "$valor" path";
		sleep 2
		clear;;
	12)
		$ejecuta $dir UME-Mg/Gs;
		echo "$dir added as UME - Sega Megadrive / Genesis "$valor" path";
		sleep 2
		clear;;
	13)
		$ejecuta $dir UME-Ms;
		echo "$dir added as UME - Sega Master System "$valor" path";
		sleep 2
		clear;;
	14)
		$ejecuta $dir UME-Atari;
		echo "$dir added as UME - Atari 2600 "$valor" path";
		sleep 2
		clear;;
	15)
		sed -ri "s@^rompath.*@rompath                   /home/roms/MAME/roms;@g" /home/arcade/mame.ini;
		sed -ri "s@^rompath.*@rompath                   /home/roms/BIOS_roms;@g" /home/arcade/mame.ini;
		sed -ri "s@^emulator_roms \"MAME.*@emulator_roms \"MAME\" \"/home/roms/MAME/roms\"@g" /home/arcade/.advance/advmenup.rc;
		sed -ri "s@^emulator_roms \"N64.*@emulator_roms \"N64\" \"/home/roms/N64_roms\"@g" /home/arcade/.advance/advmenup.rc;
		sed -ri "s@^emulator_roms \"NES.*@emulator_roms \"NES\" \"/home/roms/NES_roms\"@g" /home/arcade/.advance/advmenup.rc;
		sed -ri "s@^emulator_roms \"SNES.*@emulator_roms \"SNES\" \"/home/roms/SNES_roms\"@g" /home/arcade/.advance/advmenup.rc;
		sed -ri "s@^emulator_roms \"SegaGenesis.*@emulator_roms \"SegaGenesis\" \"/home/roms/SegaGenesis_roms\"@g" /home/arcade/.advance/advmenup.rc;
		sed -ri "s@^emulator_roms \"MasterSystem.*@emulator_roms \"MasterSystem\" \"/home/roms/Master_roms\"@g" /home/arcade/.advance/advmenup.rc;
		sed -ri "s@^emulator_roms \"Atari.*@emulator_roms \"Atari2600\" \"/home/roms/Atari2600_roms\"@g" /home/arcade/.advance/advmenup.rc;

		sed -ri "s@^emulator_roms \"UME-N64.*@emulator_roms \"UME-N64\" \"/home/roms/N64_roms\"@g" /home/arcade/.advance/advmenup.rc;
		sed -ri "s@^emulator_roms \"UME-NES.*@emulator_roms \"UME-NES\" \"/home/roms/NES_roms\"@g" /home/arcade/.advance/advmenup.rc;
		sed -ri "s@^emulator_roms \"UME-SNES.*@emulator_roms \"UME-SNES\" \"/home/roms/SNES_roms\"@g" /home/arcade/.advance/advmenup.rc;
		sed -ri "s@^emulator_roms \"UME-SegaGenesis.*@emulator_roms \"UME-SegaGenesis\" \"/home/roms/SegaGenesis_roms\"@g" /home/arcade/.advance/advmenup.rc;
		sed -ri "s@^emulator_roms \"UME-MasterSystem.*@emulator_roms \"UME-MasterSystem\" \"/home/roms/Master_roms\"@g" /home/arcade/.advance/advmenup.rc;
		sed -ri "s@^emulator_roms \"UME-Atari.*@emulator_roms \"UME-Atari2600\" \"/home/roms/Atari2600_roms\"@g" /home/arcade/.advance/advmenup.rc;
		
		echo "All paths set to default."
		clear;;
	16)
		echo "Bye";
		exit 1;;
	*)

	echo "$opcion is not a valid option.";
	echo "Press any key to continue...";
	read foo;
	clear;;
 esac 
done
}

clear 
while :
	do
	echo "Use current path as ..."
	echo "1 ROM path"
	echo "2 Snap path"
	echo "3 Exit"
	echo -n "Enter option: "
	read opcion
	case $opcion in
	1)
		valor=ROM;
		ejecuta=romdir.sh;
		listado;;
	2)
		valor=Snap;
		ejecuta=snapdir.sh;
		listado;;
	3)
		echo "Bye";
		exit 1;;
	*)

	echo "$opcion is not a valid option.";
	echo "Press any key to continue...";
	read foo;
	clear;;
 esac 
done
