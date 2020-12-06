#!/bin/bash
#emulator_altss "mame" "/home/roms/snaps"
if [ $2 = "Mame" ] 
	then
		romsfile=$(grep -r 'emulator_altss "MAME.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"MAME.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/MAME.cfg

	elif [ $2 = "Snes" ] 
	then
		romsfile=$(grep -r 'emulator_altss "SNES.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"SNES.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/SNES.cfg

	elif [ $2 = "N64" ] 
	then
		romsfile=$(grep -r 'emulator_altss "N64.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"N64.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/N64.cfg

	elif [ $2 = "Nes" ] 
	then
		romsfile=$(grep -r 'emulator_altss "NES.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"NES.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/NES.cfg

	elif [ $2 = "Mg/Gs" ] 
	then
		romsfile=$(grep -r 'emulator_altss "SegaGenesis.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"SegaGenesis.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/SegaGenesis.cfg

	elif [ $2 = "Ms" ] 
	then
		romsfile=$(grep -r 'emulator_altss "MasterSystem.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"MasterSystem.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/MasterSystem.cfg

	elif [ $2 = "Atari" ] 
	then
		romsfile=$(grep -r 'emulator_altss "Atari.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"Atari.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/Atari2600.cfg

	elif [ $2 = "UME-Snes" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-SNES.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-SNES.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-SNES.cfg

	elif [ $2 = "UME-N64" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-N64.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-N64.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-N64.cfg

	elif [ $2 = "UME-Nes" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-NES.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-NES.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-NES.cfg

	elif [ $2 = "UME-Mg/Gs" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-SegaGenesis.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-SegaGenesis.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-SegaGenesis.cfg

	elif [ $2 = "UME-Megacd" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-SegaMegaCD.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-SegaMegaCD.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-SegaMegaCD.cfg

	elif [ $2 = "UME-32x" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-Sega32X.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-Sega32X.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UUME-Sega32X.cfg

	elif [ $2 = "UME-Ms" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-Coleco.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-Coleco.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-MasterSystem.cfg

	elif [ $2 = "UME-Atari" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-Atari.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-Atari.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-Atari2600.cfg
		
elif [ $2 = "UME-Psx" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-PSX.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-PSX.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-PSX.cfg
	
	elif [ $2 = "UME-Pce" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-PCEngine-Supergrafx.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-PCEngine-Supergrafx.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-PCEngine-Supergrafx.cfg
	
	elif [ $2 = "UME-3do" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-3DO.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-3DO.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-3DO.cfg

	elif [ $2 = "UME-Saturn" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-Saturn.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-Saturn.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-Saturn.cfg

	elif [ $2 = "Psx" ] 
	then
		romsfile=$(grep -r 'emulator_altss "PSX.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"PSX.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/PSX.cfg

	elif [ $2 = "Pce" ] 
	then
		romsfile=$(grep -r 'emulator_altss "PCEngine-Supergrafx.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"PCEngine-Supergrafx.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/PCEngine-Supergrafx.cfg

	elif [ $2 = "Saturn" ] 
	then
		romsfile=$(grep -r 'emulator_altss "Saturn.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"Saturn.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/Saturn.cfg
		
	elif [ $2 = "UME-Jaguar" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-Jaguar.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-Jaguar.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-Jaguar.cfg
		
	elif [ $2 = "UME-Neocd" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-NeoGeoCDZ.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-NeoGeoCDZ.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-NeoGeoCDZ.cfg
	
	elif [ $2 = "UME-Amigacd" ] 
	then
		romsfile=$(grep -r 'emulator_altss "UME-AmigaCD.*' /home/arcade/.advance/advmenup.rc | sed 's/.$//g')
		romsf="$romsfile\:$1"\"
		sed -ri "s@^emulator_altss \"UME-AmigaCD.*@$romsf@g" /home/arcade/.advance/advmenup.rc
		sed -ri "s@^artwork    screen.*@artwork    screen              $1/@g"	/home/arcade/.attract/emulators/UME-AmigaCD.cfg
				
	else
	return
	fi
