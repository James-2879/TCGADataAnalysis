#--------------------------------- Initialize ----------------------------------

TCGA_initialize <- function(user, alternatePath = FALSE, projects = FALSE, unit = FALSE) {
  tools_path <<- "/home/james.swift/Documents/TCGAtools_non-package/dependencies/"
  source(paste0(tools_path, "/core.R"))
  private_TCGA_load_dependencies()
  private_TCGA_set_path(user = user, alternatePath = alternatePath)
  private_TCGA_load_metadata()
  if (!isFALSE(projects)) {
    if (isFALSE(unit)) {
      message("[TCGA] [Warning] Unit not specified, defaulting to TPM!")
      private_TCGA_load_projects(projects = projects, unit = "TPM")
    } else {
      private_TCGA_load_projects(projects = projects, unit = unit)
    }
  }
  message("Done.")
}

TCGA_maintainer <- "james.swift"