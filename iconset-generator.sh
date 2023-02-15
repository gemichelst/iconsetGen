#!/bin/bash
# needs hass-iconset-generator.py (from https://github.com/Bouni/hass-iconset-generator)
# needs python pkgs: python3 -m pip install click numpy svgwrite svgpathtools
# $1 = /path/to/svgs/icons $2 = name
# or use install for setup
THISDIR=$(pwd)
THISFILE="$THISDIR/iconset-generator.sh"
ICONSETBIN="iconset-generator"
ICONSETBINDIR="/usr/local/bin/$ICONSETBIN"
PYICONSETBIN="iconset-generator-core.py"
PYICONSETBINDIR="/usr/local/bin/$PYICONSETBIN"

if [[ $EUID -ne 0 ]]; then
	echo "[ERROR]: This script must be run as root \t\t exiting..." 1>&2
	exit 1
fi

function usage {
	echo "_____________________________________________________"
	echo "usage: iconset-generator [iconPath] [iconsetName]"
	echo "example: iconset-generator /path/to/icons/svg myicons"
	echo " "
	echo "install: iconset-generator.sh install"
	exit 1
}

function setup {
	THISFILE=$1
	ICONSETBINDIR=$2
	PYICONSETBINDIR=$3
        echo "[INSTALL]: init setup ..."
        echo "----------------------------------------------------------"
        /usr/bin/env python3 -m pip install --quiet click numpy svgwrite svgpathtools
	echo "[INSTALL][1/4]: download binaries -- done"
        curl https://raw.githubusercontent.com/Bouni/hass-iconset-generator/master/hass-iconset-generator.py -o $PYICONSETBINDIR
	echo "[INSTALL][2/4]: python requirements -- done"
        cp $THISFILE $ICONSETBINDIR
        echo "[INSTALL][3/4]: cp binaries -- done"
	#echo "[SRC]: $THISFILE"
	#echo "[DEST]: $ICONSETBINDIR"
	chmod +x $ICONSETBINDIR
	chmod +x $PYICONSETBINDIR
	chmod 0775 $ICONSETBINDIR
	chmod 0775 $PYICONSETBINDIR
	echo "[INSTALL][4/4]: chmod binaries -- done"
	echo "----------------------------------------------------------"
	echo "[INSTALL]: completed"
	echo " "
	echo " "
	echo " "
	usage
}

if [ -z $1 ]
then
	usage
elif [ $1 == "install" ]
then
	setup $THISFILE $ICONSETBINDIR $PYICONSETBINDIR
elif [ $1 == "env" ]
then
	echo "0: $0"
	echo "THISFILE: $THISFILE"
	echo "ICONSETBIN: $ICONSETBIN"
	echo "ICONSETBINDIR: $ICONSETBINDIR"
	echo "PYICONSETBIN: $PYICONSETBIN"
	echo "PYICONSETBINDIR: $PYICONSETBINDIR"
	echo " "
	usage
else
        python3 $PYICONSETBINDIR $1 -n $2
fi

exit 0
