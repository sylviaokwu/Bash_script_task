#!/bin/bash

# source and destination directories
SOURCE_DIR="/Users/sylviaokwu/Documents/Scripts"  
DEST_DIR="/Users/sylviaokwu/Documents/Scripts/Json_and_csv"  

function print_message {
    echo "$1"
}

# Move CSV and JSON files from the source directory to the destination directory
for file in "$SOURCE_DIR"/*.{csv,json}; do
    if [ -f "$file" ]; then
        mv "$file" "$DEST_DIR"
        print_message "Moved: $file to $DEST_DIR"
    fi
done

print_message "All CSV and JSON files have been moved."
