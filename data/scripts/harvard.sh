#!/bin/bash

# Full path to the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default atlas directory
atlas_dir="${SCRIPT_DIR}/../atlases/Harvard_subcortical"

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <sample> <segmented_tumor.nii.gz> <output_directory>"
    exit 1
fi

# Assign the arguments
sample=$1
segmented_tumor=$2
output_dir=$3

# Create the output directory if it doesn't exist
#mkdir -p "$output_dir/$sample"

# Loop through the "harvard" atlases
for i in $(seq 1 21); do
    # Multiply the extracted region with the atlas
    fslmaths "$atlas_dir/Harvard_subcortical_$i.nii.gz" \
        -mul "$segmented_tumor" \
        "$output_dir/Harvard/result_$i.nii.gz"

    # Threshold the result
    fslmaths "$output_dir/Harvard/result_$i.nii.gz" \
        -thr 0.5 -bin "$output_dir/Harvard/overlapping_regions_$i.nii.gz"

    # Calculate volume
    fslstats "$output_dir/Harvard/overlapping_regions_$i.nii.gz" \
        -V >> "$output_dir/Harvard/volume"
done

# Process the volume data
sed 's/ /,/g' "$output_dir/Harvard/volume" > "$output_dir/Harvard/Harvard_volume"
awk -F, '{ print $1 }' "$output_dir/Harvard/Harvard_volume" > "$output_dir/Harvard/Harvard_volume_temp"
paste -d',' "$atlas_dir/harvard_subcortical_labels.txt" "$output_dir/Harvard/Harvard_volume" > "$output_dir/Harvard/Harvard_volume.csv"

# Clean up temporary files
rm "$output_dir/Harvard/Harvard_volume_temp"
rm "$output_dir/Harvard/volume"
rm "$output_dir/Harvard/Harvard_volume"

mv $output_dir/Harvard/Harvard_volume.csv $output_dir/

