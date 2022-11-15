#' Get the swiss PCI dataset in a .rds file (only index-base 100)
#'
#' The function: \code{get_PCI} set up the big cube with only the variable: "PCI", in a long form.
#'
#' The function: \code{get_PCI} downloads and puts in a long form the data contained in the "sheet: "INDEX_m" sheet
#' of the excel file: "su-e-05.02.67.xlsx".
#'
#
#' @param name_flr names of the folders, one origin and one like destination, by default: c("excel", "rda")
#' @param language.x, set the language, by default: c("English", "PosTxt_E"). Other possibilities: "German",
#' "PosTxt_D"; "French", "PosTxt_F"; and "Italian", "PosTxt_I"
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
#' # Save a .rds file, in italian
#' get_PCI(c("my_pci", "my_rda"), c("Italian", "PosTxt_I"))
#'
#'}
#'
get_PCI <- function(name_flr = c("excel", "rda"),
                    language.x = c("English", "PosTxt_E")) {
  freq.x <- NULL

  d <- swissPCI::crea_d(name_flr = name_flr[1], language.x = language.x)

  tmp1 <- d %>% filter(freq.x %in% "month")
  tmp2 <- d %>% filter(freq.x %in% "quarter")
  tmp3 <- d %>% filter(freq.x %in% "year")

  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "PCI")
  openxlsx::writeData(wb, "PCI", tmp1, withFilter = TRUE)
  openxlsx::saveWorkbook(wb, paste0(name_flr[1], "/swissPCI.xlsx"),
                         overwrite = TRUE)

  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "PCI")
  openxlsx::writeData(wb, "PCI", tmp2, withFilter = TRUE)
  openxlsx::saveWorkbook(wb, paste0(name_flr[1], "/swissPCI_quarter.xlsx"),
                         overwrite = TRUE)

  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "PCI")
  openxlsx::writeData(wb, "PCI", tmp3, withFilter = TRUE)
  openxlsx::saveWorkbook(wb, paste0(name_flr[1], "/swissPCI_year.xlsx"),
                         overwrite = TRUE)

  dir.create(name_flr[2])
  saveRDS(d, paste0(name_flr[2], "/swissPCI.rds"))

}
