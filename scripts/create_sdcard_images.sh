#!/bin/bash

DSTDIR=~/rpi/upload
IMG=reeftas
IMG_LONG="${IMG}-image-${MACHINE}"

DEV=${1}
CARDSIZE=${2}
META_RPI_DIR=../../meta-rpi
HOSTNAME=ReefTAS
MOUNTPATH=/tmp/card

if [ -z "${OETMP}" ]; then
	echo "OETMP environment variable not set"
	exit 1
fi

if [ -z "${MACHINE}" ]; then
	echo "MACHINE environment variable not set"
	exit 1
fi

SRCDIR=${OETMP}/deploy/images/${MACHINE}

if [ ! -f "${SRCDIR}/${IMG_LONG}.tar.xz" ]; then
	echo "File not found: ${SRCDIR}/${IMG_LONG}.tar.xz"
	exit 1
fi

if [ "${CARDSIZE}" -eq 8 ]; then
	echo -e "\n***** Zeroing 8GB of the SD card *****\n"
	dd if=/dev/zero of=${DEV} bs=1M count=7400
elif [ "${CARDSIZE}" -eq 4 ]; then
	echo -e "\n***** Zeroing 4GB of the SD card *****\n"
	dd if=/dev/zero of=${DEV} bs=1M count=3600
elif [ "${CARDSIZE}" -eq 2 ]; then
	echo -e "\n***** Zeroing 2GB of the SD card *****\n"
	dd if=/dev/zero of=${DEV} bs=1M count=1800
else
	echo "Unsupported card size: ${CARDSIZE}"
	exit 1
fi

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

echo -e "\n***** Partitioning the SD card *****"
bash ${SCRIPTPATH}/mk3parts.sh ${DEV}
if [ $? -ne 0 ]; then
	echo "Error partitioning the SD card: $f"
	exit 1
fi

#echo -e "\n*****  *****"
echo -e "\n***** Create boot image  *****"
dd if=/dev/zero of=${DEV}_boot bs=1M count=64
if [ $? -ne 0 ]; then
	echo "Error creating boot image: $f"
	exit 1
fi


echo -e "\n***** Copying the boot partition *****"
TMPPATH=/tmp/boot
mkdir ${TMPPATH}
bash ${SCRIPTPATH}/copy_boot.sh ${DEV}_boot ${TMPPATH}
if [ $? -ne 0 ]; then
	echo "Error preparing the boot partition: $f"
	exit 1
fi
rm -fr ${TMPPATH}/*

echo -e "\n***** Copying the rootfs *****"
TMPPATH=/tmp/root
mkdir ${TMPPATH}
bash ${SCRIPTPATH}/copy_rootfs.sh ${DEV}_root ${IMG} ${HOSTNAME} ${TMPPATH}
if [ $? -ne 0 ]; then
	echo "Error copying rootfs: $f"
	exit 1
fi
rm -fr ${TMPPATH}/*

echo -e "\n***** Moving boot image to SD card image *****"
dd if=${DEV}_boot \
   of=${DEV} \
   bs=512 \
   seek=8192
if [ $? -ne 0 ]; then
	echo "Error moving boot image into sdcard image: $f"
	exit 1
fi


echo -e "\n***** Moving root image to SD card image *****"
dd if=${DEV}_root \
   of=${DEV} \
   bs=512 \
   seek=139264
if [ $? -ne 0 ]; then
	echo "Error moving root image to sdcard image: $f"
	exit 1
fi

echo -e "\n***** Done *****\n"
