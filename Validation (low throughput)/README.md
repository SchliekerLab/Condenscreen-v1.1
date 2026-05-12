# Validation (Low Throughput) Pipeline

This folder contains scripts and resources for the Validation (low throughput) pipeline in the Condenscreen project.

## Overview

The Validation pipeline provides a minimal, quick analysis of smaller datasets that do not require plate size or screening statistics. It is intended for low-throughput validation experiments, allowing for efficient analysis of condensate data.

There are two versions available in this folder:
- **Standard Validation:** Fast and suitable for most small datasets.
- **SizeArea Versions:** Offer more detailed analysis at the cost of increased computational resources.

## Outputs and Key Metrics

The pipeline determines the following labels (for each tested condition):

- **Area:** The pixel area of each detected condensate.
- **Integrated Intensity:** The sum of pixel intensities within each condensate.
- **Mean Intensity:** The average pixel intensity within the condensate.
- **Compactness:** The mean squared distance of the object’s pixels from the centroid, divided by the area.

## Workflow Instructions

Follow these steps to process your data and generate summary statistics and figures:

### 1. Download and Prepare Project Files
- Download and open the desired `.cpproj` file using the appropriate software:
  - **Condenscreen_Validation (standard)** – for standard analysis.
  - **SizeArea** – for condensate feature resolution.
- Import your raw images into the project via the **Images** tab within the .cpproj file.
- In the analysis pipeline, locate the **ExportToSpreadsheet** module (or equivalent).
  - Edit the output folder locations to specify where you want the results saved.

### 2. Set Up and Edit the Analysis Notebook
- Download the corresponding `.Rmd` (R Markdown) file for your analysis.
- Open the `.Rmd` file in RStudio or your preferred R environment.
- Edit the following parameters in the script:
  - Update the `pathName` variable to point to the folder where your exported spreadsheets are located.
  - Edit the `replace_names_2` function to include the variable names you are interested in analyzing.
  - Update the `combined_Df$Drug` (or other tested condition columns) to reflect the names of the experimental conditions used in your dataset.

### 3. Run Analysis and Produce Results
- Knit or run the `.Rmd` file to generate outputs.
- The analysis will produce an Excel spreadsheet containing relevant summary statistics, as well as figures.
- All output files will be saved in the folder you specified during setup.

---

**Tip:** Double-check all file paths and variable names before running the analysis to ensure successful processing.
