#------------------------------- Prerequisites ---------------------------------

`%ni%` <- Negate(`%in%`)

private_TCGA_load_dependencies <- function() {
  message("Initializing")
  message("[TCGA] Sourcing functions...")
  source(paste0(tools_path, "expression_by_sample.R"))
  source(paste0(tools_path, "correlation.R"))
  source(paste0(tools_path, "expression_cutoff.R"))
  source(paste0(tools_path, "survival.R"))
  source(paste0(tools_path, "heatmap.R"))
  message("[TCGA] Loading packages...")
  suppressPackageStartupMessages({
    library(tidyverse) # data wrangling
    library(ggpubr) # plots
    library(Cairo) # graphics
    library(gridExtra) # graphics
    library(kableExtra) # tables
    library(DT) # tables
    library(survival) # OS
    library(survminer) # OS
    library(ggsurvfit) # OS
  })
  message("[TCGA] Sourcing dependencies...")
  source(paste0(tools_path, "themes.R"))
}

private_TCGA_set_path <- function(user = FALSE, alternatePath = FALSE) {
  message("[TCGA] Setting paths...")
  if (isFALSE(alternatePath)) {
    private_TCGA_data_path <<- paste0("/mnt/", tolower(user), "/G/Bioinformatics/data/tcga/data/")
  } else if (isTRUE(alternatePath)) {
    private_TCGA_data_path <<- alternatePath
  }
}

#---------------------------------- Metadata -----------------------------------

private_TCGA_load_metadata <- function() {
  message("[TCGA] Loading metadata...")
  meta_samp <<- suppressMessages(readr::read_tsv(paste0(private_TCGA_data_path,"merged_samp_sheet.tsv")))
  projects <<- as.data.frame(suppressMessages(read_tsv(paste0(private_TCGA_data_path,"project_IDs.tsv")))) %>%
    pull(`Study Abbreviation`) %>%
    sort() %>%
    sprintf("TCGA_%s", .)
  clinical_df <<- readRDS(paste0(private_TCGA_data_path,"clinical.rds")) # survival
  gene_vector <<- readRDS(paste0(private_TCGA_data_path,"gene_vector.rds"))
  extra_genes <<- readRDS(paste0(private_TCGA_data_path,"extra_genes.rds")) # dataset discrepencies
}

#------------------------------------ Data -------------------------------------

private_TCGA_load_projects <- function(projects, unit) {
  message("[TCGA] Loading data...")
  load_projects <- projects %>%
    gsub("-", "_", .)
  for (x in load_projects) {
    message(paste0("[TCGA] [Data] ", x))
    data <- readRDS(paste0(private_TCGA_data_path, tolower(unit),"/", x, ".rds"))
    assign(paste0(toString(x), paste0("_", tolower(unit))), data, envir = globalenv())
  }
}

private_TCGA_data <- function(gene, indication, unit) {
  message("[TCGA] Pulling relevant data...")
  output <- map_df(.x = indication,
                   .f = function(x) {
                     data_var_name <<- paste0(toString(x), "_", tolower(unit)) %>%
                       gsub("-", "_", .)
                     data_var <<- eval(parse(text = data_var_name))
                     individual_output <- data_var %>%
                       filter(GeneID %ni% extra_genes) %>%
                       filter(GeneID %in% gene) %>%
                       pivot_longer(3:ncol(.),
                                    names_to = "Sample ID",
                                    values_to = "rna_method") %>%
                       left_join(meta_samp,
                                 by = c("Sample ID"))
                     return(individual_output)
                   })
  return(output)
}

