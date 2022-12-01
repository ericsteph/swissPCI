#' Get the swiss PCI dataset in a .rds file (only index-base 100)
#'
#' The function: \code{save_PCI} set up the big cube with only the variable: "PCI", in a long form.
#'
#' The function: \code{save_PCI} downloads and puts in a long form the data contained in the "sheet: "INDEX_m" sheet
#' of the excel file: "su-e-05.02.67.xlsx".
#'
#' @param d base PCI dataset
#' @param time.x period: "month","quarter" or "year", by default = "month",
#' @param name_flr names of the folders, one origin and one like destination, by default: c("excel", "rda")
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr mutate group_by distinct ungroup filter
#' @importFrom openxlsx createWorkbook addWorksheet writeData saveWorkbook
#'
#' @export
#'
#' @examples
#' # Data were stored in a folder called: "my_pci", the .rds file finish in a folder named: "my_rda"
#'
#' \dontrun{
#' # Dataset with: yearly variations ("VAR_m-12" sheet), in german
#' d2 <- crea_d(m_pci, "VAR_m-12", "VAR_y", c("German", "PosTxt_D"))
#'
#' # Save the cube in two folder: "my_pci" and "my_rda"
#' save_PCI(d, time.x = "quarter", c("my_pci", "my_rda"))
#'
#'}
#'
save_PCI <- function(d,
                    time.x = "month",
                    name_flr = c("excel", "rda")) {
  freq.x <- NULL

  tmp <- d %>%
    filter(freq.x %in% time.x)

  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "PCI")
  openxlsx::writeData(wb, "PCI", tmp, withFilter = TRUE)
  openxlsx::saveWorkbook(wb, paste0(name_flr[1], "/swissPCI_", time.x, ".xlsx"),
                         overwrite = TRUE)

  dir.create(name_flr[2])
  saveRDS(tmp, paste0(name_flr[2], "/swissPCI_", time.x, ".rds"))

}
