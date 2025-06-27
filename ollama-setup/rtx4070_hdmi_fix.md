# Fixing No HDMI Output on Ubuntu with NVIDIA RTX 4070 and a JVC TV

## Overview

After installing an NVIDIA GeForce RTX 4070 in my Ubuntu system, I encountered a complete loss of HDMI signal after installing the proprietary driver (`nvidia-driver-570`). The system would boot, but my **JVC TV**, connected via HDMI, would receive no video signal. 

The root issue was that the NVIDIA driver failed to detect or initialize the HDMI display unless a valid EDID (Extended Display Identification Data) was available at boot.

This guide documents how I resolved the issue by extracting the real EDID from the JVC TV and configuring Xorg to use it. The result is a stable graphical display on every boot.

---

## System Configuration

- **GPU**: NVIDIA GeForce RTX 4070
- **Display**: JVC Roku TV (connected via HDMI)
- **OS**: Ubuntu 24.04 LTS
- **Driver**: `nvidia-driver-570` (proprietary)
- **Display server**: Xorg

---

## Symptoms

- Black screen or “no signal” on TV after booting into Ubuntu
- No fallback to low-res modes
- System was otherwise functional (reachable via SSH or Ctrl+Alt+F3)

---

## Solution

### Step 1: Extract the Real EDID

Install tools:

```bash
sudo apt install read-edid edid-decode
```

Extract and save the EDID:

```bash
sudo get-edid > ~/real-edid.bin
```

(Optional) Decode it to verify:

```bash
edid-decode ~/real-edid.bin
```

This confirmed that the JVC TV supports multiple video resolutions and provides a valid EDID with standard HDMI modes.

### Step 2: Copy the EDID for Xorg

Move the EDID to the system X11 directory:

```bash
sudo mkdir -p /etc/X11
sudo cp ~/real-edid.bin /etc/X11/edid.bin
```

---

### Step 3: Configure Xorg

Create or edit `/etc/X11/xorg.conf` with the following content:

```conf
Section "Device"
    Identifier     "Nvidia Card"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BusID          "PCI:1:0:0"
    Option         "AllowEmptyInitialConfiguration"
    Option         "ConnectedMonitor" "HDMI-0"
    Option         "CustomEDID" "HDMI-0:/etc/X11/edid.bin"
    Option         "UseDisplayDevice" "HDMI-0"
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "Nvidia Card"
    Monitor        "Monitor0"
    DefaultDepth    24
    SubSection     "Display"
        Depth       24
        Modes      "1920x1080_60.00"
    EndSubSection
EndSection
```

This configuration:
- Forces the NVIDIA driver to use the EDID file
- Treats HDMI-0 as the always-connected display
- Avoids relying on automatic detection (which may fail with some TVs)

---

### Step 4: Reboot and Confirm

Reboot the system:

```bash
sudo reboot
```

After reboot:
- The display should initialize correctly with HDMI signal active
- You should land in a graphical desktop at your target resolution (e.g., 1920x1080)
- `nvidia-smi` should report an active GPU session

---

## Result

With this setup:
- HDMI display works consistently across reboots
- Full GPU acceleration is available
- No need for a fallback dummy EDID
- The system is stable and visually responsive

This approach resolved persistent display issues caused by incomplete or late EDID negotiation between the NVIDIA 40-series card and a consumer television. Using the TV's actual EDID ensures compatibility without sacrificing resolution or performance.

---

## Files Used

- `/etc/X11/edid.bin` — binary EDID file captured from the JVC TV
- `/etc/X11/xorg.conf` — custom Xorg configuration to load the EDID and initialize HDMI-0

---

## Notes

This guide is applicable to other consumer televisions (including Roku TVs or older HDTVs) which may provide incomplete or delayed EDID data. It is also likely relevant for other NVIDIA RTX 40-series GPUs using proprietary drivers on Linux.
