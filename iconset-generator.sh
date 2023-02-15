#!/bin/bash
# needs hass-iconset-generator.py (from https://github.com/Bouni/hass-iconset-generator)
# needs python pkgs: python3 -m pip install click numpy svgwrite svgpathtools
# $1 = /path/to/svgs/icons $2 = name
# or use install for setup
THISDIR=$(pwd)
ICONSETBIN="iconset-generator"
THISFILE="$THISDIR/$ICONSETBIN.sh"
ICONSETBINDIR="/usr/local/bin/$ICONSETBIN"
PYICONSETBIN="iconset-generator-core.py"
PYICONSETBINDIR="/usr/local/bin/$PYICONSETBIN"
THISPYBINDIR="$THISDIR/$PYICONSETBIN"

function usage {
	echo "_____________________________________________________"
	echo "usage: iconset-generator [iconPath] [iconsetName]"
	echo "install: iconset-generator.sh install"
	echo "example: iconset-generator /path/to/svg iconsetName"
	exit 1
}

function setup {
	if [[ $EUID -ne 0 ]]; then
		echo "[ERROR]: install must be run as root! \t\t exiting..." 1>&2
		exit 1
	else
		THISDIR=$(pwd)
		THISFILE=$1
		THISPYBINDIR=$2
		ICONSETBINDIR=$3
		PYICONSETBINDIR=$4
		echo "[INSTALL]: setup init"
		echo "----------------------------------------------------------"
		/usr/bin/env python3 -m pip install --quiet -r requirements.txt
		echo "[INSTALL][1/3]: python requirements \t\t done"
		cp $THISFILE $ICONSETBINDIR
		cp $THISPYBINDIR $PYICONSETBINDIR
		echo "[INSTALL][2/3]: cp binaries \t\t done"
		chmod +x $ICONSETBINDIR
		chmod +x $PYICONSETBINDIR
		chmod 0775 $ICONSETBINDIR
		chmod 0775 $PYICONSETBINDIR
		echo "[INSTALL][3/3]: chmod binaries \t\t done"
		echo "----------------------------------------------------------"
		echo "[INSTALL]: setup completed"
		echo " "
		echo " "
		echo " "
		usage
	fi
}

if [ -z $1 ]
then
	usage
elif [ $1 == "install" ]
then
	setup $THISFILE $THISPYBINDIR $ICONSETBINDIR $PYICONSETBINDIR
elif [ $1 == "env" ]
then
	echo "0: $0"
	echo "THISFILE: $THISFILE"
	echo "THISPYBINDIR: $THISPYBINDIR"
	echo "ICONSETBIN: $ICONSETBIN"
	echo "ICONSETBINDIR: $ICONSETBINDIR"
	echo "PYICONSETBIN: $PYICONSETBIN"
	echo "PYICONSETBINDIR: $PYICONSETBINDIR"
	echo " "
	usage
else
	/usr/bin/env python3 $PYICONSETBINDIR $1 -n $2
	echo "[DONE]: $1/$2.html"
fi

exit 0
