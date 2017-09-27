LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${WORKDIR}/licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI += "\
	file://reeftas_db \
        file://reeftas_db.service \
        file://licenses/Apache-2.0 \
"

FILES_${PN} += "\
	${sysconfdir}/default/reeftas/reeftas_db \
        ${systemd_unitdir}/system/*.service \
"

do_install() {
	install -d ${D}${sysconfdir}/default/reeftas
	install -m 0644 ${WORKDIR}/reeftas_db ${D}${sysconfdir}/default/reeftas/

	sed -i -e 's,@PGDATA@,${REEFTAS_DBDIR},g' \
			${D}${sysconfdir}/default/reeftas/reeftas_db
	sed -i -e 's,@PGPORT@,${REEFTAS_DBPORT},g' \
			${D}${sysconfdir}/default/reeftas/reeftas_db
	sed -i -e 's,@REEFTAS_USER@,${REEFTAS_USER},g' \
			${D}${sysconfdir}/default/reeftas/reeftas_db
	sed -i -e 's,@REEFTAS_GROUP@,${REEFTAS_GROUP},g' \
			${D}${sysconfdir}/default/reeftas/reeftas_db

	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/reeftas_db.service ${D}${systemd_unitdir}/system

	sed -i -e 's,@BINDIR@,${bindir},g' \
        		${D}${systemd_unitdir}/system/reeftas_db.service

	sed -i -e 's,@REEFTAS_USER@,${REEFTAS_USER},g' \
        		${D}${systemd_unitdir}/system/reeftas_db.service
	sed -i -e 's,@REEFTAS_GROUP@,${REEFTAS_GROUP},g' \
        		${D}${systemd_unitdir}/system/reeftas_db.service
}

RDEPENDS_${PN} = "postgresql"

inherit systemd
SYSTEMD_SERVICE_${PN} = "reeftas_db.service"
