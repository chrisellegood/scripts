#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

SRC="$1"
DEST="$2"

echo "source is $SRC"
echo "dest   is $DEST"

# Check if source directory exists
if [ ! -d "$SRC" ]; then
    echo "Error: Source directory '$SRC' does not exist."
    exit 2
fi

# Ensure destination directory exists and run rsync
if [ ! -d "$DEST" ]; then
    mkdir -p "$DEST"
fi

# Run rsync with progress and verbose output
rsync -avh \
    --no-times \
    --progress \
    --exclude='@eaDir/' \
    --exclude='.DS_Store' \
    --exclude='.AppleDouble/' \
    --exclude='.AppleDB' \
    --exclude='.Spotlight-V100/' \
    --exclude='.Trashes/' \
    --exclude='.thumbnails/' \
    "$SRC" \
    "$DEST"

