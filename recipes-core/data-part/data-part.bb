LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

do_install_append() {
	install -d ${D}${REEFTAS_DATA_MOUNT_POINT_DEFAULT}
}

FILES_${PN} += "\
        ${REEFTAS_DATA_MOUNT_POINT_DEFAULT} \
"
