#!/bin/bash

# Full path to the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <sample> <segmented_tumor.nii.gz> <output_directory>"
    exit 1
fi

# Assign the arguments
sample=$1
segmented_tumor=$2
output_dir=$3

# Create the "all" output directory
output_dir_all="${output_dir}/all"
mkdir -p "$output_dir_all/MNI"
mkdir -p "$output_dir_all/Juelich"
mkdir -p "$output_dir_all/Talairach"
mkdir -p "$output_dir_all/Harvard"

# Run the MNI script
echo ""
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep "$pid")" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

COMPLETED_COLOR="\e[3;32m"  
RESET_COLOR="\e[0m"       

# Run the MNI script
echo ""
echo ""
echo -n "Executing MNI atlas analysis...  "
"${SCRIPT_DIR}/mni.sh" "$sample" "${output_dir}/${sample}_ROI.nii.gz" "$output_dir_all" &
mni_pid=$!
spinner $mni_pid
wait $mni_pid
echo -e "${COMPLETED_COLOR}Completed successfully.${RESET_COLOR}"
echo ""
echo ""

# Run the Juelich script
echo -n "Executing Juelich atlas analysis... "
"${SCRIPT_DIR}/juelich.sh" "$sample" "${output_dir}/${sample}_ROI.nii.gz" "$output_dir_all" &
juelich_pid=$!
spinner $juelich_pid
wait $juelich_pid
echo -e "${COMPLETED_COLOR}Completed successfully.${RESET_COLOR}"
echo ""
echo ""

# Run the Talairach script
echo -n "Executing Talairach atlas analysis... "
"${SCRIPT_DIR}/talairach.sh" "$sample" "${output_dir}/${sample}_ROI.nii.gz" "$output_dir_all" &
talairach_pid=$!
spinner $talairach_pid
wait $talairach_pid
echo -e "${COMPLETED_COLOR}Completed successfully.${RESET_COLOR}"
echo ""
echo ""

# Run the Talairach script
echo -n "Executing Harvard-Subcortical atlas analysis... "
"${SCRIPT_DIR}/harvard.sh" "$sample" "${output_dir}/${sample}_ROI.nii.gz" "$output_dir_all" &
harvard_pid=$!
spinner $harvard_pid
wait $harvard_pid
echo -e "${COMPLETED_COLOR}Completed successfully.${RESET_COLOR}"
echo ""
echo ""

#echo "${output_dir}/${sample}_ROI.nii.gz"
