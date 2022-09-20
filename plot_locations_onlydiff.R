
#!/usr/bin/env Rscript
library(tidyverse)

# get args
args = commandArgs(trailingOnly=TRUE)
locations <- read_tsv(args[1])

# Reorder factor to plot Merians in ascending order
merian_order = c('MZ', 'M1', 'M2', 'M3', 'M4', 'M5', 'M6', 'M7', 'M8', 'M9', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19', 'M20','M21', 'M22', 'M23', 'M24', 'M25', 'M26', 'M27', 'M28', 'M29', 'M30')
locations$status_f = factor(locations$status, levels=merian_order)
locations <- locations %>% filter(!grepl(':', query_chr))

p <- locations %>%
  ggplot() +
  geom_rect(aes(xmin=position-2e4, xmax=position+2e4, ymax=0, ymin =10, fill=status_f)) +
  facet_wrap(query_chr ~ ., ncol=1, strip.position="right") + guides(scale="none") +
  xlab("Position (Mb)") +
  scale_x_continuous(labels=function(x)x/1e6, expand=c(0.005,0)) +
  scale_y_continuous(breaks=NULL) + labs(fill = "Merian Unit") +
  theme(text = element_text(size=10), strip.text.y = element_text(angle = 0), strip.text.x = element_text(margin = margin(0,0,0,0, "cm")), panel.background = element_rect(fill = "white", colour = "black"), panel.grid.major = element_blank(), panel.grid.minor = element_blank())

# Save results
ggsave(paste(args[1], "_buscopainter.pdf", sep = ""), plot = p, width = 15, height = 30, units = "cm", device = "pdf")
ggsave(paste(args[1], "_buscopainter.png", sep = ""), plot = p, width = 15, height = 30, units = "cm", device = "png")


