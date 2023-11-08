TCGA_survival_plot <- function(gene,
                               indication,
                               unit,
                               riskTable = TRUE,
                               censorPlot = TRUE) {
  filtered_data <- private_TCGA_data(gene = gene,
                                     indication = indication,
                                     unit = unit) %>%
    filter(!duplicated(`Case ID`))
  message("[TCGA] Plotting Kaplan-Meier...")
  clinical_df <- clinical_df %>%
    filter(submitter_id %in% filtered_data$`Case ID`) %>%
    filter(!duplicated(submitter_id)) %>%
    filter(!is.na(time)) %>%
    filter(time > -1)
  group_vector <- filtered_data %>%
    mutate(rna_method = as.double(rna_method)) %>%
    arrange("rna_method") %>%
    filter(`Case ID` %in% clinical_df$submitter_id) %>%
    filter(rna_method <= quantile(rna_method, 0.5)) %>%
    pull(`Case ID`)
  group_vector2 <- filtered_data %>%
    mutate(rna_method = as.double(rna_method)) %>%
    arrange("rna_method") %>%
    filter(rna_method > quantile(rna_method, 0.5)) %>%
    pull(`Case ID`)
  plot_df <<- clinical_df %>%
    mutate(group = case_when(submitter_id %in% group_vector ~ "Low",
                             submitter_id %ni% group_vector ~ "High",
                             T ~ "What?"))
  fit_cox <- coxph(Surv(time, vital_status) ~ group, data = plot_df)
  result_cox <- summary(fit_cox)
  hazard <- round(result_cox[["conf.int"]][[1]], 3)
  fit <- survfit(Surv(time, vital_status) ~ group, data = plot_df)
  ggsurv <- ggsurvplot(fit,
                       legend.labs = c("High", "Low"),
                       risk.table = riskTable,
                       pval = TRUE,
                       ncensor.plot = censorPlot,
                       data = plot_df,
                       # ggtheme = theme_blank_with_legend,
                       xlab = "Time in Days"
  )
  plot <- ggsurv$plot + ggplot2::annotate(geom = "text",
                                          label = paste0("Hazard = ", hazard),
                                          size = 5,
                                          x = 800,
                                          y = 0.25) +
    ggplot2::annotate(geom = "text",
                      label = paste0("Gene: ", gene),
                      size = 5,
                      x = 1000,
                      y = 1)
  if (isTRUE(riskTable) & isTRUE(censorPlot)) {
    grid <- grid.arrange(plot, ggsurv$table, ggsurv$ncensor.plot, heights = c(4,2,2))
  } else if (isFALSE(riskTable) & isTRUE(censorPlot)) {
    grid <- grid.arrange(plot, ggsurv$ncensor.plot, heights = c(4, 2))
  } else if (isTRUE(riskTable) & isFALSE(censorPlot)) {
    grid <- grid.arrange(plot, ggsurv$table, heights = c(4, 2))
  } else {
    grid <- grid.arrange(plot)
  }
  message("Done.")
  return(grid)
}