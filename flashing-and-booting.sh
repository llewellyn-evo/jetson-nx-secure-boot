#!/bin/bash
# See "Flashing and Booting the Target Device" at
# https://docs.nvidia.com/jetson/l4t/index.html#page/Tegra%2520Linux%2520Driver%2520Package%2520Development%2520Guide%2Fflashing.html%23
cd `dirname $0`
PROGNAME=$(basename $0)
TYP=""
usage()
{
    cat >&2 <<EOF
Deploy a jetson image to a machine connected via local USB
and in recovery mode.
Usage: ./${PROGNAME} --type <SD/EMMC>
Options:
    -h, --h             Print this usage message
    -t, --type       	Set the type of MACHINE<SD/EMMC>
Examples:
- To deploy a to Jetson NX with SD card:
  $ $0 --type SD
EOF
}

# get command line options
SHORTOPTS="ht:"
LONGOPTS="help,type:"

ARGS=$(getopt --options $SHORTOPTS --longoptions $LONGOPTS --name $PROGNAME -- "$@" )
if [ $? != 0 ]; then
	usage
	exit 1
fi

eval set -- "$ARGS"
while true;
do
	case $1 in
		-h | --help)       usage; exit 0 ;;
		-t | --type)   	   TYP="$2"; shift 2;;
		-- )               shift; break ;;
		* )                break ;;
	esac
done

if [ -z "$TYP" ]; then
	echo "You must specify a type of machine"
	usage
	exit 1
fi

if [ "${TYP}" != "SD" ] && [ "${TYP}" != "EMMC" ]; then
	usage
	exit 1
fi

cd Linux_for_Tegra

if [ "${TYP}" == "SD" ]; then
	echo "Flashing Image to Jetson NX with SD Card"
	sudo ./flash.sh jetson-xavier-nx-devkit mmcblk0p1

elif [ "${TYP}" == "EMMC" ]; then 
	echo "Flashing Image to Jetson NX with EMMC"
	sudo ./flash.sh jetson-xavier-nx-devkit-emmc mmcblk0p1

fi

