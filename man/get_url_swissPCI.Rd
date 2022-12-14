% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/00_pci_get_last_url.R
\name{get_url_swissPCI}
\alias{get_url_swissPCI}
\title{Getting the last url}
\usage{
get_url_swissPCI(documentsource)
}
\arguments{
\item{documentsource}{specific webpage of the Federal Statistical Office, where the data of the Swiss Consumer Price
Index by subject are stored (detailed results since 1982, structure of basket 2020, including additional classifications)}
}
\description{
Ensure that "documentsource" is the url with the most recent data.
}
\details{
The function: \code{get_url_swissPCI} is needed to retrieve the last url and thus the last PCI data (function ResMARTI).
}
\examples{
# Function to find the current "url_basis"

\dontrun{
url_fso <- "https://www.bfs.admin.ch/bfs/en/home/statistics/prices/"
url_swissPCI <- "consumer-price-index.assetdetail.21484856.html"

documentsource <- paste0(url_fso, url_swissPCI)
url_basis <- get_url_swissPCI(documentsource)

}

}
