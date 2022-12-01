#' Create the variables: VAR and CONTR
#'
#' The function: \code{PCI_plus} add the variables: "VAR" and "CONTR".
#'
#' The function: \code{PCI_plus} generate the variables: "VAR" and "CONTR", calculated from the variables: "value" (index_100)
#' multiplied with "weigth" (column: "w2022").
#'
#
#' @param d base PCI dataset
#' @param time.x period: "month","quarter" or "year", by default = "month",
#' @param k the lag: 1 or 12, or 4, by default = 12
#' @param labels.x label names, by default = c("PCI", "VAR_y, "CONTR_y")
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr group_by filter mutate ungroup arrange select lag
#' @importFrom tidyr pivot_longer
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' # The PCI dataset "swissPCI.rds" is stored in my folder: "my_rds"
#' d <- readRDS("my_rds/swissPCI.rds")
#'
#' # Create a dataset with: "quarter" data and with change on previous quarter (lag = 1)
#' d2 <- PCI_plus(d, "quarter", 1, c("PCI", "VAR_q", "CONTR_q"))
#'
#' }
#'
PCI_plus <- function(d, time.x = "month",
                     k = 12, labels.x = c("PCI", "VAR_y", "CONTR_y")) {

z <- Code <- value <- PosType <- w2022 <- freq.x <- var.x <- var1 <- month.yr <- NULL

tmp <- d %>%
  dplyr::filter(freq.x %in% time.x) %>%
  dplyr::arrange(month.yr)

n <- lenght(tmp)

tmp <- tmp %>%
  dplyr::group_by(Code, PosType, w2022) %>%
  dplyr::mutate(var1 = ((value - dplyr::lag(x = value, n = k)) / dplyr::lag(x = value, n = k)) * 100,
         contr = var1 * w2022
  ) %>%
  dplyr::ungroup() %>%
  dplyr::select(-var.x) %>%
  tidyr::pivot_longer(cols = (n-1):(n+1), names_to = "var.x") %>%
  dplyr::arrange(var.x) %>%
  droplevels()

tmp$var.x <- factor(tmp$var.x, levels = c("value", "var1", "contr"),
                  labels = labels.x)

return(tmp)

}
