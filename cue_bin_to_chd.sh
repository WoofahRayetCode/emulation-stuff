#!/bin/bash

# Get the directory of the script
dir="$(dirname "$0")"

# Create an array to hold the names of bin and cue files to be deleted
declare -a to_delete

# Iterate over each .cue file in the directory
for cuefile in "$dir"/*.cue; do
    # Get the base name of the file (without extension)
    base="${cuefile%.*}"

    # Convert to chd
    echo "Converting $cuefile to $base.chd..."
    chdman createcd -i "$cuefile" -o "$base.chd"

    # If the conversion was successful, add the bin and cue files to the deletion array
    if [ $? -eq 0 ]; then
        echo "Conversion successful, marking $cuefile and all .bin files for deletion..."
        to_delete+=("$cuefile")
        for binfile in "$dir"/*.bin; do
            to_delete+=("$binfile")
        done
    else
        echo "Conversion of $cuefile failed."
    fi
done

# Delete all marked files
for file in "${to_delete[@]}"; do
    echo "Deleting $file..."
    rm "$file"
done