#!/bin/bash -l

######CHANGE: <userName> to your individual user name for the cluster you are on in the line below. Exact protocol may vary depending on the specific cluster you're using.
#SBATCH --kill-on-invalid-dep=no
#SBATCH --output=/home/djp94/palmer_scratch/cellP/Outputfolder/Batch-%A_%a.out
#SBATCH --time=9:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=50G

######CHANGE: -array=1-<X> where X is the number of plates you are analyzing in total. In this case, we are analyzing 10 plates.
#SBATCH --array=1-6
#SBATCH --partition=day

###### Update this to the folder you wish to send the output to. CHANGE <userName> and <OutputFile> to your individual username on the cluster and the folder you are using to output files, respectively.
output=/home/djp94/palmer_scratch/cellP/

# Create a single results folder for all output
mkdir -p $output/Results

# Update nimages with the number of images you are processing
nimages=18144 #Change to total number of images (each plate has 3024 images, multiply by number of plates.) #Currently set for analyzing 6 plates with 3024 images each
iperjob=3024

#Load miniconda
module load miniconda

#load cellprofiler env and run batched analysis
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

# Move ONLY CSV files to final destination with batch ID in filename
echo "Moving CSV files to Results folder with unique batch ID: $BATCH_ID"

# Move only CSV files to the Results folder with batch ID in the filename
find $TEMP_DIR -name "*.csv" -exec bash -c 'fname=$(basename "$0"); mv "$0" "'$output'/Results/${fname%.*}_Batch_'$BATCH_ID'.csv"' {} \;

# Count how many CSV files were moved
CSV_COUNT=$(find $output/Results -name "*_Batch_${BATCH_ID}.csv" | wc -l)
echo "Moved $CSV_COUNT CSV files to Results folder"

# Clean up temporary directory
rm -rf $TEMP_DIR
echo "Temporary directory removed. All processing complete."
date
