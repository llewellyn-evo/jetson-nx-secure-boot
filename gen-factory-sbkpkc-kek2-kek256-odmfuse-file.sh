#!/bin/bash
# See "Burning PKC [DK(KEK), SBK] Fuses" instructions at
# https://docs.nvidia.com/jetson/l4t/index.html#page/Tegra%20Linux%20Driver%20Package%20Development%20Guide/bootloader_secure_boot.html#wwpID0E0QF0HA
cd `dirname $0`
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
CERT_DIR="certs"
PRIV_KEY_NAME="tegra194-evo-priv.pem"
PUB_KEY_NAME="tegra194-evo-pub.pem"
KEK2_NAME="tegra194-evo-kek2"
KEK256_NAME="tegra194-evo-kek256"
SBK_NAME="tegra194-evo-sbk"
UK_NAME="tegra194-evo-uk"

chipid="0x19"
FAB=200
BOARDID=3668
BOARDSKU=0001
BOARDREV=G.0
TargetBoard=jetson-xavier-nx-devkit-emmc

if [ ! -e "${SCRIPT_PATH}/${CERT_DIR}/${PUB_KEY_NAME}" ]; then
    echo "please create a key file or use an existing one at path ${SCRIPT_PATH}/${CERT_DIR}/${PRIV_KEY_NAME}"
    exit 1
fi
if [ ! -e "${SCRIPT_PATH}/${CERT_DIR}/${SBK_NAME}" ]; then
    echo "please create a SBK file or use an existing one at path ${SCRIPT_PATH}/${CERT_DIR}/${SBK_NAME}"
    exit 1
fi
if [ ! -e "${SCRIPT_PATH}/${CERT_DIR}/${KEK2_NAME}" ]; then
    echo "please create a KEK2 file or use an existing one at path ${SCRIPT_PATH}/${CERT_DIR}/${KEK2_NAME}"
    exit 1
fi
if [ ! -e "${SCRIPT_PATH}/${CERT_DIR}/${KEK256_NAME}" ]; then
    echo "please create a KEK256 file or use an existing one at path ${SCRIPT_PATH}/${CERT_DIR}/${KEK256_NAME}"
    exit 1
fi
read -p "Are you sure you want to generate the factory fuseblob.tbz2 with the SBK and PKC fuses? Press y to continue:" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    set -e
    echo "Generating factory fuseblob.tbz2 with SBK, PKC, KEK2 and KEK256 fuses, leaving JTAG enabled"
    cd Linux_for_Tegra
    if  ! command -v ./odmfuse.sh ; then
	    echo "Please run ./install-secureboot.sh before running this script"
	    exit 1
    fi
    # Odmfuse requires variable FAB, BOARDID, BOARDSKU and BOARDREV in order to run in the offline mode.
    # Otherwise odmfuse needs to access on board EEPROM. Make sure the board is in recovery mode.
    # Board ID(3668) version(200) sku(0001) revision(G.0)
    # As the board is unfused, the --auth mode is NS in order to generate all the fuses.
    echo sudo FAB=${FAB} BOARDID=${BOARDID}  BOARDSKU=${BOARDSKU}  BOARDREV=${BOARDREV} ./odmfuse.sh -i ${chipid} -p --noburn --auth NS -k "${SCRIPT_PATH}/${CERT_DIR}/${PRIV_KEY_NAME}" --KEK2 "${SCRIPT_PATH}/${CERT_DIR}/${KEK2_NAME}" --KEK256 "${SCRIPT_PATH}/${CERT_DIR}/${KEK256_NAME}" -S "${SCRIPT_PATH}/${CERT_DIR}/${SBK_NAME}" ${TargetBoard}
    sudo FAB=${FAB} BOARDID=${BOARDID}  BOARDSKU=${BOARDSKU}  BOARDREV=${BOARDREV} ./odmfuse.sh -i ${chipid} -p --noburn --auth NS -k "${SCRIPT_PATH}/${CERT_DIR}/${PRIV_KEY_NAME}" --KEK2 "${SCRIPT_PATH}/${CERT_DIR}/${KEK2_NAME}" --KEK256 "${SCRIPT_PATH}/${CERT_DIR}/${KEK256_NAME}" -S "${SCRIPT_PATH}/${CERT_DIR}/${SBK_NAME}" ${TargetBoard}
fi
