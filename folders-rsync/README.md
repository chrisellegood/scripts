# Folder Sync and Backup Scripts

## Overview

This repository contains two Bash scripts designed to facilitate the synchronization of folders, primarily for backup purposes.

### 1. `folders-sync.sh`

This script synchronizes the contents of a source directory to a destination directory using `rsync`.

#### Usage

```bash
./folders-sync.sh <source_directory> <destination_directory>
```

#### Behavior

- Validates the number of arguments (requires exactly 2).
- Checks if the source and destination directories exist.
- Executes `rsync` with options:
  - `-a`: archive mode (preserves symbolic links, permissions, etc.)
  - `-v`: verbose output
  - `-h`: human-readable numbers
  - `--progress`: shows progress during transfer

---

### 2. `backup-run.sh`

This script is a convenience wrapper around `folders-sync.sh`. It defines specific source and destination directories and initiates the sync operation.

#### Behavior

- Defines:
  - `SRC=/media/ellegood/clonezilla/`
  - `DEST=/media/ellegood/ext-store/clonezilla/`
- Calls:
  ```bash
  ./folders-sync.sh "$SRC" "$DEST"
  ```

> Ensure `folders-sync.sh` is in the same directory and executable.

---

## Requirements

- Bash shell
- `rsync` installed and available in the system's PATH

## Notes

- Make scripts executable with: `chmod +x folders-sync.sh backup-run.sh`
- Modify paths in `backup-run.sh` as needed for your environment.