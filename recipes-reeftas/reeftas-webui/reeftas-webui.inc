SUMMARY = "Web UI files for ReefTAS"
DESCRIPTION = "\
This package provides web interface files for ReefTAS. It mainly consists\
of HTML, Javascript and SAAS styles.\
"
HOMEPAGE="https://github.com/ReefTAS/webui"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

SRC_URI = "git://github.com/ReefTAS/webui"
S = "${WORKDIR}/git"
DEPENDS += "nodejs"

FILES_${PN} = "\
    /www/* \
" 
BOWER_FLAGS = "\
    --config.storage.packages=${WORKDIR}/.bower/packages \
    --config.storage.registry=${WORKDIR}/.bower/registry \
    --config.storage.links=${WORKDIR}/.bower/links \
"

do_bower_install_prepend () {
	export XDG_CONFIG_HOME=${WORKDIR}
}

inherit  bower-install gulp	
do_install () {
	install -d ${D}/www/reeftas
	cp -r ${S}/release/* ${D}/www/reeftas
}
