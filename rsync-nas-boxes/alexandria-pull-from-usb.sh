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
dest_path="/volume1/media/"

# volume1
src_path="/volumeUSB1/usbshare/"

folders=(
    "media-books/"
	"media-dvd-isos/"
	"media-music/"
	"media-video/"
)

add_to_map $dest_path $src_path "${folders[@]}"

# volume2
dest_path="/volume1/family/"

folders=(
    "family-ellegood-docs/"
    "family-ellegood-movies/"
    "family-ellegood-pictures/"
    "family-ellegood-ultrasound/"
    "family-ellegood-wedding/"
    "family-jungbauer-heidelberg-haus/"
    "family-jungbauer-dvds-isos/"
)

add_to_map $dest_path $src_path "${folders[@]}"

# output
for key in "${!rsync_map[@]}"; do
   echo "$key -> ${rsync_map[$key]}"
   ./folders-sync.sh "$key" "${rsync_map[$key]}"
done
