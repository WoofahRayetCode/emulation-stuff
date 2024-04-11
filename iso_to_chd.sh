#!/bin/bash

# Get the directory of the script
dir="$(dirname "$0")"

# Create an array to hold the names of iso files to be deleted
declare -a to_delete

# Iterate over each .iso file in the directory
for isofile in "$dir"/*.iso; do
    # Get the base name of the file (without extension)
    base="${isofile%.*}"

    # Convert to chd
    echo "Converting $isofile to $base.chd..."
    chdman createcd -i "$isofile" -o "$base.chd"

    # If the conversion was successful, add the iso file to the deletion array
    if [ $? -eq 0 ]; then
        echo "Conversion successful, marking $isofile for deletion..."
        to_delete+=("$isofile")
    else
        echo "Conversion of $isofile failed."
    fi
done

# Delete all marked files
for file in "${to_delete[@]}"; do
    echo "Deleting $file..."
    rm "$file"
done