#!/bin/bash

function ver() {
	printf "%03d%03d%03d" $(echo "$1" | tr '.' ' ')
}

DRIVE=$1
echo -e "\nWorking on $DRIVE\n"

#SIZE=`fdisk -l $DRIVE | grep "Disk $DRIVE" | cut -d' ' -f5`

#echo DISK SIZE – $SIZE bytes

#if [ "$SIZE" -lt 3800000000 ]; then
#	echo "Require an SD card of at least 4GB"
#	exit 1
#fi

# new versions of sfdisk don't use rotating disk params
sfdisk_ver=`sfdisk --version | awk '{ print $4 }'`

if [ $(ver $sfdisk_ver) -lt $(ver 2.26.2) ]; then
	CYLINDERS=`echo $SIZE/255/63/512 | bc`
	echo "CYLINDERS – $CYLINDERS"
	SFDISK_CMD="sfdisk --force -D -uS -H255 -S63 -C ${CYLINDERS}"
else
	SFDISK_CMD="sfdisk"
fi

echo -e "\nOkay, here we go ...\n"
# 3 partitions
# Sectors are 512 bytes
# 0      : 4MB, no partition, MBR then empty
# 8192   : 64 MB, FAT partition, bootloader, kernel 
# 139264 : 2GB, linux partition, root filesystem
# 2236416: 2GB+, linux partition, no assigned use

echo -e "\n=== Creating 3 partitions ===\n"
{
echo 8192,131072,0x0C,*
echo 139264,4194304,0x83,-
echo 4333568,+,0x83,-
} | $SFDISK_CMD $DRIVE


sleep 1

echo -e "\n=== Done! ===\n"

