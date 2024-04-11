#!/bin/bash

# Get the directory of the script
dir="$(dirname "$0")"

# Create an array to hold the names of iso, cue, and bin files to be deleted
declare -a to_delete

# Iterate over each .iso, .cue, and .bin file in the directory
for file in "$dir"/*.iso "$dir"/*.cue "$dir"/*.bin; do
    # Get the base name of the file (without extension)
    base="${file%.*}"

    # Convert to chd
    echo "Converting $file to $base.chd..."
    chdman createcd -i "$file" -o "$base.chd"

    # If the conversion was successful, add the file to the deletion array
    if [ $? -eq 0 ]; then
        echo "Conversion successful, marking $file for deletion..."
        to_delete+=("$file")
    else
        echo "Conversion of $file failed."
    fi
done

# Delete all marked files
for file in "${to_delete[@]}"; do
    echo "Deleting $file..."
    rm "$file"
done