# short-description: 
# long-description:


# Note
# Providing mount point as sourceparams will not update the mount point in fstab.
# This is because imager plugin updates fstab entries before subdir-as-partition plugin has a chance to update mountpoint
# Therefore mount points should be specified in base-files fstab

#root a
part  --source reeftas-rootfs --sourceparams "size-varname=REEFTAS_CALC_ROOTFS_SIZE,fstype-varname=REEFTAS_FSTYPE,align-varname=REEFTAS_PARTITION_ALIGNMENT_KB" --ondisk mmcblk --label primary --exclude "var/" "data/"

#root b
part  --source reeftas-rootfs --sourceparams "size-varname=REEFTAS_CALC_ROOTFS_SIZE,fstype-varname=REEFTAS_FSTYPE,align-varname=REEFTAS_PARTITION_ALIGNMENT_KB" --ondisk mmcblk --label secondary --exclude "var/" "data/"

#var partition
part  --source subdir-as-partition --sourceparams "size-varname=REEFTAS_VAR_PART_SIZE,fstype-varname=REEFTAS_FSTYPE,align-varname=REEFTAS_PARTITION_ALIGNMENT_KB,subdir=var" --ondisk mmcblk --label var

#data partiton
part --source subdir-as-partition --sourceparams "size-varname=REEFTAS_DATA_PART_SIZE,fstype-varname=REEFTAS_FSTYPE,align-varname=REEFTAS_PARTITION_ALIGNMENT_KB,subdir=data" --ondisk mmcblk --label data
