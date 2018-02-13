SUMMARY = "Reef Tank Automation System - ReefTAS"
HOMEPAGE = ""
LICENSE = "MIT"

IMAGE_LINGUAS = "en-us"

inherit core-image

COMMON_FEATURES = " \
    splash \
    ssh-server-dropbear \
"

IMAGE_FEATURES += "${COMMON_FEATURES}"

FEATURE_PACKAGES_reeftas ?= "packagegroup-reeftas"
FEATURE_PACKAGES_reeftas[optional]  ?=  "1"
FEATURE_PACKAGES_reeftas-coreos ?= "packagegroup-reeftas-coreos"
FEATURE_PACKAGES_reeftas-coreos[optional]  ?=  "1"
FEATURE_PACKAGES_reeftas-tools ?= "packagegroup-reeftas-tools"
FEATURE_PACKAGES_reeftas-tools[optional]  ?=  "1"
FEATURE_PACKAGES_reeftas-uboot ?= "packagegroup-reeftas-uboot"
FEATURE_PACKAGES_reeftas-uboot[optional]  ?=  "1"

set_local_timezone() {
    ln -sf /usr/share/zoneinfo/EST5EDT ${IMAGE_ROOTFS}/etc/localtime
}

disable_bootlogd() {
    echo BOOTLOGD_ENABLE=no > ${IMAGE_ROOTFS}/etc/default/bootlogd
}

ROOTFS_POSTPROCESS_COMMAND += " \
    set_local_timezone ; \
    disable_bootlogd ; \
"
