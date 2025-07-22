# Jellyfin Duplicate File Scanner

This Bash script scans large media libraries—such as those used by Jellyfin—for duplicate files efficiently. It targets files larger than 20MB, skipping smaller files and common unwanted extensions to save time and resources.

## How It Works

- Uses partial hashing by reading the **first 10MB** and **last 10MB** of each eligible file.
- Skips files smaller than 20MB and files with unwanted extensions (e.g., `.jpg`, `.srt`).
- Compares combined hashes and file sizes to identify duplicates without hashing the entire file.
- Reports duplicate files for easy cleanup and library optimization.

## Usage

./find_dupes.sh /path/to/media/library
