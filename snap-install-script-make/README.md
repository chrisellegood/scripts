# Snap Package Export & Reinstall Script

This project provides a Bash script that generates a reinstallation script (`snap-reinstall.sh`) for all currently installed Snap packages on your system. It ensures:

- Snap names are preserved
- `--classic` confinement is respected
- The current channel (e.g., `stable`, `beta`, `edge`) is tracked

---

## 🔧 Script: `export-snaps.sh`

This script automates the process of generating a backup installer for your Snap packages.

### How It Works

1. **Reads Installed Snaps**  
   Uses `snap list` to gather a list of all installed Snap packages.

2. **Checks Confinement**  
   For each package, it queries `snap info` and checks if the package is using `classic` confinement. If so, it adds the `--classic` flag to the reinstall command.

3. **Detects Current Channel**  
   The current tracking channel (e.g., `latest/stable`, `latest/edge`, etc.) is extracted and included using the `--channel` flag if it differs from the default (`latest/stable`).

4. **Generates `snap-reinstall.sh`**  
   A shell script is created with all necessary install commands.

5. **Makes Script Executable**  
   The output script is given execution permissions using `chmod +x`.

---

## 📁 Output Example

Here is a sample of the generated `snap-reinstall.sh`:

```bash
#!/bin/bash

# Auto-generated snap reinstall script

sudo snap install code --classic
sudo snap install chromium --channel=latest/edge
sudo snap install postman --classic --channel=beta
sudo snap install vlc
