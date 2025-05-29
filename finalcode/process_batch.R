args <- commandArgs(trailingOnly = TRUE)

library(data.table)
# Parse arguments
start_idx <- as.numeric(args[1])
end_idx <- as.numeric(args[2])
batch_number  <- as.numeric(args[3])
file_paths_rds <- args[4]
#file_paths_rds2 <- args[5]
file_Location <- args[5]

# Load the file paths
file_paths <- readRDS(file_paths_rds)

 
cat("Processing batch", batch_number, "files", start_idx, "to", end_idx, "\n")
batch_paths <- file_paths[start_idx:end_idx]

batch_data <- lapply(batch_paths, function(path) {
  cat("Reading file:", path, "\n")
  fread(path, select = c("ImageNumber","ObjectNumber", "FileName_GFP",
                         "AreaShape_Area", "AreaShape_FormFactor", "Children_GFP_foci_Count"), 
        skip = 1, header = TRUE)
})


# Combine and save
combined <- rbindlist(batch_data)
combined <- combined[complete.cases(combined)]

output_file <- paste0(file_Location, "/batch_", 
                      batch_number, ".csv")


fwrite(combined, output_file)


 