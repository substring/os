#!/bin/bash

if [ $2 = "Mame" ] 
	then
		romsfile=$(grep -r 'rompath.*' /home/arcade/mame.ini)
		romsfileume=$(grep -r 'rompath.*' /home/arcade/mame.ini)
		romsf="$romsfile$1;"
		romsfume="$romsfileume$1;"
		sed -ri "s@^rompath.*@$romsf@g" /home/arcade/mame.ini
		sed -ri "s@^rompath.*@$romsfume@g" /home/arcade/mame.ini
		romsfile=$(grep -r 'emulator_roms "MAME.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"MAME.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/MAME.cfg
	
	elif [ $2 = "UME-BIOS" ] 
	then
		romsfileume=$(grep -r 'rompath.*' /home/arcade/mame.ini)
		romsfume="$romsfileume$1;"
		sed -ri "s@^rompath.*@$romsfume@g" /home/arcade/mame.ini
				
	elif [ $2 = "Snes" ] 
	then
		romsfile=$(grep -r 'emulator_roms "SNES.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"SNES.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/SNES.cfg
		
	elif [ $2 = "N64" ] 
	then
		romsfile=$(grep -r 'emulator_roms "N64.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"N64.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/N64.cfg

	elif [ $2 = "Nes" ] 
	then
		romsfile=$(grep -r 'emulator_roms "NES.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"NES.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/NES.cfg

	elif [ $2 = "Mg/Gs" ] 
	then
		romsfile=$(grep -r 'emulator_roms "SegaGenesis.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"SegaGenesis.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/SegaGenesis.cfg

	elif [ $2 = "Ms" ] 
	then
		romsfile=$(grep -r 'emulator_roms "MasterSystem.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"MasterSystem.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/MasterSystem.cfg

	elif [ $2 = "Atari" ] 
	then
		romsfile=$(grep -r 'emulator_roms "Atari.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"Atari.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/Atari2600.cfg
	
	elif [ $2 = "UME-Snes" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-SNES.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-SNES.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-SNES.cfg

	elif [ $2 = "UME-N64" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-N64.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-N64.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-N64.cfg

	elif [ $2 = "UME-Nes" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-NES.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-NES.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-NES.cfg

	elif [ $2 = "UME-Mg/Gs" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-SegaGenesis.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-SegaGenesis.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-SegaGenesis.cfg
	
	elif [ $2 = "UME-Megacd" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-SegaMegaCD.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-SegaMegaCD.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-SegaMegaCD.cfg
	
	elif [ $2 = "UME-32x" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-Sega32X.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-Sega32X.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-Sega32X.cfg

	elif [ $2 = "UME-Ms" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-MasterSystem.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-MasterSystem.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-MasterSystem.cfg

	elif [ $2 = "UME-Atari" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-Atari.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-Atari.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-Atari2600.cfg

	elif [ $2 = "UME-Psx" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-PSX.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-PSX.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-PSX.cfg
	
	elif [ $2 = "UME-Pce" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-PCEngine-Supergrafx.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-PCEngine-Supergrafx.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-PCEngine-Supergrafx.cfg
	
	elif [ $2 = "UME-3do" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-3DO.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-3DO.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-3DO.cfg

	elif [ $2 = "UME-Saturn" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-Saturn.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-Saturn.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-Saturn.cfg

	elif [ $2 = "Psx" ] 
	then
		romsfile=$(grep -r 'emulator_roms "PSX.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"PSX.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/PSX.cfg

	elif [ $2 = "Pce" ] 
	then
		romsfile=$(grep -r 'emulator_roms "PCEngine-Supergrafx.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"PCEngine-Supergrafx.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/PCEngine-Supergrafx.cfg

	elif [ $2 = "Saturn" ] 
	then
		romsfile=$(grep -r 'emulator_roms "Saturn.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"Saturn.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/Saturn.cfg
	
	elif [ $2 = "UME-Jaguar" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-Jaguar.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-Jaguar.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/Jaguar.cfg
	
	elif [ $2 = "UME-Neocd" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-NeoGeoCDZ.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-NeoGeoCDZ.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-NeoGeoCDZ.cfg
	
	elif [ $2 = "UME-Amigacd" ] 
	then
		romsfile=$(grep -r 'emulator_roms "UME-AmigaCD.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_roms \"UME-AmigaCD.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^rompath.*@rompath              $1/@g"	/home/arcade/.attract/emulators/UME-AmigaCD.cfg
	else
	return
	fi







