#!/bin/bash
# See instructions at https://docs.nvidia.com/jetson/l4t/index.html#page/Tegra%20Linux%20Driver%20Package%20Development%20Guide/quick_start.html#wwpID0E0RD0HA
set -e
cd `dirname $0`
source ./downloadfilenames
echo "Extracting ${L4T_RELEASE_PACKAGE}"
sudo tar xpf ${L4T_RELEASE_PACKAGE}
cd Linux_for_Tegra/rootfs/
echo "Extracting ${SAMPLE_FS_PACKAGE}"
sudo tar xpf ${SAMPLE_FS_PACKAGE}
cd ..
# Apply Binaries now
sudo ./apply_binaries.sh
# Patch for w command. Fails if not applied since symlink is not present
sudo rm rootfs/usr/bin/w
# Copy w.procps to w
sudo cp rootfs/usr/bin/w.procps rootfs/usr/bin/w

