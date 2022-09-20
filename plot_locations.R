#!/usr/bin/env Rscript
library(ggplot2)
library(tidyverse)

# collect args
args <- commandArgs(trailingOnly=TRUE)
locations_table <- read.table(args[1], header=TRUE)

filtered_table <- locations_table %>%
  group_by(query_chr) %>%
  filter(n()>10)

p <- ggplot(filtered_table) +
  geom_rect(aes(xmin=position-2e4, xmax=position+2e4, ymax=0, ymin =10, fill=assigned_chr)) +
  facet_wrap(query_chr ~ ., ncol=1) +
  xlab("Position (Mb)") +
  scale_x_continuous(labels=function(x)x/1e6, , expand=c(0.005,0)) +
  scale_y_continuous(breaks=NULL) +
  theme(text = element_text(size=10), strip.text.y = element_text(angle = 0), strip.text.x = element_text(margin = margin(0,0,0,0, "cm")), panel.background = element_rect(fill = "white", colour = "black"), panel.grid.major = element_blank(), panel.grid.minor = element_blank())

ggsave(paste(args[1], "buscopainter.pdf", sep = "_"), plot = p, width = 15, height = 30, units = "cm", device = "pdf")
ggsave(paste(args[1], "buscopainter.png", sep = "_"), plot = p, width = 15, height = 30, units = "cm", device = "png")
