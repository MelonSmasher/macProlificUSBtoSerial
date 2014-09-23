#! /bin/bash

SERVER='xbsd.nl'
FILE='http://www.xbsd.nl/pub/osx-pl2303.kext.tgz'

ping -c 1 $SERVER >/dev/null 2>&1
    if [ $? -ne 0 ] ; then
	echo "Unable to contact $SERVER, exiting...";
	exit 1;
    else
        command -v wget >/dev/null 2>&1;
	if [ $? -ne 0 ] ; then
		echo 'wget is not installed please install it with homebrew or macports. Exiting...';
		exit 1;
	else
		if [ "$(id -u)" != "0" ]; then
			echo 'Please run this script as sudo. Exiting...';
			exit 1;
		else
			cd '/tmp';
			echo 'Downloading the driver';
			wget $FILE;
			if [ $? -ne 0 ] ; then
				echo 'Unable to download the driver archive. Exiting...';
				exit 1;
			else
				echo 'Extracting the archive...';
				tar -xf 'osx-pl2303.kext.tgz';
				if [ $? -ne 0 ] ; then
					echo 'Extraction failed! Exiting....';
					exit 1;
				else
					echo 'Installing...';
					sudo mv 'osx-pl2303.kext' '/System/Library/Extensions/';
					sudo chmod -R 755 '/System/Library/Extensions/osx-pl2303.kext';
					sudo chown -R root:wheel '/System/Library/Extensions/osx-pl2303.kext';
					cd '/System/Library/Extensions';
					echo 'Loading the driver...';
					sudo kextload ./osx-pl2303.kext;
					sudo kextcache -system-cache;
					echo 'Cleaning up...';
					rm -rf  '/tmp/osx-pl2303.kext.tgz';
					echo 'Done!';
				fi
			fi
		fi
	fi
    fi
