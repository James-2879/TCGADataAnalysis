TCGA_heatmap <- function(scaled = TRUE, # should add sampleType at some point
                         genes,
                         indication,
                         unit) {
  filtered_data <<- private_TCGA_data(gene = genes,
                                      indication = indication,
                                      unit = unit) %>% 
    filter(`Sample Type` == "Primary Tumor") %>%
    select(GeneID, `Sample ID`, rna_method) %>%
    pivot_wider(names_from = `Sample ID`, values_from = rna_method) %>% 
    column_to_rownames(var = "GeneID")
  message("[TCGA] Plotting heatmap...")
  
  if (length(genes) == 1 | scaled == FALSE) {
    mat <- filtered_data
  } else if (length(genes) > 1 & scaled == TRUE) {
    mat <- t(scale(t(filtered_data)))  
  }
  plot <- Heatmap(as.matrix(mat[, -1]),
                  show_column_names = FALSE,
                  heatmap_legend_param = list(
                    title = "Scaled gene expression",
                    legend_direction = "horizontal",
                    legend_width = unit(6, "cm")))
  plot <- draw(plot, heatmap_legend_side = "top")
  return(plot)
}