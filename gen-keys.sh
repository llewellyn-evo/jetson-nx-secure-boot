#!/bin/bash

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
CERT_DIR="certs"
PRIV_KEY_NAME="tegra194-evo-priv.pem"
PUB_KEY_NAME="tegra194-evo-pub.pem"
KEK2_NAME="tegra194-evo-kek2"
KEK256_NAME="tegra194-evo-kek256"
SBK_NAME="tegra194-evo-sbk"
UK_NAME="tegra194-evo-uk"

## Generating the RSA Key Pair
#
# Secureboot requires an RSA key-pair whose length is 2048 bits (RSA 2K) or 3072‑bits (RSA 3K).
#
# The key file is used to burn fuse and sign boot files for Jetson devices.
# The security of your device depends on how securely you keep the key file.
#
# To ensure the security of the key file, restrict access permission to
# a minimum number of personnel.
#echo "Generating PKC (Public Key Cryptogrpahy = RSA 2k Private key pem)"
# openssl genrsa -out rsa_priv.pem 2048
#echo "Generating PKC (Public Key Cryptogrpahy = RSA 2k  Public key pem)"
# openssl rsa -in rsa_priv.pem -outform PEM -pubout -out rsa_pub.pem

# Check if Directory exits. If not create it
if [ ! -d "${SCRIPT_PATH}/${CERT_DIR}" ]; then
  mkdir -p ${SCRIPT_PATH}/${CERT_DIR};
fi


# Check if Certificate already exists
if [ -f "${SCRIPT_PATH}/${CERT_DIR}/${PRIV_KEY_NAME}" ] || [ -f "${SCRIPT_PATH}/${CERT_DIR}/${PRIV_KEY_NAME}" ]; then
  echo "ERR :  Certificates already exists"
else
  # Generate the certificates since they dont exis
  echo "Generating PKC (Public Key Cryptogrpahy = RSA 2k Private key pem)"
  openssl genrsa -out "${SCRIPT_PATH}/${CERT_DIR}/${PRIV_KEY_NAME}" 2048
  echo "Generating PKC (Public Key Cryptogrpahy = RSA 2k  Public key pem)"
  openssl rsa -in "${SCRIPT_PATH}/${CERT_DIR}/${PRIV_KEY_NAME}" -outform PEM -pubout -out "${SCRIPT_PATH}/${CERT_DIR}/${PUB_KEY_NAME}"
fi

# KEK keys are used for other security applications
# For instance, KEK2 can be used for LUKS disk encryption
#

# echo "Generating KEK0 (Key Encryption Key)"
# openssl rand -rand /dev/urandom -hex 16 > kek0_hex_file
# echo "Generating KEK1 (Key Encryption Key)"
# openssl rand -rand /dev/urandom -hex 16 > kek1_hex_file

# Check if KEK2 file exists
if [ -f "${SCRIPT_PATH}/${CERT_DIR}/${KEK2_NAME}" ]; then
  echo "ERR :  KEK2(Key Encryption Key) already exists"
else
  # Generate if it doesnt exist
  echo "Generating KEK2 (Key Encryption Key)"
  openssl rand -rand /dev/urandom -hex 16 > "${SCRIPT_PATH}/${CERT_DIR}/${KEK2_NAME}"
fi

# KEK256 option uses 256 bits but is stored in KEK0 and KEK1
# For the strongest encryption, we will opt for the KEK256 option

# Check if KEK256 file exists
if [ -f "${SCRIPT_PATH}/${CERT_DIR}/${KEK256_NAME}" ]; then
  echo "ERR :  KEK256(Key Encryption Key) already exists"
else
  echo "Generating KEK256 (Key Encryption Key)"
  openssl rand -rand /dev/urandom -hex 32 > "${SCRIPT_PATH}/${CERT_DIR}/${KEK256_NAME}"
fi


## Preparing the SBK Key
#
# If you want to encrypt Bootloader (and TOS), you must prepare the SBK fuse bits.
#
# Note:
#      You may only use the SBK key with the PKC key. The encryption mode
#      that uses these two keys together is called SBKPKC.
#
# The SBK key consists of four 32-bit words stored in a file in big-endian
# hexadecimal format. Here is an example of an SBK key file:
#
#   0x12345678 0x9abcdef0 0xfedcba98 0x76543210

if [ -f "${SCRIPT_PATH}/${CERT_DIR}/${SBK_NAME}" ];then
  echo "ERR :  SBK(Secure Boot Key) already exists"
else
  echo "Generating SBK (Secure Boot Key)"
  raw_hex=$(openssl rand -rand /dev/urandom -hex 16)
  echo "0x${raw_hex:0:8} 0x${raw_hex:8:8} 0x${raw_hex:16:8} 0x${raw_hex:(-8)}" > "${SCRIPT_PATH}/${CERT_DIR}/${SBK_NAME}"
fi

# If you want to encrypt kernel image (the kernel, kernel-dtb, initrd,
# and extlinux.conf files), you must prepare the user key. You need the
# user key as well as the SBK key and the PKC key.

# Check if user key exists
if [ -f "${SCRIPT_PATH}/${CERT_DIR}/${UK_NAME}" ]; then
  echo "ERR :  UK(User Key) already exists"
else
  echo "Generating UK(User Key)"
  raw_hex=$(openssl rand -rand /dev/urandom -hex 16)
  echo "0x${raw_hex:0:8} 0x${raw_hex:8:8} 0x${raw_hex:16:8} 0x${raw_hex:(-8)}" > "${SCRIPT_PATH}/${CERT_DIR}/${UK_NAME}"
fi
