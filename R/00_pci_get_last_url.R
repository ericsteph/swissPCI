#' Getting the last url
#'
#' Ensure that "documentsource" is the url with the most recent data.
#'
#' The function: \code{get_url_swissPCI} is needed to retrieve the last url and thus the last PCI data (function ResMARTI).
#'
#' @param documentsource specific webpage of the Federal Statistical Office, where the data of the Swiss Consumer Price
#' Index by subject are stored (detailed results since 1982, structure of basket 2020, including additional classifications),
#' by default: "https://www.bfs.admin.ch/bfs/en/home/statistics/prices/consumer-price-index.assetdetail.23772745.html"
#'
#' @importFrom rvest read_html html_attr html_nodes html_text
#' @importFrom magrittr %>%
#'
#' @export
#'
#' @examples
#' # Function to find the current "url_basis"
#'
#' \dontrun{
#' url_fso <- "https://www.bfs.admin.ch/bfs/en/home/statistics/prices/"
#' url_swissPCI <- "consumer-price-index.assetdetail.23772745.html"
#'
#' documentsource <- paste0(url_fso, url_swissPCI)
#' url_basis <- get_url_swissPCI(documentsource)
#'
#' }
#'
get_url_swissPCI <- function(documentsource =
                               "https://www.bfs.admin.ch/bfs/en/home/statistics/prices/consumer-price-index.assetdetail.23772745.html"){

  newdocumentsource = "initial"

  #determin current web page
  while (length(newdocumentsource) != 0) {
    page = rvest::read_html(documentsource)

    #search alert-object (option 1)
    newdocumentsource = page %>%
      rvest::html_nodes(".alert.alert-info > a") %>%
      rvest::html_attr('href')

    #search alert-object (option 2)
    if (length(newdocumentsource) == 0) {
      newdocumentsource = page %>%
        rvest::html_nodes(".alert.bg-success > a") %>%
        rvest::html_attr('href')
    }

    #if alert-object is found, replace documentsource with new documentsource
    if (length(newdocumentsource) != 0 && newdocumentsource != "initial") {
      documentsource = paste("https://www.bfs.admin.ch", newdocumentsource, sep="")
    }
  }

  page <- rvest::read_html(documentsource)

  newurl <- page %>%
    rvest::html_nodes("figure > a") %>%
    rvest::html_attr('href')

  return(newurl)

}

