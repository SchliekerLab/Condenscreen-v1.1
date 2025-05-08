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
mkdir $output/Batch-"$SLURM_ARRAY_TASK_ID"

# Update nimages with the number of images you are processing
nimages=18144 #Change to total number of images (each plate has 3024 images, multiply by number of plates.) #Currently set for analyzing 6 plates with 3024 images each
iperjob=6

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
echo "Processing images $FIRST to $LAST"


time cellprofiler -p $output/Batch_data.h5 -c -r -o $output/Batch-"$SLURM_ARRAY_TASK_ID" -t $output/tmp -f $FIRST -l $LAST date
#time cellprofiler -p $output/Batch_data.h5 -c -r -t $output/tmp -f $FIRST -l $LAST
date
