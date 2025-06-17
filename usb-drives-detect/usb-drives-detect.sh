#!/usr/bin/env bash

echo "Detecting USB storage devices..."

# Use lsblk to find USB-attached block devices
usb_devices=$(lsblk -o NAME,TRAN,TYPE,SIZE -dn | awk '$2 == "usb" && $3 == "disk" {print $1}')

if [ -z "$usb_devices" ]; then
    echo "No USB storage devices found."
    exit 0
fi

for dev in $usb_devices; do
    devpath="/dev/$dev"
    echo "----------------------------"
    echo "Device: $devpath"

    # Size from lsblk
    size=$(lsblk -dn -o SIZE "$devpath")
    echo "Size: $size"

    # Get udev info
    udevinfo=$(udevadm info --query=property --name="$devpath")

    # Try to extract port speed
    usbpath=$(echo "$udevinfo" | grep DEVPATH | cut -d= -f2)
    usbdev=$(echo "$usbpath" | grep -o 'usb[0-9]/[0-9-]*' | head -n1)

    if [ -n "$usbdev" ] && [ -e "/sys/bus/usb/devices/$usbdev/speed" ]; then
        speed=$(cat "/sys/bus/usb/devices/$usbdev/speed")
        echo "Port Speed: ${speed} Gbps"
    else
        echo "Port Speed: Unknown"
    fi

    # Optional USB metadata
    model=$(echo "$udevinfo" | grep ID_MODEL= | cut -d= -f2)
    vendor=$(echo "$udevinfo" | grep ID_VENDOR= | cut -d= -f2)
    echo "Vendor: $vendor"
    echo "Model: $model"
done
