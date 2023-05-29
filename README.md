<<<<<<< HEAD
# FociQuant

## Analysis Pipeline using CellProfiler & R Script for Quantifying Condensates using Microscopy Images.

This repository contains an analysis pipeline and an R script designed to quantify the number of foci in immunofluorescence images. The pipeline utilizes Cell Profiler, an open-source software https://cellprofiler.org/, for image processing and feature extraction. Our studies were looking at MLF2-GFP and Mab414 foci, but the foci readout may be adjusted to your particular analysis. For more information on getting started with cell profiler, see: (Stirling DR, Swain-Bowden MJ, Lucas AM, Carpenter AE, Cimini BA, Goodman A (2021). CellProfiler 4: improvements in speed, utility and usability. BMC Bioinformatics, 22 (1), 433. . PMID: 34507520 PMCID: PMC8431850. doi. pdf.) 

## Features 
* Counts the number of GFP and RFP foci per immunofluorescence image (foci type can be adjusted)
* Calculates the average number of foci per nuclei * Compares the cell readout between cells treated with drugs/siRNA/other and cells treated with DMSO (or other control).
* Provides both boxplots and barplots for visualizing the distribution of foci counts between treated and control groups. * Performs tests for normality on the sample distributions.
* Conducts either a two-tailed unpaired Student's t-test or a Mann-Whitney (Wilcox) test to determine the statistical significance of the observed differences (dependent on normality).
* Exports summary statistics to a combined Excel Workbook.

## Installation and Usage
  1. Preprocess your immunofluorescence images using Cell Profiler analysis pipeline provided.
  2. Run the R script using your preprocessed data.
  3. Customize the R script as needed
=======
# Cell-Profiler-R-Analysis
<<<<<<< HEAD
Cell Profiler Analysis Pipeline and R Script for Counting Foci Immunofluorescence Images
>>>>>>> 0cfa170 (Initial commit)
=======
## Cell Profiler Analysis Pipeline and R Script for Counting Foci Immunofluorescence Images

This repository contains an analysis pipeline and an R script designed to quantify the number of foci in immunofluorescence images. The pipeline utilizes Cell Profiler, an open-source software https://cellprofiler.org/, for image processing and feature extraction. Our studies were looking at MLF2-GFP and Mab414 foci, but the foci readout may be adjusted to your particular analysis.

For more information on getting started with cell profiler, see: (Stirling DR, Swain-Bowden MJ, Lucas AM, Carpenter AE, Cimini BA, Goodman A (2021). CellProfiler 4: improvements in speed, utility and usability. BMC Bioinformatics, 22 (1), 433. . PMID: 34507520 PMCID: PMC8431850. doi. pdf.)

## Features
* Counts the number of GFP and RFP foci per immunofluorescence image (foci type can be adjusted)
* Calculates the average number of foci per nuclei
* Compares the cell readout between cells treated with drugs/siRNA/other and cells treated with DMSO (or other control).
* Provides both boxplots and barplots for visualizing the distribution of foci counts between treated and control groups.
* Performs tests for normality on the sample distributions.
* Conducts either a two-tailed unpaired Student's t-test or a Mann-Whitney (Wilcox) test to determine the statistical significance of the observed differences (dependent on normality).
* Exports summary statistics to a combined Excel Workbook.

## Installation and Usage
1. Preprocess your immunofluorescence images using Cell Profiler analysis pipeline provided.
2. Run the R script using your preprocessed data.
3. Customize the R script as needed for specific data analysis requirements.

## Acknowledgments
We would like to thank the Cell Profiler (https://cellprofiler.org/) and R communities for their invaluable contributions to open-source software development.

### Happy counting and analyzing foci in your immunofluorescence images!




>>>>>>> cf803c8 (Update README.md)
