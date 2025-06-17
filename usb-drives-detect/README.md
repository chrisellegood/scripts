# USB Storage Device Detection Script

This Bash script detects connected USB storage devices and displays key information about them, including size, port speed (if available), and vendor/model data.

## 🔍 What It Does

- Uses `lsblk` to find USB-attached block storage devices.
- Displays for each USB disk:
  - Device path (e.g., `/dev/sdb`)
  - Device size
  - USB port speed (if detectable)
  - Vendor and model information

## 🛠 How It Works

1. **Device Detection**:
   - `lsblk -o NAME,TRAN,TYPE,SIZE -dn`: Lists block devices.
   - Filters for devices with `TRAN == "usb"` and `TYPE == "disk"`.

2. **For Each Device**:
   - Gathers size via `lsblk`.
   - Extracts device path from `udevadm info`.
   - Attempts to read USB port speed from `/sys/bus/usb/devices/.../speed`.
   - Extracts USB metadata: vendor and model name.

3. **Output Example**:
   ```
   Detecting USB storage devices...
   ----------------------------
   Device: /dev/sdb
   Size: 14.9G
   Port Speed: 5 Gbps
   Vendor: SanDisk
   Model: Cruzer_Glide
   ```

## 🚀 Usage

1. Save the script to a file, e.g., `detect-usb.sh`.

2. Make it executable:
   ```bash
   chmod +x detect-usb.sh
   ```

3. Run the script:
   ```bash
   ./detect-usb.sh
   ```

## ✅ Requirements

- Bash shell
- `lsblk`, `udevadm`, and access to `/sys/bus/usb/devices/` (usually present on modern Ubuntu systems)

## ⚠️ Notes

- Must be run on a system with USB storage devices connected to yield results.
- Port speed may not always be detectable depending on hardware/kernel support.

## 📄 License

This script is released into the public domain. Feel free to modify and redistribute.
