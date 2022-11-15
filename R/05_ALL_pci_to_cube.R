#' Get the full original swiss PCI dataset
#'
#' The function: \code{get_all_PCI} set up the original big cube, in a long form.
#'
#' The function: \code{get_all_PCI} downloads and puts in a long form all the data
#' contained in the excel file "su-e-05.02.67.xlsx".
#'
#
#' @param sheet.x sheet's names: "VAR_m-1", "VAR_m-12", "CONTR_m"
#' @param var.x variable's names, by default like sheet's names
#' @param name_flr destination folder's name, by default: c("excel", "rda")
#' @param language.x, set the language, by default: c("English", "PosTxt_E"). Other possibilities: "German",
#' "PosTxt_D"; "French", "PosTxt_F"; and "Italian", "PosTxt_I"
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr mutate group_by distinct ungroup filter
#' @importFrom openxlsx createWorkbook addWorksheet writeData saveWorkbook
#'
#' @export
#'
get_all_PCI <- function(sheet.x = c("VAR_m-1", "VAR_m-12", "CONTR_m"),
                        var.x = c("VAR_m-1", "VAR_m-12", "CONTR_m"),
                        name_flr = c("excel", "rda"),
                        language.x = c("English", "PosTxt_E")) {
  freq.x <- NULL

  d1 <- swissPCI::crea_d(name_flr = name_flr[1], language.x = language.x)

  d2 <- swissPCI::crea_d(sheet.x = sheet.x[1], var.x = var.x[1], name_flr = name_flr[1], language.x = language.x)

  d2 <- d2 %>%
    dplyr::filter(freq.x != "year")

  d3 <- swissPCI::crea_d(sheet.x = sheet.x[2], var.x = var.x[2], name_flr = name_flr[1], language.x = language.x)

  d4 <- swissPCI::crea_d(sheet.x = sheet.x[3], var.x = var.x[3], name_flr = name_flr[1], language.x = language.x)

  d4 <- d4 %>%
    dplyr::filter(freq.x == "month")


  d <- rbind(d1, d2, d3, d4)

  tmp1 <- d %>% filter(freq.x %in% "month")
  tmp2 <- d %>% filter(freq.x %in% "quarter")
  tmp3 <- d %>% filter(freq.x %in% "year")

  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "PCI")
  openxlsx::writeData(wb, "PCI", tmp1, withFilter = TRUE)
  openxlsx::saveWorkbook(wb, paste0(name_flr[1], "/swissPCI_origin_month.xlsx"),
                         overwrite = TRUE)

  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "PCI")
  openxlsx::writeData(wb, "PCI", tmp2, withFilter = TRUE)
  openxlsx::saveWorkbook(wb, paste0(name_flr[1], "/swissPCI_origin_quarter.xlsx"),
                         overwrite = TRUE)

  wb <- openxlsx::createWorkbook()
  openxlsx::addWorksheet(wb, "PCI")
  openxlsx::writeData(wb, "PCI", tmp3, withFilter = TRUE)
  openxlsx::saveWorkbook(wb, paste0(name_flr[1], "/swissPCI_origin_year.xlsx"),
                         overwrite = TRUE)

  dir.create(name_flr[2])
  saveRDS(d, paste0(name_flr[2], "/swissPCI_origin.rds"))

}
