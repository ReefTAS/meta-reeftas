FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_patch_device() {
    sed -i -e 's,@REEFTAS_BOOT_PART@,${REEFTAS_BOOT_PART},g' ${S}/fstab
    sed -i -e 's,@REEFTAS_VAR_PART@,${REEFTAS_VAR_PART},g' ${S}/fstab
    sed -i -e 's,@REEFTAS_DATA_PART@,${REEFTAS_DATA_PART},g' ${S}/fstab

    sed -i -e 's,@REEFTAS_BOOT_PART_FSTYPE@,${REEFTAS_BOOT_PART_FSTYPE},g' ${S}/fstab
    sed -i -e 's,@REEFTAS_FSTYPE@,${REEFTAS_FSTYPE},g' ${S}/fstab

    sed -i -e 's,@REEFTAS_DATA_MOUNT_POINT@,${REEFTAS_DATA_MOUNT_POINT},g' ${S}/fstab
}

do_install_append() {
    install -d ${D}/${REEFTAS_DATA_MOUNT_POINT}
}

addtask do_patch_device after do_patch before do_install
