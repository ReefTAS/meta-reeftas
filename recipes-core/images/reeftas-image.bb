DESCRIPTION = "A image containing Reef Tank Automation system - ReefTAS"
require reeftas-common.inc

REEFTAS_FEATURES = " \
    reeftas \
    reeftas-coreos \
    reeftas-tools  \
"

IMAGE_FEATURES_append = "${REEFTAS_FEATURES}"
