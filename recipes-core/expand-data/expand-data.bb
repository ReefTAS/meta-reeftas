LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${WORKDIR}/licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI += "\
        file://expand_data.service \
        file://licenses/Apache-2.0 \
"

FILES_${PN} += "\
        ${systemd_unitdir}/system/*.service \
"

do_install_append() {
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/*.service ${D}${systemd_unitdir}/system
}

inherit systemd
SYSTEMD_SERVICE_${PN} = "expand_data.service"
