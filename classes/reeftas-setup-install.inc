# Estimate how much space may be lost due to partitioning alignment. Use a
# simple heuristic for now - 4 partitions * alignment
def reeftas_get_part_overhead(d):
    align = d.getVar('REEFTAS_PARTITION_ALIGNMENT_KB', True)
    if align:
        return 4 * int(align)
    return 0

# Overhead lost due to partitioning.
REEFTAS_PARTITIONING_OVERHEAD_KB ?= "${@reeftas_get_part_overhead(d)}"

def reeftas_calculate_rootfs_size_kb(total_mb, boot_mb, data_mb, overhead_kb):
    # Space left in raw device.
    calc_space = (total_mb - boot_mb - data_mb) * 1048576 - overhead_kb * 1024

    # Split in two.
    calc_space = calc_space / 2

    # Turn into kiB.
    calc_space_kb = calc_space / 1024

    return int(calc_space_kb)

# Auto detect image size from other settings.
REEFTAS_CALC_ROOTFS_SIZE = "${@reeftas_calculate_rootfs_size_kb(${REEFTAS_STORAGE_TOTAL_SIZE_MB}, \
                                                                ${REEFTAS_BOOT_PART_SIZE_MB}, \
                                                                ${REEFTAS_DATA_PART_SIZE_MB}, \
                                                                ${REEFTAS_PARTITIONING_OVERHEAD_KB})}"
python() {
    # Set hard limit on maximum rootfs size. Calculated rootfs size is used
    # when partitioning the disk image (be it SD card or UBI image), and
    # defines an upper bound of the space allocated for rootfs
    # partition/volume.
    d.setVar('IMAGE_ROOTFS_MAXSIZE', d.getVar('REEFTAS_CALC_ROOTFS_SIZE'))
}
