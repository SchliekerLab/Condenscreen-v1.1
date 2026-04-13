# CondenScreen

## High-Throughput Image Analysis and Statistical Pipeline for Quantifying Condensates

**CondenScreen** is a robust, open-source pipeline developed to analyze condensate phenotypes in immunofluorescence images. Developed by the Schlieker Lab, the program leverages [CellProfiler 4.2.6] for image segmentation and R for statistical analysis. 

<div align="center">
  <img src="Demo/images/condenscreenLogo.png" width="300" />
</div>

#### Version 1.3

---

## Overview

This repository includes:

- A **CellProfiler pipeline** to quantify & segment condensate foci/puncta into single cells
- A **Bash script** to batch-process image sets across a computing cluster (in this case Yale's YCRC)
- An **R script** for statistical analysis of foci, cell count, and screen-wide normalization using Z-, B-, and BZ-scores, depending on indication.
- A trained supervised machine learning approach to characterize distinct condensate phenotypes from microscopy data
   - The CondensateML notebook also includes a saliency-mapping module that generates heatmap overlays on single-cell images to highlight regions that most influence model predictions and aid interpretation.
- A Graphical User Interface allowing well-selection and automated code alterations depending on if screen had a signal-ON vs signal-OFF readout.
- Tools for hit identification & automated data visualization output.
   - Quality Control (QC) measures are applied at multiple stages (image-segmentation quality checks, per-plate normalization, and replicate-consistency metrics) and QC flags are summarized in output reports to help users assess data reliability.
   
   - The pipeline also includes chemical triage filtering for small-molecule screens (PAINS and other reactive/promiscuous substructure filters) to flag likely false positives; filtered and flagged compounds are included in output tables to help prioritize high-confidence candidates for follow-up validation.
  - Optional structural clustering of screening hits using pairwise Tanimoto similarity computed from ECFP4 fingerprints, enabling scaffold-aware prioritization during triage.

Originally developed to analyze MLF2-GFP foci, the pipeline can be adapted for other foci types and imaging setups.

---

## Installation & Setup

### 1. Install Required Software

- [Download R](https://cran.r-project.org/)
- [Download RStudio](https://posit.co/download/rstudio-desktop/)
- [Download CellProfiler 4.2.6+](https://cellprofiler.org/)

---

## Usage Instructions

### 2. Download Project Files

Download the files listed above into a working directory. Alternatively, clone this repository via:

```bash
git clone https://github.com/your-username/CondenScreen.git
```

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
    
- **Quantification of Intensity, Size, & FormFactor**
  - Nuclei (and optionally foci) have their intensity, size, and formfactor, among many additional variables quantified.
  - All foci data are grouped according to parent cell
  - Data and annotated images exported



- License: Apache License Version 2.0 (January 2004)
- Tested platforms: macOS (Apple M2, macOS 15.5) and Windows 10 (desktop with AMD Ryzen 7 2700X and GeForce RTX 2070)
- No required non-standard hardware
- The project is open-source under the Apache 2.0 license.

System requirements
-------------------
1. Software dependencies and operating systems
   - A modern web browser (latest stable versions of Chrome, Firefox, Edge, or Safari).
   - Access to Python 3.1+ (access to interactive python environment [e.g., Jupyter Notebook] recommended) and R 4.3+ [RStudio recommended].

2. Versions the software has been tested on
   - macOS 15.5 (Ventura / Sonoma — tested on a MacBook Air, Apple M2, 16 GB)
   - Windows 10 (desktop, AMD Ryzen 7 2700X, 64 GB RAM, NVIDIA GeForce RTX 2070)

3. Non-standard hardware
   - None required. The software is designed to run on standard desktop/laptop hardware and in a modern web browser. GPU access recommended.

Installation guide
------------------
A. Open locally 
1. Clone the repository:
   - git clone https://github.com/SchliekerLab/Condenscreen.git

Typical install time on a "normal" desktop computer: < 5 minutes (clone + open).

B. Run via a simple local server (recommended for some browser features)
1. Clone the repository:
   - git clone https://github.com/SchliekerLab/Condenscreen.git
2. Change into the repository directory:
   - cd Condenscreen

- Ensure dependencies are installed by referencing `requirementsPy.txt` (python dependencies) and `requirementsR.txt` (R dependencies)
  - Then install dependencies:
    - For python: conda [or pip] install X
    -For R: install.packages(“X”)

Typical install + serve time on a "normal" desktop computer: < 10 minutes.

----
Instructions to run demo (static web version)
1. Serve the repo as shown above (or open the demo HTML file directly).
2. Navigate to the demo page (e.g., `demo/index.html`) or the main interface.
3. Follow instructions in the associated README.md

--------------------
How to run the software on your data (general guidance)
1. Import raw microscopy images into CellProfiler pipeline (Condenscreen/DownloadCondenScreen/CondenScreen.cpproj). Update CellProfiler pipeline to account for your particular data structure (e.g., if only two channels you would remove channel three as it is not needed) and update all pathnames to save to your personal output directory. Update metadata as needed. Configure thresholding and analysis options as indicated.
2. Using the .rmd script (Condenscreen/DownloadCondenScreen/ CondenScreen.Rmd) and R Script (Condenscreen/DownloadCondenScreen/process_batch.R) update path names. Import tabular data that was exported from CellProfiler in step #1.
3. Configure any parameters in the UI and run the analysis.
4. Download/export results and figures. Analysis complete.

Expected outputs
----------------
- Visualizations and downloadable result files (.xlsx / .png or .tif). 
- Rank ordered list of gene or chemical hits.


Reproduction instructions
----------------
Please refer to the methods section of the associated manuscript to ensure all parameters (thresholding, size, etc.) are exactly the same when running demo data. Update and adjust as needed when analyzing independent datasets.

The data in associated manuscript used the following versions of main software dependencies:
  - R version 4.3.3 
  - R Studio (Version 2023.12.1+402)
  - CellProfiler 4.2.6
  - IPython: 8.20.0 
  - Python 3.11.8 (packaged by conda-forge)


Repository structure  
-----------------------------
- Demo/— demo pages and demo data
- CondensateML/ — trained machine learning model to distinguish condensate 
- DownloadCondenScreen/ — main CondenScreen scripts and custom CellProfiler pipeline




License
-------
This project is released under the Apache License Version 2.0, January 2004. See the LICENSE file for full terms.
