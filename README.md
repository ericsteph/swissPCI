[![Licence](https://img.shields.io/badge/licence-GPL--2-blue.svg)](https://www.gnu.org/licenses/gpl-2.0.en.html)
[![cranlogs](https://cranlogs.r-pkg.org/badges/grand-total/swissdd)](http://cran.rstudio.com/web/packages/swissdd/index.html)
[![R build status](https://github.com/politanch/swissdd/workflows/R-CMD-check/badge.svg)](https://github.com/politanch/swissdd/actions?workflow=R-CMD-check)

# swissPCI

## the swiss Price Consumer Index (CPI) R package

### Goal

The goal of swissPCI is to download, to transform and to complete the table "su-e-05.02.67.xlsx", the swiss Price Consumer Index (CPI) dataset, from the website of the Swiss Federal Statistical Office (FSO).

### Installation

You can install the released version of swissPCI from [github](https://https://github.com/ericsteph/swissPCI) with:

``` r
# From GitHub:
# install.packages("devtools")
devtools::install_github("ericsteph/swissPCI")
```

## Start

To start

```{r example}
library(swissPCI)

# Download and save the original data: "su-e-05.02.67.xlsx"
get_swissPCI(name_flr = "my_pci") 

# Create and save a .rds file, in italian
get_PCI(c("my_pci", "my_rda"), c("Italian", "PosTxt_I"))

```
