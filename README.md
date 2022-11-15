# swissPCI

<!-- badges: start -->
<!-- badges: end -->

The goal of swissPCI is to download, to transform and to complete the table "su-e-05.02.67.xlsx", the swiss Price Consumer Index (CPI) dataset, from the website of the Swiss Federal Statistical Office (FSO).

## Installation

You can install the released version of swissPCI from [github](https://https://github.com/ericsteph/swissPCI) with:

``` r
# From GitHub:
# install.packages("devtools")
devtools::install_github("ericsteph/swissPCI")
```

## Example

This is a basic example which shows you how to solve a common problem:

```{r example}
library(swissPCI)

## Download and save the data
get_swissPCI() 

```