#!/bin/bash -l


#SBATCH --kill-on-invalid-dep=no
#SBATCH --output=/home/djp94/palmer_scratch/cellP/Outputfolder/Batch-%A_%a.out
#SBATCH --time=9:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=50G
#SBATCH --partition=day
#SBATCH --array=1-7

# Output directory
output=/home/djp94/palmer_scratch/cellP/

# Maximum folder size in bytes (10GB = 10737418240 bytes)
MAX_FOLDER_SIZE=10737418240

# Create initial results folder
mkdir -p $output/Results_1

# Function to find the appropriate results folder
# Returns the path to a results folder with less than 10GB
get_results_folder() {
    local folder_num=1
    local current_folder="$output/Results_${folder_num}"
    
    # Create the first folder if it doesn't exist
    if [ ! -d "$current_folder" ]; then
        mkdir -p "$current_folder"
        echo "$current_folder"
        return
    fi
    
    # Check if the current folder is below size limit
    while [ -d "$current_folder" ]; do
        # Get folder size in bytes
        local folder_size=$(du -sb "$current_folder" | awk '{print $1}')
        
        if [ "$folder_size" -lt "$MAX_FOLDER_SIZE" ]; then
            # Current folder is below limit, use it
            echo "$current_folder"
            return
        else
            # Current folder is full, try next one
            folder_num=$((folder_num + 1))
            current_folder="$output/Results_${folder_num}"
            
            # Create the folder if it doesn't exist
            if [ ! -d "$current_folder" ]; then
                mkdir -p "$current_folder"
            fi
        fi
    done
    
    # Return the last folder created
    echo "$current_folder"
}

# Update nimages with the number of images you are processing
nimages=42 # Total images (3024 images per plate * 7 plates)
iperjob=6 # Images per job/plate



# Load miniconda
module load miniconda

# Load cellprofiler env
conda activate cp4

date
hostname

# Calculate the images this job will perform
FIRST=$(( $iperjob*($SLURM_ARRAY_TASK_ID-1)+1 ))
LAST=$(( $iperjob*$SLURM_ARRAY_TASK_ID ))
if [ "$LAST" -ge $nimages ]; then LAST=$nimages; fi

# Get batch ID for file naming
BATCH_ID=$SLURM_ARRAY_TASK_ID
echo "Processing images $FIRST to $LAST (Batch $BATCH_ID)"

# Create a temporary directory for CellProfiler processing
TEMP_DIR=$(mktemp -d "$output/temp_batch_${BATCH_ID}_XXXX")
echo "Using temporary directory: $TEMP_DIR"

# Run CellProfiler with output to temporary directory
time cellprofiler -p $output/Batch_data.h5 -c -r -o $TEMP_DIR -t $output/tmp -f $FIRST -l $LAST
date

echo "Moving CSV files to appropriate Results folder with unique batch ID: $BATCH_ID"

# Create a file listing with sizes to help with distribution
find "$TEMP_DIR" -name "*.csv" -exec du -b {} \; | sort -nr > "$TEMP_DIR/filesizes.txt"

# Process each file and place it in an appropriate Results folder
total_files=0
while read size file; do
    if [ -f "$file" ]; then
        base_name=$(basename "$file")
        new_name="${base_name%.csv}_Batch_${BATCH_ID}.csv"
        
        # Get appropriate results folder
        results_folder=$(get_results_folder)
        results_num=$(basename "$results_folder" | sed 's/Results_//')
        
        # Copy the file
        cp "$file" "$results_folder/$new_name"
        
        # Verify copy
        if [ $? -eq 0 ]; then
            echo "Copied $base_name to $results_folder/$new_name"
            total_files=$((total_files + 1))
        else
            echo "Error copying $base_name"
        fi
    fi
done < "$TEMP_DIR/filesizes.txt"

echo "Successfully moved $total_files CSV files from Batch $BATCH_ID"

# Provide a summary of the Results folders
echo "Current Results folders and sizes:"
du -h "$output"/Results_* | sort -k2

# Clean up temporary directory
rm -rf $TEMP_DIR
echo "Temporary directory removed. All processing complete."
date
