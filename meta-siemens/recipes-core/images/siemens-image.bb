# Copyright 2018-2021 NXP
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "This is the basic siemens image"

inherit core-image


IMAGE_FEATURES += " \
    debug-tweaks \
    ssh-server-dropbear \
    hwcodecs \
"


IMAGE_INSTALL += " \
    firmwared \
"



IMAGE_INSTALL += " \
    iperf3 \
    zstd \
    packagegroup-tools \
    u-boot-fw-utils \
"

