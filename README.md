## Usage

### Quick start

1. `source("TCGA_functions.R")`
2. `TCGA_initialize(user, alternatePath = FALSE, projects = FALSE, unit = FALSE)`
4. `TCGA_specific_plot_function()` # function docs below

Done.

### Notes
1. May need to define whole path to `TCGA_functions.R`.
2. User is required to specify data mount point on Ubuntu file system. If your data isn't at `/mnt/user/...`, then specify your path using `TCGA_initialize(alternatePath = "/path/.../tcga/data/)`.
3. Projects may be parsed as a vector.
4. Whichever function you choose; functions may have both required and optional arguments.

### Example usage

1. `source("/home/james.swift/Documents/TCGAtools/functions.R")`
2. `TCGA_initialize(user = "james.swift", projects = "TCGA-UVM", unit = "TPM")` 
3. `TCGA_survival_plot_(gene = "CD4", indication = "TCGA-UVM", unit = "TPM")`

## Function details

All functions that start with `TCGA_` are desgined to be called, but any functions that start with `private_TCGA_` should not be, these should **only be called by TCGAtools functions**.

Any arguments assigned a boolean value below are displaying the default values, and are therefore optional.

### Survival

```
TCGA_survival_plot(gene, indication, unit, riskTable = TRUE, censorPlot = TRUE)
```

For now only one gene, indication, unit per each function call.

### Correlation

```
TCGA_correlation_plot(genes, indications, unit, sampleType, correlation = TRUE, regression = TRUE)
```

### Expression plots by sample type

```
TCGA_expression_plot_sample(genes, indications, sampleTypes, unit)
```

### Expression cutoff

```
TCGA_expression_cutoff(type, cutoff, genes, indications, sampleTypes, unit)
```
- Type: "boxplot" or "density"
- Cutoff: Float between 0 and 1

### Heatmap

```
TCGA_heatmap(scaled = TRUE, genes, indication, unit)
```
- Scaled: Scale by gene or by patient (sample).

## Dependencies

### Theming
```
themes.R
```
General stylistic attributes for ggplots.
