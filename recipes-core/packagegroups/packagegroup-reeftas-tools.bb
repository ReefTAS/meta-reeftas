DESCRIPTION = "ReefTAS packages, available on all reeftas images"
LICENSE = "None"

inherit packagegroup

# Packages
RDEPENDS_${PN} += "\
    bzip2 \
    devmem2 \
    dosfstools \
    ethtool \
    fbset \
    findutils \
    i2c-tools \
    iproute2 \
    less \
    memtester \
    nano \
    netcat \
    procps \
    rsync \
    sysfsutils \
    tcpdump \
    unzip \
    util-linux \
    wget \
    zip \
"
