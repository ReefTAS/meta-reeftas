#!/bin/bash
MOUNTPATH=${2}

if [ -z "${MACHINE}" ]; then
	echo "Environment variable MACHINE not set"
	echo "Example: export MACHINE=raspberrypi2 or export MACHINE=raspberrypi"
	exit 1
fi

if [ "${MACHINE}" != "raspberrypi3" ] && [ "${MACHINE}" != "raspberrypi2" ] && [ "${MACHINE}" != "raspberrypi" ]; then
	echo "Invalid MACHINE: ${MACHINE}"
	exit 1
fi

BOOTLDRFILES="bootcode.bin \
              cmdline.txt \
              config.txt \
              fixup_cd.dat \
              fixup.dat \
              fixup_db.dat \
              fixup_x.dat \
              start_cd.elf \
              start_db.elf \
              start.elf \
              start_x.elf"

if [ "${MACHINE}" == "raspberrypi" ]; then
	DTBS="bcm2708-rpi-b.dtb \
	      bcm2708-rpi-b-plus.dtb \
	      bcm2708-rpi-cm.dtb"
else
	DTBS="bcm2709-rpi-2-b.dtb \
	      bcm2710-rpi-3-b.dtb"
fi

if [ "x${1}" = "x" ]; then
	echo -e "\nUsage: ${0} <block device>\n"
	exit 0
fi

if [ -z "$OETMP" ]; then
	echo -e "\nWorking from local directory"
	SRCDIR=.
else
	echo -e "\nOETMP: $OETMP"

	if [ ! -d ${OETMP}/deploy/images/${MACHINE} ]; then
		echo "Directory not found: ${OETMP}/deploy/images/${MACHINE}"
		exit 1
	fi

	SRCDIR=${OETMP}/deploy/images/${MACHINE}
fi 

for f in ${BOOTLDRFILES}; do
	if [ ! -f ${SRCDIR}/bcm2835-bootfiles/${f} ]; then
		echo "Bootloader file not found: ${SRCDIR}/bcm2835-bootfiles/$f"
		exit 1
	fi
done

for f in ${DTBS}; do
	if [ ! -f ${SRCDIR}/Image-${f} ]; then
		echo "dtb not found: ${SRCDIR}/Image-${f}"
		exit 1
	fi
done
	
if [ ! -f ${SRCDIR}/Image ]; then
	echo "Kernel file not found: ${SRCDIR}/Image"
	exit 1
fi

DEV=${1}

echo "Formatting FAT partition on ${DEV}"
mkfs.vfat -F 32 ${DEV} -n BOOT

echo "Copying bootloader files"
cp ${SRCDIR}/bcm2835-bootfiles/* ${MOUNTPATH} 

if [ $? -ne 0 ]; then
	echo "Error copying bootloader files"
	exit 1
fi

echo "Creating overlay directory"
mkdir ${MOUNTPATH}/overlays

if [ $? -ne 0 ]; then
	echo "Error creating overlays directory"
	exit 1
fi

echo "Copying overlay dtbos"
for f in ${SRCDIR}/Image-*.dtbo; do
	if [ -L $f ]; then
		cp $f ${MOUNTPATH}/overlays
	fi
done

if [ $? -ne 0 ]; then
	echo "Error copying overlays"
	exit 1
fi

echo "Stripping 'Image-' from overlay dtbos"
sudo rename 's/Image-([\w\-]+).dtbo/$1.dtbo/' ${MOUNTPATH}/overlays/*.dtbo

echo "Copying dtbs"
for f in ${DTBS}; do
	 cp ${SRCDIR}/Image-${f} ${MOUNTPATH}/${f}

	if [ $? -ne 0 ]; then
		echo "Error copying dtb: $f"
		exit 1
	fi
done

echo "Copying kernel"
if [ "${MACHINE}" = "raspberrypi2" ]; then 
	 cp ${SRCDIR}/Image ${MOUNTPATH}/kernel7.img
else
	 cp ${SRCDIR}/Image ${MOUNTPATH}/kernel.img
fi

if [ $? -ne 0 ]; then
	echo "Error copying kernel"
	exit 1
fi

if [ -f ./config.txt ]; then
	echo "Copying local config.txt to card"
	 cp ./config.txt ${MOUNTPATH}

	if [ $? -ne 0 ]; then
		echo "Error copying local config.txt to card"
		exit 1
	fi
fi
  
if [ -f ./cmdline.txt ]; then
	echo "Copying local cmdline.txt to card"
	 cp ./cmdline.txt ${MOUNTPATH}

	if [ $? -ne 0 ]; then
		echo "Error copying local cmdline.txt to card"
		exit 1
	fi
fi
mcopy -sv  -i ${DEV} ${MOUNTPATH}/*  ::
echo "Done"
