DESCRIPTION = "ReefTAS packages, available on all reeftas images"
LICENSE = "None"

inherit packagegroup

# Packages
RDEPENDS_${PN} += "\
	u-boot \
"
