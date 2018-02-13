REEFTAS_UBOOT_ENV_STORAGE_DEVICE_OFFSET ??= "${@eval('${MENDER_PARTITION_ALIGNMENT_KB} * 1024')}"

# u-boot environment file
IMAGE_UENV_TXT_FILE ?= ""

IMAGE_BOOT_FILES_append_reeftas-uboot = " ${IMAGE_UENV_TXT_FILE}"

# make sure to provide a weak default
UBOOT_SUFFIX ??= "bin"
