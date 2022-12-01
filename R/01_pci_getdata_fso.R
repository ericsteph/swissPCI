#' From the web to a folder
#'
#' Download the table "su-e-05.02.67.xlsx" from the website of the Swiss Federal Statistical Office (FSO)
#'
#' The function: \code{get_swissPCI} is the starting point of the swissPCI package. It allows retrieving the
#' most recent data and the relevant time series of the Swiss Consumer Price Index (PCI). By default, this
#' function saves the table "su-e-05.02.67.xlsx" in a folder called "excel".
#'
#' @param url_basis specific webpage of the Federal Statistical Office (FSO), where are the most recent data
#' of the Swiss Consumer Price Index by subject are stored (detailed results since 1982, structure of basket 2020,
#' including additional classifications)
#'
#' @param name_flr destination folder's name, by default: "excel"
#'
#' @importFrom utils download.file
#'
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' # By default, save "su-e-05.02.67.xlsx" in a new folder called: "excel"
#' get_swissPCI()
#'
#' # According to your customisation: save "su-e-05.02.67.xlsx" in a new folder called: "my_pci"
#' get_swissPCI(name_flr = "my_pci")
#'
#' # If needed: update url_basis
#' last_url <- get_url_swissPCI(documentsource)
#' get_swissPCI(url_basis = last_url)
#'
#'}
#'
get_swissPCI <- function(url_basis,
                         name_flr = "excel") {

dir.create(name_flr)

destfile <- file.path(name_flr, "su-e-05.02.67.xlsx")

d <- utils::download.file(url_basis, destfile, quiet = FALSE, mode = "wb")

return(d)

}
