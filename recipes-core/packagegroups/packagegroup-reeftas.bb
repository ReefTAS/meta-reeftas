DESCRIPTION = "ReefTAS packages, available on all reeftas images"
LICENSE = "None"

inherit packagegroup

# Packages
RDEPENDS_${PN} += "\
     reeftas-db \
     reeftas-db-initial-setup \
     reeftas-webui \
     reeftas-svr-initial-setup \
"
