#!/bin/bash

unzip_update()
{

	if [ "$(find /data -name 'update-*.tar.gz')" != "" ]; then

		tar_path=$(find /data -name update-*.tar.gz | sort -r | sed -n '1p')

		update_folder=$(echo $tar_path | sed 's!.tar.gz!!')
		update_number=$(echo $update_folder | sed 's!/data!!g' |sed 's!/update-!!g')
		echo "This is update $update_number"
		echo "Unzipping files from usb"
		tmp=$(echo $update_folder | sed 's,update-'"$update_number"',,g')
		tar -xvf $tar_path -C /tmp
		update_folder="/tmp/update-"$update_number
	else
		echo "update not found"
		exit
	fi

}

run_update()
{
	echo running rti-update-$update_number 
	chmod 0755 $update_folder/rti-update-$update_number.sh
	$update_folder/rti-update-$update_number.sh $update_folder	 

}

unzip_update
run_update

