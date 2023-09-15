#!/bin/bash
update_folder=${1}
ask_reboot()
{
	echo "do you want to reboot [y,n]"

	while :
		do

		read input

		if [ "$input" = "y" ]; then
			echo "rebooting"
			reboot
		elif [ "$input" = "n" ]; then
			echo "please reboot to finialise update"
			exit
		else
			echo "please only use [y,n]"
		fi
	done


}


#finds the partion currently mounted as the rootfs, if unexpected partid returns -1
find_current_part()
{

	tmp=$(fw_printenv mmcrootfspart | sed 's/mmcrootfspart=//g')

	if [ $tmp == "2" ]; then
        currentpart="0"
	elif [ $tmp == "3" ]; then
        currentpart="1"
	else
		currentpart="-1"
	fi
}

find_rootfs_update()
{
	if [ "$(find $update_folder -name 'rti-rootfs.ext4')" != "" ]; then
		rootfs_file="1"
		echo "found rootfs update"
		rootfs_file_path=$(find $update_folder -name 'rti-rootfs.ext4')
		rootfs_update_file=$(echo $file_path | sed 's!'"$update_folder"'!!g')

	else
		rootfs_file=""
	fi
}


find_kernel_update()
{
	if [ "$(find $update_folder -name 'Image')" != "" ]; then
		kernel_file="1"
		echo "found kernel update"
		kernel_file_path=$(find $update_folder -name 'Image')
		kernel_update_file=$(echo $file_path | sed 's!'"$update_folder"'!!g')

	else
		kernel_file=""
	fi
}

find_dtb_update()
{
	if [ "$(find $update_folder -name 'rti.dtb')" != "" ]; then
		dtb_file="1"
		echo "found dtb update"
		dtb_file_path=$(find $update_folder -name 'rti.dtb')
		dtb_update_file=$(echo $file_path | sed 's!'"$update_folder"'!!g')

	else
		dtb_file=""
	fi
}

find_u_boot_update()
{
	if [ "$(find $update_folder -name 'imx-boot')" != "" ]; then
		u_boot_file="1"
		echo "found u-boot update"
		u_boot_file_path=$(find $update_folder -name 'imx-boot')
		u_boot_update_file=$(echo $file_path | sed 's!'"$update_folder"'!!g')

	else
		u_boot_file=""
	fi
}

update_rootfs_partition()
{
	if [ "$rootfs_file" = "" ]; then
		echo "update fails, file not found"
		exit
	else	
		echo "using update file $rootfs_file_path"
		if [ "$currentpart" = "0" ]; then
			echo "updating rootfs 1"
			umount /dev/mmcblk2p3
			dd if=$rootfs_file_path of=/dev/mmcblk2p3 bs=8M conv=fdatasync status=progress
			echo "rootfs 1 updated"

		elif [ "$currentpart" = "1" ]; then
			echo "updating rootfs 0"
			umount /dev/mmcblk2p2
			dd if=$rootfs_file_path of=/dev/mmcblk2p2 bs=8M conv=fdatasync status=progress
			echo "rootfs 0 updated"
		fi
	fi
}

update_kernel_file()
{
	if [ "$kernel_file" = "" ]; then
		echo "kernel update fails, file not found"
		exit
	else
		echo "using update file $kernel_file_path"
		if [ "$currentpart" = "0" ]; then
			echo "updating kernel 1"
			dd if=$kernel_file_path of=/run/media/boot-mmcblk2p1/uImage_1 bs=8M conv=fdatasync status=progress
			echo "kernel 1 updated"
	
		elif [ "$currentpart" = "1" ]; then
			echo "updating kernel 0"
			dd if=$kernel_file_path of=/run/media/boot-mmcblk2p1/uImage bs=8M conv=fdatasync status=progress
			echo "kernel 0 updated"
		fi
	fi
}


update_dtb_file()
{
	if [ "$dtb_file" = "" ]; then
		echo "dtb update fails, file not found"
		exit
	else
		echo "using update file $dtb_file_path"
		if [ "$currentpart" = "0" ]; then
			echo "updating dtb 1"
			dd if=$dtb_file_path of=/run/media/boot-mmcblk2p1/rti_1.dtb bs=8M conv=fdatasync status=progress
			echo "dtb 1 updated"
	
		elif [ "$currentpart" = "1" ]; then
			echo "updating dtb 0"
			dd if=$dtb_file_path of=/run/media/boot-mmcblk2p1/rti.dtb bs=8M conv=fdatasync status=progress
			echo "dtb 0 updated"
		fi
	fi
}

update_u_boot()
{
	if [ "$u_boot_file" = "" ]; then
		echo "u-boot update fails, file not found"
		
	else
		echo "updating u-boot"
		echo 0 > /sys/block/mmcblk2boot0/force_ro
		dd if=$u_boot_file_path of=/dev/mmcblk2boot0 bs=1k seek=33 conv=fdatasync status=progress
		echo"u-boot updated"
	fi
}

switch_rootfs_partition()
{
	if [ "$currentpart" = "0" ]; then
        	echo "this is rootfs 0 - switching to rootfs 1"
        	fw_setenv mmcrootfspart 3
		fw_setenv fdtfile rti_1.dtb

	elif [ "$currentpart" = "1" ]; then
        	echo "this is rootfs 1 - switching to rootfs 0"
		fw_setenv mmcrootfspart 2
		fw_setenv fdtfile rti.dtb
	fi
}


find_current_part

find_rootfs_update
find_kernel_update
find_dtb_update
find_u_boot_update

update_rootfs_partition
update_kernel_file
update_dtb_file
update_u_boot

switch_rootfs_partition
#reboot
ask_reboot


