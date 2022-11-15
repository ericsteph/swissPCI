#' From excel_sheet to a cube
#'
#' Transforms "INDEX_m" sheet of file: "su-e-05.02.67.xlsx" in a long form dataset.
#'
#' The function: \code{crea_d} is the second step of the swissPCI package. By default, it produces a dataset
#' with the data contained in the sheet: "INDEX_m". Of course, via the same FUN, it is possible to change
#' the sheet, among these possibilities: "INDEX_m", "VAR_m-1", "VAR_m-12", "CONTR_m".
#'
#' @param name_flr folder's name, by default: "excel"
#' @param sheet.x sheet's name, by default: "INDEX_m"
#' @param var.x column's name, by default: "var.x"
#' @param language.x set the language, by default: c("English", "PosTxt_E"). Other possibilities: "German",
#' "PosTxt_D"; "French", "PosTxt_F"; and "Italian", "PosTxt_I"
#'
#' @importFrom readxl read_excel
#' @importFrom zoo as.yearqtr as.yearmon
#' @importFrom magrittr %>%
#' @importFrom tidyr pivot_longer
#' @importFrom dplyr mutate group_by distinct ungroup filter
#'
#' @export
#'
#' @examples
#' # Data were stored in a folder called: "my_pci"
#'
#' \dontrun{
#' # Standard dataset, INDEX_m sheet and labels in english
#' d1 <- crea_d("my_pci")
#'
#' # Dataset with: yearly variations ("VAR_m-12" sheet), in german
#' d2 <- crea_d(m_pci, "VAR_m-12", "VAR_y", c("German", "PosTxt_D"))
#'
#'}
#'
crea_d <- function(name_flr = "excel",
                   sheet.x = "INDEX_m",
                   var.x = "IPC",
                   language.x = c("English", "PosTxt_E")) {

  z <- month.yr <- qrt.yr <- PosNo <- Code <- year.x <- qrt.x <- value <- PosType <- Level <-
    COICOP <- PosTxt_D <- PosTxt_E <- PosTxt_F <- PosTxt_I <- w2022 <- month.x <- month.n <-
    mean_qrt <- mean_yr <- freq.x <- all_of <- time.x <- `2022` <- NULL

  d <- readxl::read_excel(
    path = file.path(name_flr, "su-e-05.02.67.xlsx"),
    sheet = sheet.x,
    skip = 3,
    .name_repair = "unique"
  )

  k <- length(d)

  d[,15:k] <- lapply(d[,15:k], as.numeric)

  base <- colnames(d)[1:14]

  d <- d[-seq(nrow(d), nrow(d)- 4), ]

  d <- d %>%
    filter(Code > 0)

  d <- dplyr::distinct(d)

  d_long <- d %>%
    tidyr::pivot_longer(15:k, names_to = "time.x")

  d_long$time.x <- as.double(d_long$time.x)

  Sys.setlocale("LC_TIME", language.x[1])

  d_long <- d_long %>%
    dplyr::mutate(
      month.yr = zoo::as.yearmon(as.Date(time.x + 0.5, origin = "1899-12-31")),
      year.x = format(month.yr, format = "%Y"),
      qrt.yr = zoo::as.yearqtr(as.Date(time.x + 0.5, origin = "1899-12-31")),
      var.x = var.x,
      w2022 = `2022`)

  d_long <- d_long %>%
    dplyr::group_by(var.x, PosNo, Code, year.x, qrt.yr) %>%
    dplyr::mutate(mean_qrt = mean(value)) %>%
    dplyr::ungroup()

  d_long <- d_long %>%
    dplyr::group_by(var.x, PosNo, Code, year.x) %>%
    dplyr::mutate(mean_yr = mean(value)) %>%
    dplyr::ungroup()

  d_long <- d_long %>%
    dplyr::select(var.x, Code, PosNo, PosType, Level, COICOP, language.x[2], w2022, month.yr, qrt.yr,
           year.x, value, mean_qrt, mean_yr)

  d_long <- d_long %>%
    tidyr::pivot_longer(cols = 12:14, names_to = "freq.x", values_to = "value") %>%
    dplyr::group_by(var.x, PosNo, Code, qrt.yr, year.x) %>%
    dplyr::mutate(month.yr = ifelse(freq.x == "mean_qrt", max(month.yr), month.yr),
                  month.yr = zoo::as.yearmon(month.yr),
                  month.x = format(month.yr, format = "%b"),
                  month.n = format(month.yr, format = "%m")) %>%
    dplyr::distinct()

  d_long <- d_long %>%
    dplyr::group_by(var.x, PosNo, Code, year.x) %>%
    dplyr::mutate(month.yr = ifelse(freq.x == "mean_yr", max(month.yr), month.yr),
                  month.yr = zoo::as.yearmon(month.yr),
                  qrt.yr = zoo::as.yearqtr(month.yr),
                  qrt.x = format(qrt.yr, format = "%q")) %>%
    dplyr::distinct()

  d_long <- d_long %>%
    dplyr::select(freq.x, var.x, Code, PosNo, PosType, Level, COICOP, language.x[2], w2022,
                  month.yr, qrt.yr, month.x, month.n, qrt.x,
                  year.x, value)

  d_long$freq.x <- factor(d_long$freq.x,
                        levels = c("value", "mean_qrt", "mean_yr"),
                        labels = c("month", "quarter", "year"))

  d1 <- d_long %>%
    dplyr::filter(freq.x == "month")

  d2 <- d_long %>%
    dplyr::filter(freq.x == "quarter") %>%
    dplyr::mutate(z = ifelse(month.n %in% c("03", "06", "09", "12"), 1, 0))

  d3 <- d_long %>%
    dplyr::filter(freq.x == "year") %>%
    dplyr::mutate(z = ifelse(month.n %in% "12", 1, 0))

  d2 <- d2 %>%
    dplyr::filter(z == 1) %>%
    dplyr::select(-z)

  d3 <- d3 %>%
    dplyr::filter(z == 1) %>%
    dplyr::select(-z)

  d_long <- rbind(d1, d2, d3)

  d_long

}
