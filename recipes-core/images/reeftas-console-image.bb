DESCRIPTION = "A image containing Reef Tank Automation system - ReefTAS"
require reeftas-common.inc

REEFTAS_FEATURES = " \
    reeftas-coreos \
"

IMAGE_FEATURES_append = "${REEFTAS_FEATURES}"
