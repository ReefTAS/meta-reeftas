LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${WORKDIR}/licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI += "\
	file://reeftas_svr \
	file://reeftas_svr_initial_setup.sh \
        file://reeftas_svr_initial_setup.service \
        file://licenses/Apache-2.0 \
"

FILES_${PN} += "\
	${REEFTAS_DATADIR} \
	${bindir}/reeftas_svr_initial_setup.sh \
        ${systemd_unitdir}/system/*.service \
"

inherit systemd
SYSTEMD_SERVICE_${PN} = "reeftas_svr_initial_setup.service"


do_install() {
	install -d ${D}${sysconfdir}/default/reeftas
	install -m 0644 ${WORKDIR}/reeftas_svr \
		${D}${sysconfdir}/default/reeftas/reeftas_svr
	sed -i -e 's,@REEFTAS_DATADIR@,${REEFTAS_DATADIR},g' \
		${D}${sysconfdir}/default/reeftas/reeftas_svr
	sed -i -e 's,@REEFTAS_USER@,${REEFTAS_USER},g' \
		${D}${sysconfdir}/default/reeftas/reeftas_svr
	sed -i -e 's,@REEFTAS_GROUP@,${REEFTAS_GROUP},g' \
		${D}${sysconfdir}/default/reeftas/reeftas_svr

	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/reeftas_svr_initial_setup.sh \
		 ${D}${bindir}/reeftas_svr_initial_setup.sh

	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/reeftas_svr_initial_setup.service \
		 ${D}${systemd_unitdir}/system

	sed -i -e 's,@BINDIR@,${bindir},g' \
        		${D}${systemd_unitdir}/system/reeftas_svr_initial_setup.service
}
