TCGA_correlation_plot <- function(genes,
                                  indications,
                                  unit,
                                  sampleType,
                                  correlation = TRUE,
                                  regression = TRUE) {
  filtered_data <- private_TCGA_data(gene = genes,
                                     indication = indications,
                                     unit = unit)
  message("[TCGA] Plotting correlation...")
  plot <- filtered_data %>%
    filter(`Sample Type` %in% sampleType)  %>%
    select(-GeneType) %>% 
    pivot_wider(names_from = GeneID,
                values_from = rna_method) %>% 
    ggplot(aes(
      x = !!sym(genes[1]),
      y = !!sym(genes[2]),
      color = interaction(`Project ID`, `Sample Type`, sep = " - ")
    )) +
    geom_point(position = "jitter") +
    guides(colour = guide_legend(nrow = length(unique(filtered_data$`Project ID`)),
                                 title = "")) +
    labs(
      x = paste(sym(genes[1]), "Expression", unit),
      y = paste(sym(genes[2]), "Expression", unit),
    ) +
    theme(legend.position = "right")
  if (isTRUE(correlation)) {
    plot <- plot +
      stat_cor(mapping = aes(color = interaction(`Project ID`, `Sample Type`, sep = " - ")),
               label.x.npc = "left")
  }
  if (isTRUE(regression)) {
    plot <- plot +
      geom_smooth(method = "lm")
  }
  return(plot)
}