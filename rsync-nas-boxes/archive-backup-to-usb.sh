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
    "z___media-dvd-isos/"
)

add_to_map $dest_path $src_path "${folders[@]}"

# volume2
src_path="/volume2/deepfreeze/"

folders=(
    "z___archive-kiwix/"
    "z___family-ellegood-docs/"
    "z___family-ellegood-movies/"
    "z___family-ellegood-pictures/"
    "z___family-ellegood-ultrasound/"
    "z___family-ellegood-wedding/"
    "z___family-jungbauer-heidelberg-haus/"
    "z___hobby-hyperspin-vertical-machine/"
    "z___homelab-isos/"
    "z___media-books/"
    "z___media-video/"
    "z___family-jungbauer-dvds-isos/"
	"z___homelab-krolyian/"
	"z___media-music/"
	"ellegood-chris/"
)

add_to_map $dest_path $src_path "${folders[@]}"

# output
for key in "${!rsync_map[@]}"; do
   echo "$key -> ${rsync_map[$key]}"
   ./folders-sync.sh "$key" "${rsync_map[$key]}"
done
