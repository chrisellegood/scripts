#!/bin/bash

# declare an associative array
declare -A rsync_map

# Function to add values to jobs
function add_to_map {
    local dest_path=$1
    local src_path=$2
    local folders=("${@:3}") 
    for i in "${!folders[@]}"
    do
        src="$src_path${folders[i]}"
        dest="$dest_path${folders[i]}"
        rsync_map[$src]=$dest
    done
}

# all folders are sync'd to an external usb drive
dest_path="/volumeUSB1/usbshare/"

# volume1
src_path="/volume1/icebox/"

folders=(
    "___media-dvd-isos/"
)

add_to_map $dest_path $src_path "${folders[@]}"

# volume2
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

add_to_map $dest_path $src_path "${folders[@]}"

# output
for key in "${!rsync_map[@]}"; do
   echo "$key -> ${rsync_map[$key]}"
   ./folders-sync.sh "$key" "${rsync_map[$key]}"
done
