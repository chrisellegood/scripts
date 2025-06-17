#!/bin/bash

# Script to update and upgrade Ubuntu system, with timestamped logging and system metadata

# Get current timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Define log file path with timestamp
LOGFILE="/var/log/update-system_$TIMESTAMP.log"

# Ensure script is run with sudo privileges
if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root or use sudo."
  exit 1
fi

# Gather system metadata
metadata=$(cat <<EOF
===== System Metadata =====
Timestamp: $(date +"%Y-%m-%d %H:%M:%S")
Hostname: $(hostname)
OS: $(lsb_release -ds 2>/dev/null || grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')
User: $(whoami)
Kernel: $(uname -r)
Architecture: $(uname -m)
Snap version: $(snap version | awk '/snapd/ {print $2}')
Locale: $(locale | awk -F= '/^LANG=/{print $2}')
Uptime: $(uptime -p | cut -d " " -f2-)
Snap refresh schedule: $(snap refresh --time 2>/dev/null | grep "paused" || echo "no refresh hold")
===========================

EOF
)

# Create log file and set permissions
touch "$LOGFILE"
chmod 644 "$LOGFILE"

# Log metadata
echo "$metadata" | tee -a "$LOGFILE"

# Begin update process
echo "===== System update started at $(date) =====" | tee -a "$LOGFILE"

# Update the package list
echo "Running apt update..." | tee -a "$LOGFILE"
apt update | tee -a "$LOGFILE"

# Upgrade all upgradable packages
echo "Running apt upgrade..." | tee -a "$LOGFILE"
apt upgrade -y | tee -a "$LOGFILE"

# Optionally, run full upgrade
# echo "Running apt full-upgrade..." | tee -a "$LOGFILE"
# apt full-upgrade -y | tee -a "$LOGFILE"

# Remove unnecessary packages
echo "Running apt autoremove..." | tee -a "$LOGFILE"
apt autoremove -y | tee -a "$LOGFILE"

# Completion message
echo "System update complete at $(date)." | tee -a "$LOGFILE"
echo "==============================================" | tee -a "$LOGFILE"