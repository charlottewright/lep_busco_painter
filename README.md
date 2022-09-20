# buscopaint
Paints chromosomes with BUSCOs.

### Running the scripts

1. Assign each BUSCO to a chromosome
buscopainter.py takes the full_table.tsv output file for a "reference" species and a "query" species, along with an optional prefix (specified with -p, default "buscopainter"), e.g.:

```
python3 buscopainter.py -r test_data/ilAglIoxx1_full_table.tsv -q test_data/ilApoTurb1_full_table.tsv
```
It will write two TSV files:

- `[PREFIX]_summary.tsv` which contains a summary of the chromosomal assignments
- `[PREFIX]_location.tsv` which contains locations of all shared BUSCOs. This file can be plotted using plot_locations.R

2. Plotting
The [PREFIX]_location.tsv can be plotted as follows:

```
# Basic plotting - plot position of each BUSCO along each chr. Colour BUSCO by chr identity. Each chr is a box of fixed size
Rscript --vanilla plot_locations.R buscopainter_location.tsv
# Plot all BUSCOs along chr but only colour BUSCOs that do not belong to the dominant chr.
Rscript --vanilla plot_locations_onlydiff.R buscopainter_location.tsv
# Plot all BUSCOs along chr but only colour BUSCOs that do not belong to the dominant chr. Draw chr proportional to actual size.
Rscript --vanilla plot_locations_onlydiff_scaled.R buscopainter_location.tsv fasta.fai prefix
```

NB: `fasta.fai` generated via `samtools faidx fasta`.
