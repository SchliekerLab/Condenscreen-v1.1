# Validation (Low Throughput) Pipeline

This folder contains scripts and resources for the Validation (low throughput) pipeline in the Condenscreen project.

## Overview

The Validation pipeline provides a minimal, quick analysis of smaller datasets that do not require plate size or screening statistics. It is intended for low-throughput validation experiments, allowing rapid assessment of condensate properties across tested conditions.

There are two versions available in this folder:
- **Standard Validation:** Fast and suitable for most small datasets.
- **SizeArea Versions:** Offer more detailed analysis at the cost of increased computational resources.

## Outputs and Key Metrics

The pipeline determines the following labels (for each tested condition):

- **Area:** The pixel area of each detected condensate.
- **Integrated Intensity:** The sum of pixel intensities within each condensate.
- **Mean Intensity:** The average pixel intensity within the condensate.
- **Compactness:** The mean squared distance of the object’s pixels from the centroid, divided by the area.


## Notes
- The pipeline is optimized for small datasets. For high-throughput or plate-based analysis, see the main screening pipeline that features statistical analysis suited for high-throughput screening (Z'/BZ'-Score, CV, S/B, etc.).
- The SizeArea versions require more memory/compute but offer additional detail at the resolution of individual condensate foci.
