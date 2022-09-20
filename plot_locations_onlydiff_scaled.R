#!/usr/bin/env Rscript

# This script plots BUSCOs across chromosomes where chromosomes are drawn to scale.
# By default, only chromosomes with >3 BUSCOs are plotted in order to filter out shrapnel and chromosomes are plotted in one column
# Can adjust script to adjust stringency of filtering e.g. include chr with just 1 BUSCO or to plot multiple columns.

# Inputs required:
# args[1] = path to locations table
# args[2] = path to fasta.fai (generated via samtools faidx $fasta)
# args[3] = title of plot

library(tidyverse)
library(readr)

# get args
args = commandArgs(trailingOnly=TRUE)
locations <- read_tsv(args[1])
contig_lengths <- read_tsv(args[2], col_names=FALSE)
colnames(contig_lengths) <- c('Seq', 'length', 'offset', 'linebases', 'linewidth')
plot_title <- args[3]
# Format location data 
locations <- locations %>% filter(!grepl(':', query_chr))
locations <- merge(locations, contig_lengths, by.x="query_chr", by.y="Seq")
locations$Length <- locations$length *1000000
locations$start <- 0

# Set mapping of Merian2colour
merian_order = c('self', 'MZ', 'M1', 'M2', 'M3', 'M4', 'M5', 'M6', 'M7', 'M8', 'M9', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19', 'M20','M21', 'M22', 'M23', 'M24', 'M25', 'M26', 'M27', 'M28', 'M29', 'M30')
merian2colour <- c("self"="#999999", "MZ"="#F8766D", "M1"="#F07F4B", "M2"="#E58709", "M3"="#D98F00", "M4"="#CB9700","M5" ="#BA9E00", "M6"="#A7A400", "M7"="#90AA00", "M8"="#74B000", "M9"="#4CB400", "M10"="#00B825", "M11"="#00BC53", "M12"="#00BE72", "M13"="#00C08D", "M14"="#00C1A5", "M15"="#00C0BA", "M16"="#00BECE","M17"="#00BAE0","M18"="#00B4EF", "M19"="#00ADFB","M20" ="#1EA3FF", "M21"="#7498FF", "M22"="#A08CFF", "M23"="#C07FFF", "M24"="#D873FC","M25"="#EA6AF0","M26" ="#F763E1","M27" ="#FE61CE","M28" ="#FF62BA", "M29"="#FF67A3","M30" ="#FF6C91" )

status_merians <- unique(locations$status)
subset_merians <- subset(merian2colour, merian_order %in% status_merians)


# Filter df to only keep query_chr with >1 BUSCO to remove shrapnel
locations_filt <- locations  %>% group_by(query_chr) %>%
  mutate(n_busco = n()) %>% # Make a new column reporting number BUSCOs per query_chr
  ungroup() %>%
  filter(n_busco > 3)

# Num query_chr before filtering
total_contigs <- length(unique(locations$query_chr))
print(paste('Number of contigs before filtering by number of BUSCOs:', total_contigs))
# Num query_chr after filtering
filt_contigs <- length(unique(locations_filt$query_chr))
print(paste('Number of contigs after filtering by num_BUSCOs>3 :', filt_contigs))

# Num query_ chr removed by filtering
num_removed_contigs <- length(unique(locations$query_chr)) - length(unique(locations_filt$query_chr))
print(paste('Number of contigs removed by filtering :', num_removed_contigs))

num_contigs <- as.character(length(unique(locations_filt$query_chr)))


# Adapted plot - plots each chr as a box of correct length
busco_paint <- function(spp_df, num_col, title, karyotype){
  sub_title <- paste("n contigs =", karyotype)
  the_plot <- ggplot(data = spp_df) +
    scale_colour_manual(values=subset_merians, aesthetics=c("colour", "fill")) +
    geom_rect(aes(xmin=start, xmax=length, ymax=0, ymin =12, colour="black"), fill="white") + #colour="black" if don't want to apply red/black to boxes
    geom_rect(aes(xmin=position-2e4, xmax=position+2e4, ymax=0, ymin =12, fill=status)) + # was fill=status_f
    facet_wrap(query_chr ~., ncol=num_col, strip.position="right") + guides(scale="none") +
    xlab("Position (Mb)") +
    scale_x_continuous(labels=function(x)x/1e6, expand=c(0.005,1)) +
    scale_y_continuous(breaks=NULL) + labs(fill = "Merian element") +
    #theme(strip.text.y = element_blank(), # uncomment if want to remove facet i.e. contig labels
    theme(strip.text.y = element_text(angle = 0),
          strip.background = element_blank()) +
    theme(strip.text.x = element_text(margin = margin(0,0,0,0, "cm")), 
          panel.background = element_rect(fill = "white", colour = "white"), 
          panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
    theme(legend.position = "none") +
    theme(axis.line.x = element_line(color="black", size = 0.5)) +
    theme(legend.position="right") + ggtitle(label=title, subtitle= sub_title)  + 
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(plot.subtitle = element_text(hjust = 0.5)) +
    theme(plot.title=element_text(face="italic")) +
    guides(fill=guide_legend("Merian Element"), color = "none")
  return(the_plot)
}

p <- busco_paint(locations_filt, 1, plot_title, num_contigs)

# Save results
ggsave(paste(args[1], "_buscopainter.pdf", sep = ""), plot = p, width = 15, height = 30, units = "cm", device = "pdf")
ggsave(paste(args[1], "_buscopainter.png", sep = ""), plot = p, width = 15, height = 30, units = "cm", device = "png")
