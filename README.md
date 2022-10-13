# Lep busco painter
Paints chromosomes of lepidopteran genomes with BUSCOs.

### Installation

```
conda env create -n buscopaint python=3.9 
conda activate buscopaint
conda install samtools 
conda install -c conda-forge r-base
conda install -c r r-tidyverse
conda install -c bioconda r-optparse
```


### Running the scripts

1. Assign each BUSCO to a chromosome
buscopainter.py takes the full_table.tsv output file for a "reference" species and a "query" species, along with an optional prefix (specified with -p, default "buscopainter"), e.g.:

```
# Assign each complete and duplicated BUSCO to a chr and state if it belongs to the dominant group of BUSCOs per chr ('self') or not
python3 buscopainter.py -r test_data/ilAglIoxx1_full_table.tsv -q test_data/ilApoTurb1_full_table.tsv
```

It will write two TSV files:

- `[PREFIX]_complete_summary.tsv` which contains a summary of the chromosomal assignments
- `[PREFIX]_complete_location.tsv` which contains the location and status of all shared complete BUSCOs. This file can be plotted using plot_locations.R
- `[PREFIX]_duplicated_location.tsv` which contains the location and status of all duplicated BUSCOs. This file can be plotted using plot_locations.R


2. Plotting
The `[PREFIX]_location.tsv` can be plotted as follows:

```
# Basic plotting - plot position of each BUSCO along each chr. Colour BUSCO by chr identity. Each chr is a box of fixed size
Rscript --vanilla plot_locations.R buscopainter_location.tsv
# Plot all BUSCOs along chr but only colour BUSCOs that do not belong to the dominant chr.
Rscript --vanilla plot_locations_onlydiff.R buscopainter_location.tsv -m True
# Plot all BUSCOs along chr but only colour BUSCOs that do not belong to the dominant chr. Draw chr proportional to actual size. 
# NB: The `-m` flag is optional. Specify 'True' if you are comparing an extant species to Merian elements. Do not use if comparing two extant species.
Rscript --vanilla plot_locations_onlydiff_scaled.R buscopainter_location.tsv fasta.fai prefix
```

NB: `fasta.fai` generated via `samtools faidx fasta`.
