LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI += "\
	file://reeftas_db_initial_setup.sh \
        file://reeftas_db_initial_setup.service \
        file://licenses/Apache-2.0 \
"

FILES_${PN} += "\
	${bindir}/reeftas_db_initial_setup.sh \
        ${systemd_unitdir}/system/*.service \
"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/reeftas_db_initial_setup.sh \
		 ${D}${bindir}/reeftas_db_initial_setup.sh

	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/reeftas_db_initial_setup.service \
		 ${D}${systemd_unitdir}/system

	sed -i -e 's,@BINDIR@,${bindir},g' \
        		${D}${systemd_unitdir}/system/reeftas_db_initial_setup.service
}

RDEPENDS_${PN} = "\
    bash\
    postgresql\
"

inherit systemd
SYSTEMD_SERVICE_${PN} = "reeftas_db_initial_setup.service"
