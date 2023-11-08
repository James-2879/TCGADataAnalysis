source("/home/james.swift/Documents/TCGAtools_non-package/TCGAtools.R")

TCGA_initialize(user = "james.swift", projects = "TCGA-UVM")
TCGA_survival_plot(gene = "CD4", indication = "TCGA-UVM", unit = "TPM", censorPlot = FALSE)
TCGA_correlation_plot(gene = c("CD4", "CD8A"), "TCGA-UVM", "TPM", "Primary Tumor", regression = FALSE)
TCGA_expression_plot_sample(genes = c("CD4", "CD8A"), indications ="TCGA-UVM", unit = "TPM", sampleTypes = "Primary Tumor")
TCGA_expression_cutoff(type = "boxplot", cutoff = 0.5, genes = c("CD4", "CD8A"), indications ="TCGA-UVM", unit = "TPM", sampleTypes = "Primary Tumor")
TCGA_heatmap(scaled = FALSE, genes = c("CD4", "CD8A"), indication ="TCGA-UVM", unit = "TPM")
