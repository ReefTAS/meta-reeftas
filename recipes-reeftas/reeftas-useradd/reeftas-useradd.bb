LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit useradd

# server needs to configure user and group
usernum = "1001"
groupnum = "1001"
USERADD_PACKAGES = "${PN}"

USERADD_PARAM_${PN} = "-M -g ${REEFTAS_GROUP} -o -r \
                       -s /bin/sh -c 'ReefTAS Server' \
                       -u ${usernum} ${REEFTAS_USER}"
GROUPADD_PARAM_${PN} = "-g ${groupnum} -o -r ${REEFTAS_GROUP}"