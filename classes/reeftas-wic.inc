do_image_wic[depends] += "\
      wic-tools:do_populate_sysroot \
      syslinux-native:do_populate_sysroot \
      dosfstools-native:do_populate_sysroot \
      mtools-native:do_populate_sysroot \
      rsync-native:do_populate_sysroot\
"

#fstab is updated in base-files. Hence do not attempt to update it from wic
WIC_CREATE_EXTRA_ARGS += "\
  -D \
  --no-fstab-update\
"
