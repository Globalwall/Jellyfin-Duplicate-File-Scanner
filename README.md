# jellyfin-dupe-scan
A Bash script to scan large media libraries (like Jellyfin's) for duplicate files by hashing the first and last 10MB of each file larger than 20MB. It skips common unwanted extensions to speed up the process. The script reports duplicates, providing a fast and practical way to identify duplicates without hashing entire files.
