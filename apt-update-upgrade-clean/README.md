# Ubuntu System Update Script with Metadata Logging

This script automates the update and upgrade process for an Ubuntu-based system. It logs all operations and includes detailed system metadata in each log file for auditing and diagnostics.

## 🔧 Features

- **System Update Automation**:
  - Runs `apt update` to refresh package information.
  - Executes `apt upgrade -y` to upgrade all packages.
  - Optionally includes `apt full-upgrade -y` (commented out).
  - Performs `apt autoremove -y` to clean unused packages.

- **System Metadata Logging**:
  - Captures and logs:
    - Timestamp
    - Hostname
    - OS version
    - Logged-in user
    - Kernel version
    - System architecture
    - Snap version
    - System locale
    - System uptime
    - Snap refresh schedule

- **Timestamped Log Files**:
  - Logs are written to `/var/log/update-system_YYYYMMDD_HHMMSS.log`.

## 🧪 Example Metadata in Log

```
===== System Metadata =====
Timestamp: 2025-06-17 17:01:10
Hostname: my-ubuntu
OS: Ubuntu 22.04.4 LTS
User: user
Kernel: 5.15.0-75-generic
Architecture: x86_64
Snap version: 2.58.3
Locale: en_US.UTF-8
Uptime: 3 hours, 27 minutes
Snap refresh schedule: no refresh hold
===========================
```

## 🚀 Usage

1. **Make the script executable**:
   ```bash
   chmod +x update-system-YYYYMMDD_HHMMSS.sh
   ```

2. **Run the script with sudo**:
   ```bash
   sudo ./update-system-YYYYMMDD_HHMMSS.sh
   ```

3. **View log file**:
   Check the generated log in `/var/log/` directory, e.g.:
   ```bash
   less /var/log/update-system_20250617_170110.log
   ```

## ⚠️ Requirements

- Must be run as root or using `sudo`.
- Tested on Ubuntu 20.04+.

## 📌 Disclaimer

Review the script and logs before applying changes in production environments. Use at your own risk.
