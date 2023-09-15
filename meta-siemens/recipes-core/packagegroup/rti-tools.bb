# Copyright 2018-2020 NXP
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Packagegroup to provide necessary tools for basic core image"


inherit packagegroup



RDEPENDS:${PN} = " \
    dosfstools \
    evtest \
    e2fsprogs-mke2fs \
    fsl-rc-local \
    fbset \
    i2c-tools \
    iproute2 \
    libgpiod-tools \
    memtester \
    ethtool \
    mtd-utils \
    mtd-utils-ubifs \
    procps \
    ptpd \
    linuxptp \
    iw \
    cpufrequtils \
    ntpdate \
    coreutils \
    mmc-utils \
    udev-extraconf \
    e2fsprogs-resize2fs \
    parted \
"
