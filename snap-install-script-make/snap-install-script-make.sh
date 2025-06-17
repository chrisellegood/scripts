#!/bin/bash

# Output script file
output="snap-reinstall.sh"

# Gather system metadata
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
hostname=$(hostname)
os_info=$(lsb_release -ds 2>/dev/null || grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')
user=$(whoami)
kernel=$(uname -r)
arch=$(uname -m)
snap_version=$(snap version | awk '/snapd/ {print $2}')
locale=$(locale | awk -F= '/^LANG=/{print $2}')
uptime=$(uptime -p | cut -d " " -f2-)
refresh_info=$(snap refresh --time 2>/dev/null | grep "paused" || echo "no refresh hold")

# Write script header
{
  echo "#!/bin/bash"
  echo ""
  echo "# Auto-generated snap reinstall script"
  echo "# Generated on: $timestamp"
  echo "# Machine: $hostname"
  echo "# OS: $os_info"
  echo "# User: $user"
  echo "# Kernel: $kernel"
  echo "# Architecture: $arch"
  echo "# Snap version: $snap_version"
  echo "# Snap refresh schedule: $refresh_info"
  echo "# Locale: $locale"
  echo "# Uptime: $uptime"
  echo ""
} > "$output"

# Process installed snaps
snap list | awk 'NR>1 {print $1}' | while read snap; do
  # Detect classic confinement
  classic=$(snap info "$snap" | grep -qE 'tracking:\s+.*classic' && echo "--classic")

  # Get tracking channel
  channel=$(snap info "$snap" | awk '/tracking:/ {print $2}')

  # Output install command
  if [ -n "$channel" ] && [ "$channel" != "latest/stable" ]; then
    echo "sudo snap install $snap $classic --channel=$channel" >> "$output"
  else
    echo "sudo snap install $snap $classic" >> "$output"
  fi
done

# Make script executable
chmod +x "$output"

echo "Snap reinstall script saved as: $output"
