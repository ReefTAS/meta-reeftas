FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
EXTRA_OECONF += "--disable-ldconfig"

PACKAGECONFIG += "networkd resolved"

CFLAGS_append_arm = " -fno-lto"

SRC_URI += "\
	file://eth0.network \
	file://wlan0.network \
	file://wpa_supplicant-wlan0.conf \
"

FILES_${PN} += "\
	{sysconfdir}/systemd/network/* \
	${systemd_unitdir}/system/*.service \
	${sysconfdir} \
"

do_install_append() {

	install -d ${D}${sysconfdir}/systemd/network/
	install -m 0644 ${WORKDIR}/*.network  ${D}${sysconfdir}/systemd/network

	install -d ${D}${sysconfdir}/wpa_supplicant/
	install -m 0644 ${WORKDIR}/wpa_supplicant-wlan0.conf ${D}${sysconfdir}/wpa_supplicant/

	# enable the service
	ln -sf ${systemd_unitdir}/system/wpa_supplicant@.service \
		${D}${sysconfdir}/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service
}
