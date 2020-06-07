#!/bin/bash
# read mount info from file, and mount/unmount everything

mapfile -t mnt_points < <(envsubst < ~/.local/share/mnt_points)

function unmount_all() {
	for mnt in "${mnt_points[@]}"; do
		mnt_point="$(echo $mnt | cut -d";" -f2)"
		echo "$mnt_point"
		mount | grep -q "$mnt_point" && sudo umount "$mnt_point"
	done
}

function mount_all() {
	for mnt in "${mnt_points[@]}"; do
		mnt_target="$(echo $mnt | cut -d";" -f1)"
		mnt_point="$(echo $mnt | cut -d";" -f2)"
		mount | grep -q "$mnt_point" || sshfs -o follow_symlinks "$mnt_target" "$mnt_point"
	done
}

already_mounted=no
for mnt in "${mnt_points[@]}"; do
	mnt_target="$(echo $mnt | cut -d";" -f1)"
	mount | grep -q "$mnt_target" && already_mounted=yes
done

if [[ "$already_mounted" == "no" ]]; then
	echo "mounting directories" 	&& mount_all
else
	echo "unmounting directories" 	&& unmount_all
fi
