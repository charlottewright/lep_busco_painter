
#!/usr/bin/env Rscript
library(tidyverse)
library(optparse)
 

# get args
option_list = list(
  make_option(c("-f", "--file"), type="character", default=NULL, 
              help="location.tsv file", metavar="character"),
    make_option(c("-m", "--merians"), type="character", default="False", 
              help="use this flag if you are comparing spp1 to Merian elements", metavar="character")
); 
 
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);


locations <- read_tsv(opt$file)
merians <- opt$merians

# Reorder factor to plot Merians in ascending order
locations <- locations %>% filter(!grepl(':', query_chr))
locations <- locations %>% filter(!grepl(':', status))


if (merians != "False"){
  merian_order = c('MZ', 'M1', 'M2', 'M3', 'M4', 'M5', 'M6', 'M7', 'M8', 'M9', 'M10', 'M11', 'M12', 'M13', 'M14', 'M15', 'M16', 'M17', 'M18', 'M19', 'M20','M21', 'M22', 'M23', 'M24', 'M25', 'M26', 'M27', 'M28', 'M29', 'M30')
  locations$status_f = factor(locations$status, levels=merian_order)
} else {
  order_list = unique(locations$status)
  order_list = order_list [! order_list %in% "self"]
  locations$status_f = factor(locations$status, levels=order_list)
  print(order_list)




}



p <- locations %>%
  ggplot() +
  geom_rect(aes(xmin=position-2e4, xmax=position+2e4, ymax=0, ymin =10, fill=status_f)) +
  facet_wrap(query_chr ~ ., ncol=1, strip.position="right") + guides(scale="none") +
  xlab("Position (Mb)") +
  scale_x_continuous(labels=function(x)x/1e6, expand=c(0.005,0)) +
  scale_y_continuous(breaks=NULL) + labs(fill = "Merian Unit") +
  theme(text = element_text(size=10), strip.text.y = element_text(angle = 0), strip.text.x = element_text(margin = margin(0,0,0,0, "cm")), panel.background = element_rect(fill = "white", colour = "black"), panel.grid.major = element_blank(), panel.grid.minor = element_blank())

# Save results
ggsave(paste(as.character(opt$file), "_buscopainter.png", sep = ""), plot = p, width = 15, height = 30, units = "cm", device = "png")
pdf(NULL)
ggsave(paste(as.character(opt$file), "_buscopainter.pdf", sep = ""), plot = p, width = 15, height = 30, units = "cm", device = "pdf")


