do_image_wic[depends] += "wic-tools:do_populate_sysroot dosfstools-native:do_populate_sysroot mtools-native:do_populate_sysroot rsync-native:do_populate_sysroot"


WICVARS_append = " \
    REEFTAS_PARTITION_ALIGNMENT_KB \
    REEFTAS_FSTYPE \
    REEFTAS_BOOT_PART_SIZE_MB \
    REEFTAS_CALC_ROOTFS_SIZE \
    REEFTAS_VAR_PART_SIZE \
    REEFTAS_DATA_PART_SIZE \
"
