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
	THISDIR=$(pwd)
	THISFILE=$1
	THISPYBINDIR=$2
	ICONSETBINDIR=$3
	PYICONSETBINDIR=$4
	PYBINURL="https://raw.githubusercontent.com/gemichelst/iconsetGen/main/hass-iconset-generator.py?token=GHSAT0AAAAAAB6AU6I2WIJUG4LWSBXQ6DLEY7NH2QQ"
        echo "[INSTALL]: init setup ..."
        echo "----------------------------------------------------------"
        /usr/bin/env python3 -m pip install --quiet click numpy svgwrite svgpathtools
	#echo "[INSTALL][1/4]: download binaries -- done"
        #curl $PYBINURL -o $PYICONSETBINDIR
	echo "[INSTALL][1/3]: python requirements -- done"
        cp $THISFILE $ICONSETBINDIR
        cp $THISPYBINDIR $PYICONSETBINDIR
        echo "[INSTALL][2/3]: cp binaries -- done"
	#echo "[SRC]: $THISFILE"
	#echo "[DEST]: $ICONSETBINDIR"
	chmod +x $ICONSETBINDIR
	chmod +x $PYICONSETBINDIR
	chmod 0775 $ICONSETBINDIR
	chmod 0775 $PYICONSETBINDIR
	echo "[INSTALL][3/3]: chmod binaries -- done"
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
