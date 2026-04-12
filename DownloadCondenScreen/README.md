
# Condenscreen v1.3

## Instructions and Details of the main CondenScreen pipeline:

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
    Z' = 1 - [3(σ_PosCtrl + σ_NegCtrl) / |μ_PosCtrl - μ_NegCtrl|]
    ```

- **Effect and Significance Calculation**
  - **Percent effect (E%)**:
    ```
    E% = ((x̄ - μ) / μ) * 100
    ```
  - Optional residual analysis (percent effect vs tdTomato intensity):
    - We provide an optional residual-analysis workflow to detect and correct intensity-dependent biases in percent-effect values by modeling percent effect as a function of tdTomato intensity (per-image or per-well). Users can fit a robust linear model and potentially rescue putative hits that would have otherwise been labeled as false negatives if the residual indicates a greater percent effect compared to the change in secondary fluorescence. 
  
  - **Z-score**:
    ```
    Z = (E% - μ_E%) / σ_E%
    ```
  - **B-score normalization** (optional):
    - Applies 2-way median polish for intraplate normalization
    - Uses MAD-based normalization:
    ```
    MAD = median(r - median(R))
    ```
  - **Nuclear Health Score**:
    -Applies function to assess deviations in nuclear health relative to control cells
    -Takes into account total number of cells, nuclear area, and morphological changes (form factor)
    ``` 
    Nuclear Health = ∆(Cell Count) + ((100 + ∆(Cell Count)) / 100) ∙ ∑〖(∆Area+ ∆FF)) / 2〗
    ```

  
    
- **Output Includes**
  - Ranked hit lists 
  - Raw and normalized screening distributions
  - Plate heatmaps
  - Z-score/BZ-score plots
    

- **Quality Control**
  
 - **Chemical triage (small-molecule filters)**
  - Chemical triage uses curated substructure rule-sets to flag likely assay-interfering or promiscuous compounds; a `PatWalter.csv` file is included (full credit: Pat Walters — https://github.com/PatWalters/rd_filters) and used as one of the primary filter sources.
    - Rule set / Number of Alerts:
      - BMS — 180
      - Dundee — 105
      - Glaxo — 55
      - Inpharmatica — 91
      - LINT — 57
      - MLSMR — 116
      - PAINS — 479
      - SureChEMBL — 166
      
    - Additionally, compounds are assessed for cytotoxicity observed within the screen and against the Lipinski Rule of 5.
  - Filtered and flagged compounds are annotated in the output tables so users can prioritize follow-up validation on high-confidence candidates.
  
  - **Chemical clustering (optional)**
    - For hit lists from small-molecule screens, an optional chemical-clustering step groups compounds by chemical similarity to identify structure-based families and prioritize representative compounds. Clustering is performed using ECFP4 (Morgan) fingerprints with Tanimoto similarity and hierarchically clustered.
    - Outputs: cluster assignments per compound, cluster-level enrichment summaries, dendrograms and cluster heatmaps, and 2D embeddings (UMAP) for visualization.
    
    Example use-cases: collapse redundant chemotypes in hit lists, identify scaffold-enriched hits, and guide follow-up selection.

 - **Quality Control**
  - Includes the QC analysis added in `CondenScreen.Rmd`: per-plate QC summaries (nuclei counts, signal-to-background, Z' scores), plate heatmaps for controls, and Z' assay quality score 
  - Flags rows, columns, well, and plates that have a statistically enriched hit rate that could be indications of technical biases. 
  - Optionally filters the bottom 50-80% of low-expressing cells to reduce uninduced/non-transfected cells, and removes outlier image sets with strong artifacts.
  - All QC flags and summary tables are exported alongside ranked hit lists to aid review and downstream decision-making.
 
 

---
## Repository Contents

```
CPBatch.sh               # Bash script to run CellProfiler on a SLURM cluster
CondenScreen.Rmd         # Main R markdown script for data analysis and hit calling
CondenScreen_CP.cpproj   # RStudio project file
process_batch.R          # Helper script required by CondenScreen.Rmd
```

---

## Installation & Setup

### 1. Install Required Software

- [Download R](https://cran.r-project.org/)
- [Download RStudio](https://posit.co/download/rstudio-desktop/)
- [Download CellProfiler 4.2.8](https://cellprofiler.org/)

---

## Usage Instructions

### 2. Download Project Files

Download the files listed above into a working directory. Alternatively, clone this repository via:

```bash
git clone https://github.com/your-username/CondenScreen.git
```

---

### 3. Run the CellProfiler Project

- Launch CellProfiler and load the included `.cpproj` file
- Upload your image set:
  - Images are expected to be grouped in sets of 3 channels (DAPI, GFP, RFP)
  - Adjust this as needed based on your imaging setup
  - ***The downstream R script is programmed to analyze images that are labeled in a format similar to: A19942_B01_s1_w1, where:***
      - The first string segment (A19942) correlates to the plate ID
      - The second segment (B01) correlates to Well Location
      - The third segment (s1) correlates to Image Number within that well
      - The fourth segment (w1) correlates to the Channel of the image.
    - If your labeling pattern is different, you may need to adjust string parsing within R code block #4.
       
- Customize foci identification parameters to suit your experiment
- Test pipeline on sample images and confirm segmentation accuracy
- Update the output/export folder path
- Run the pipeline on all images

---

### 4. Analyze Results in R

- Open `CondenScreen.Rmd` in RStudio
- Ensure `process_batch.R` is located in the same folder

#### First-Time Setup:
- Uncomment lines 13–37 to install required R packages
- Run the **first code block** to load dependencies

#### GUI & Data Input:
- Run the **second code block** to launch a GUI
  - Assign well conditions
  - Indicate whether your screen is signal-ON or signal-OFF
  - Choose output directories

#### Save Location & Optional Metadata:
- Update the `save_Location` variable in the **third code block**
- (Optional) If you have metadata linking drug/gene names to well IDs:
  - Update the **fourth code block**
   
---

### 5. Run the Full Analysis

- Run all code blocks in the R Markdown file
- Output will include:
  - Excel file with rank-ordered hit list
  - Plate overview sheet with Z’-scores, S/B ratios, etc.
  - Per-plate control summaries

- Additional outputs:
  - Z-score and BZ-score plots
  - Raw foci count distributions
  - Normalized effect distributions
  - A new folder with per-plate heatmaps for visualization

---


---

### [Optional] Instructions for Running CellProfiler on a Cluster

If processing a large image dataset:
- Upload CPBatch.sh & CondenScreen_CP.cpproj to a new folder within your HPC cluster system
- Customize `CPBatch.sh`:
  - Set correct number of plates and image sets (default: 3024 image sets across 10 plates)
  - Update file paths to match your environment
  - Upload this updated CPBatch.sh file into your newly created folder
- This next part depends on your specific cluster setup. You may need to request access to use CellProfiler on the cluster.
    -Once cellprofiler is installed, activate it and load in pipeline.
    -In our case, once in the correct directory, we used: module load miniconda; conda activate cp4; cellprofiler
- Import raw images to cellprofiler + update paths as required.
- Check "CreateBatchFiles"
- Click "Analyze Images". After a few minutes should get a similar output: "CreateBatchFiles saved pipeline to /home/user_specific/Batch_data.h5
- From command line linked to cluster, navigate to the path where both CPBatch.sh and Batch_data.h5 are located. Run the following command:

```bash
sbatch CPBatch.sh
```

- (optional) Monitor job queue with:
```bash
squeue -u <your_username>
```

- Download the analyzed output files and continue to Step #4.


