# Jellyfin Duplicate File Scanner

This Bash script scans large media libraries—such as those used by Jellyfin—for duplicate files efficiently. It targets files larger than 20MB, skipping smaller files and common unwanted extensions to save time and resources.

## How It Works

- Uses partial hashing by reading the **first 10MB** and **last 10MB** of each eligible file.
- Skips files smaller than 20MB and files with unwanted extensions (e.g., `.jpg`, `.srt`).
- Compares combined hashes and file sizes to identify duplicates without hashing the entire file.
- Reports duplicate files for easy cleanup and library optimization.

## Usage

./find_dupes.sh /path/to/media/library

#⚡ Speed Up Duplicate Scans with Rclone Mount
 ##🔎 Why This Is Useful

When scanning large Jellyfin media libraries for duplicates, hashing directly on slow hardware (like a Raspberry Pi) can take a long time. You have two options:
#🧠 Option 1: Run the script locally on your lightweight media server

Pros:

    Very low power consumption

    Avoids needing to transfer files over the network

Cons:

    Slower hashing due to limited CPU

    I/O speed may be limited on SD cards or HDDs


#💪 Option 2: Use rclone mount to offload the hashing to your main PC

Pros:

    Leverages faster CPU

    Can scan large libraries much faster

    Avoids needing to transfer actual files

Cons:

    Main PC must stay online during scan

    Requires rclone config and mount

🛠️ Quick rclone Setup (Linux)

    📝 Replace remote: with your configured remote name.

1. Install rclone

curl https://rclone.org/install.sh | sudo bash

2. Configure a remote

rclone config

Follow the guided prompts to set up local, SMB, cloud, or other remotes.
3. Mount the remote

rclone mount remote:/your/media/folder /mnt/jellyfin --vfs-cache-mode writes

Keep the terminal open, or background it with &. Optionally, use screen, tmux, or a systemd service.
##✅ Run the dupe scanner

Now just run the script and point it at /mnt/jellyfin:

./find_dupes.sh /mnt/jellyfin
