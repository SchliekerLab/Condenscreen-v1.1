# CondenScreen

## High-Throughput Image Analysis and Statistical Pipeline for Quantifying Condensates

**CondenScreen** is a robust, open-source pipeline developed to analyze condensate phenotypes in immunofluorescence images. Developed by the Schlieker Lab, the program leverages [CellProfiler 4.2.8](https://cellprofiler.org/) for image segmentation and R for statistical analysis. 

---

## Overview

This repository includes:

- A **CellProfiler pipeline** to quantify & segment condensate foci/puncta into single cells
- A **Bash script** to batch-process image sets across a computing cluster (in this case Yale's YCRC)
- An **R script** for statistical analysis of foci, cell count, and screen-wide normalization using Z-, B-, and BZ-scores, depending on indication.
- A Graphical User Interface allowing well-selection and automated code alterations depending on if screen had a signal-ON vs signal-OFF readout.
- Tools for hit identification & automated data visualization output.

Originally developed to analyze MLF2-GFP foci, the pipeline can be adapted for other foci types and imaging setups.

---

## CellProfiler Image Segmentation Pipeline

We designed a custom image segmentation workflow in CellProfiler 4.2.8:

- **Nuclei Detection**
  - Identified using shape constraints (30–100 pixels)
  - Segmented via *adaptive Minimum Cross-Entropy thresholding* (0.1–1.0)

- **Cytoplasm & Condensate Foci Detection**
  - Enhance foci features to limit background.
  - Foci identified using  *adaptive Otsu thresholding* (0.0175–1.0; 1-10 pixel size)
  - Foci assigned to individual cells via cytoplasm/nuclei mapping
  - 
- **Quantification of Intensity, Size, & FormFactor**
  - Nuclei (and optionally foci) have their intensity, size, and formfactor, among many additional variables quantified.
  - All foci data are grouped according to parent cell
  - Data and annotated images exported
    
### Cluster Deployment (Optional)

For large-scale screens, we developed a simple batch script for high-throughput processing using SLURM and headless CellProfiler runs:

1. Generate batch files using CellProfiler’s `CreateBatchFiles` module
2. Submit jobs using provided `.sh` script
3. Analyze >1 million `.TIFF` images autonomously within hours (dependent on cluster capabilities)

---

## R-Based Statistical Analysis (CondenScreen)

The **CondenScreen** R pipeline includes:

- **Plate Parsing**
  - Graphical user interface to assign controls vs test conditions across plates ranging from 6-well --> 384-well.
  - Groups image sets by well using filename string parsing

- **Quantification Metrics**
  - Imports CellProfiler CSV files batching into sets of 20 files/run to limit slow-down
  - Extracts foci/cell and nuclear statistics reported from CellProfiler
  - Nuclei count per image and aggregate count per condition
  - Signal-to-background (SB)
  - Standard deviation (SD)
  - Coefficient of variation (CV)
  - **Z’ score**:
    ```
    Z' = 1 - [3(σ_PC + σ_NC) / |μ_PC - μ_NC|]
    ```

- **Effect and Significance Calculation**
  - **Percent effect (E%)**:
    ```
    E% = ((x̄ - μ) / μ) * 100
    ```
  - **Z-score**:
    ```
    Z = (E% - μ_E%) / σ_E%
    ```
  - **B-score normalization** (optional):
    - Applies 2-way median polish
    - Uses MAD-based normalization:
      ```
      MAD = median(r - median(R))
      ```

- **Output Includes**
  - Ranked hit lists
  - Raw and normalized screening distributions
  - Plate heatmaps
  - Z-score/BZ-score plots

- **Quality Control**
  - Optionally filters bottom 80% of low-expressing cells to limit either uninduced or non-transfected cells
  - Removes outlier image sets with screening artifacts.
 
 

---

## Installation and Usage

1. Download CellProfiler at: https://cellprofiler.org/
2. Download R + RStudio at: https://posit.co/download/rstudio-desktop/
3. Download all four files in the "Download" folder of this GitHub page.
4. Preprocess your images using the included CellProfiler `.cp` file
5. (Optional) Use the provided SLURM-compatible Bash script for high-throughput processing
6. Run the R scripts on the exported `.csv` output files
7. May need to customize the CellProfiler or R script for specific layouts, controls, or threshold

---
