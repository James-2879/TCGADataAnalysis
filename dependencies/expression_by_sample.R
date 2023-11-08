TCGA_expression_plot_sample <- function(genes,
                                        indications,
                                        sampleTypes,
                                        unit) {
  filtered_data <- private_TCGA_data(gene = genes,
                                     indication = indications,
                                     unit = unit)
  message("[TCGA] Plotting expression by sample type...")
  plot <- filtered_data %>%
    filter(`Sample Type` %in% sampleTypes) %>%
    ggplot(aes(
      x = `Project ID`,
      y = rna_method, 
      color = `GeneID`
    )) +
    geom_boxplot() +
    geom_point(position = position_dodge(width = 0.75)) +
    facet_wrap(~`Sample Type`) + 
    scale_fill_manual(values=c("red","green","blue")) +
    guides(colour = guide_legend(nrow =1)) +
    labs(
      x = "Indication",
      y = paste("Expression", unit),
    ) #+
  # theme_reactive_exp()
  return(plot)
}