#!/bin/bash

# all folders are sync'd to an external usb drive
dest_path="/volumeUSB1/usbshare/"

# declare an associative array
declare -A rsync_map

# volume 1
src_path="/volume1/icebox/"
folders=(
    "___media-dvd-isos/"
)

for i in "${!folders[@]}"
do
  src="$src_path${folders[i]}"
  dest="$dest_path${folders[i]}"
  rsync_map[$src]=$dest
done

src_path="/volume2/deepfreeze/"
folders=(
    "___archive-kiwix/"
    "___family-ellegood-docs/"
    "___family-ellegood-movies/"
    "___family-ellegood-pictures/"
    "___family-ellegood-ultrasound/"
    "___family-ellegood-wedding/"
    "___family-jungbauer-heidelberg-haus/"
    "___hobby-hyperspin-vertical-machine/"
    "___homelab-isos/"
    "___media-books/"
    "___media-movies/"
)

for i in "${!folders[@]}"
do
  src="$src_path${folders[i]}"
  dest="$dest_path${folders[i]}"
  rsync_map[$src]=$dest
done

for key in "${!rsync_map[@]}"; do
   echo "$key -> ${rsync_map[$key]}"
done


#  ./folders-sync.sh "$key" "${jobs[$key]}"
#index=0
#while [ $index -lt ${#src_array[@]} ]
#do
#  ./folders-sync.sh "${src_array[index]}" "${dest_array[index]}"
#  ((index++))
#done

# Call the sync script with those parameters
# ./folders-sync.sh "${src_array[0]}" "${dest_array[0]}"