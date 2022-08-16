#!/bin/bash
# See "Flashing and Booting the Target Device" at
# https://docs.nvidia.com/jetson/l4t/index.html#page/Tegra%2520Linux%2520Driver%2520Package%2520Development%2520Guide%2Fflashing.html%23

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
CERT_DIR="certs"
PRIV_KEY_NAME="tegra194-evo-priv.pem"
PUB_KEY_NAME="tegra194-evo-pub.pem"
KEK2_NAME="tegra194-evo-kek2"
KEK256_NAME="tegra194-evo-kek256"
SBK_NAME="tegra194-evo-sbk"
UK_NAME="tegra194-evo-uk"

if [ ! -e "${SCRIPT_PATH}/${CERT_DIR}/${PRIV_KEY_NAME}" ]; then
    echo "please create a key file or use an existing one at path ${SCRIPT_PATH}/${CERT_DIR}/${PRIV_KEY_NAME}"
    exit 1
fi
if [ ! -e "${SCRIPT_PATH}/${CERT_DIR}/${SBK_NAME}" ]; then
    echo "please create a SBK file or use an existing one at path ${SCRIPT_PATH}/${CERT_DIR}/${SBK_NAME}"
    exit 1
fi
if [ ! -e "${SCRIPT_PATH}/${CERT_DIR}/${UK_NAME}" ]; then
    echo "please create a KEK2 file or use an existing one at path ${SCRIPT_PATH}/${CERT_DIR}/${UK_NAME}"
    exit 1
fi

cd `dirname $0`
cd Linux_for_Tegra
echo sudo ./flash.sh --no-flash --sign -u "${SCRIPT_PATH}/${CERT_DIR}/${PRIV_KEY_NAME}" -v "${SCRIPT_PATH}/${CERT_DIR}/${SBK_NAME}" --user_key "${SCRIPT_PATH}/${CERT_DIR}/${UK_NAME}" jetson-xavier-nx-devkit-emmc mmcblk0p1
sudo ./flash.sh --no-flash --sign -u "${SCRIPT_PATH}/${CERT_DIR}/${PRIV_KEY_NAME}" -v "${SCRIPT_PATH}/${CERT_DIR}/${SBK_NAME}" --user_key "${SCRIPT_PATH}/${CERT_DIR}/${UK_NAME}" jetson-xavier-nx-devkit-emmc mmcblk0p1


