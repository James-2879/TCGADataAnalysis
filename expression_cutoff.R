TCGA_expression_cutoff <- function(type,
                                   cutoff,
                                   genes,
                                   indications,
                                   sampleTypes,
                                   unit) {
  filtered_data <- private_TCGA_data(gene = genes,
                                     indication = indications,
                                     unit = unit) %>% 
    filter(`Sample Type` %in% sampleTypes)
  message("[TCGA] Plotting expression cutoff...")
  
  if (type == "boxplot") {
    plot <- filtered_data %>%
      ggplot(aes(
        x = factor(`Project ID`,
                   level = indications),
        y = rna_method
      )) +
      geom_boxplot() +
      geom_jitter(aes(
        color = 
          cut(rna_method, c(0, cutoff, 20))),
        size = 3,
        alpha = 0.5,
        width = 0.1) +
      scale_fill_manual(name = "rna_method",
                        values = c("(0,cutoff]" = "green",
                                   "(cutoff,20]" = "red"),
                        labels = c("<= cutoff", "> cutoff"
                        )) +
      geom_hline(yintercept = cutoff,
                 linewidth = 1,
                 color = "red"
      ) +
      labs(
        x = "Indication",
        y = paste("Expression", unit),
      ) +
      theme(legend.position = "none")
    return(plot)
  } else if (type == "density") {
    plot <- filtered_data %>% 
      ggplot(aes(
        x = rna_method
      )) +
      geom_density(fill = "#00B5C8") +
      geom_vline(xintercept = cutoff,
                 linewidth = 1,
                 color = "red"
      ) +
      facet_wrap(~factor(`Project ID`,
                         levels = indications),
                 ncol = 1,
                 scales = "free_y"
      ) +
      labs(
        x = paste("Expression", unit),
        y = "Density",
      )
    return(plot)
  }
}