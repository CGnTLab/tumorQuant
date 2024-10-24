#!/bin/bash

# Full path to the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default atlas directory
atlas_dir="${SCRIPT_DIR}/../atlases/talairach"

# Check if the correct number of arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <sample> <segmented_tumor.nii.gz> <output_directory>"
    exit 1
fi

# Assign the segmented tumor file and output directory
sample=$1
segmented_tumor=$2
output_dir=$3
# Create the output directory if it doesn't exist
#mkdir -p $output_dir

# Loop through the "mni" atlases
for i in $(seq 1 100); do
    # Multiply the extracted region with the atlas
    fslmaths $atlas_dir/talairach_$i.nii.gz \
        -mul $segmented_tumor \
        $output_dir/Talairach/result_$i.nii.gz

    # Threshold the result
    fslmaths $output_dir/Talairach/result_$i.nii.gz \
        -thr 0.5 -bin $output_dir/Talairach/overlapping_regions_$i.nii.gz

    # Calculate volume
    fslstats $output_dir/Talairach/overlapping_regions_$i.nii.gz \
        -V >> $output_dir/Talairach/volume
done
# Process the volume data
sed 's/ /,/g' "$output_dir/Talairach/volume" > "$output_dir/Talairach/Talairach_volume"
awk -F, '{ print $1 }' "$output_dir/Talairach/Talairach_volume" > "$output_dir/Talairach/Talairach_volume_temp"
paste -d',' "$atlas_dir/talairach_labels.txt" "$output_dir/Talairach/Talairach_volume" > "$output_dir/Talairach/Talairach_volume.csv"

# Clean up temporary files
rm "$output_dir/Talairach/Talairach_volume_temp"
rm "$output_dir/Talairach/volume"
rm "$output_dir/Talairach/Talairach_volume"
mv $output_dir/Talairach/Talairach_volume.csv $output_dir/
