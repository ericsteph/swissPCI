#' Level column harmonization
#'
#' The function: \code{PCI_plus0} add two new columns: "Level", "wCat
#'
#' The function: \code{PCI_plus0l_wCat} add two new columns: "Level", "wCat. Starting from the original column: "Level"
#' (renamed: "Level_0") and from the specific "PosNo" of energy products and those of seasonal products.
#'
#
#' @param d base PCI dataset
#' @param labels.x labels colnames, by default = c("Level_0", "Level", "wCat")
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr group_by filter mutate ungroup arrange select lag distinct relocate
#' @importFrom tidyr pivot_longer
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' d0 <- readRDS("my_rds/swissPCI.rds")
#' d1 <- PCI__plus0(d0)
#'
#' # test1: sum weight by Level == 100 (sum weight by Level_0 != 100)
#'
#' tmp1 <- d1 %>%
#' group_by(freq.x, month.yr, Level) %>%
#' mutate(test1 = sum(w2022))
#'
#' # test2: sum weight by Cat and level
#' k <- max(d1$qrt.yr) - 1
#' tmp2 <- d1 %>%
#' filter(freq.x == "quarter",
#' Level %in% c(1, 8),
#' qrt.yr == k,
#' wCat == "wSaison") %>%
#' group_by(freq.x, month.yr, Level) %>%
#' mutate(test2 = sum(w2022))
#'
#' }
#'
#
PCI_plus0 <- function(d,
                      labels.x = c("Level_0", "Level", "wCat")) {

z <-  Code <-  Level <- Level_0 <- PosNo <- month.yr <- tmp <- w2022 <- wCat <- wEnergie <- wSaison <- NULL

### Aggiungo livelli
### Level_4d
d$Level_4d <- -9
d$Level_4d <- ifelse(is.na(d$Level), d$Level_4d, d$Level)

d$Level_4d <- ifelse(d$PosNo %in% c("6059", "8001", "8006", "10070", "10100", "12190"),
                      4, d$Level_4d)

### Level_5d
d$Level_5d <- d$Level_4d
d$Level_5d <- ifelse(d$PosNo %in% c("2064", "2076", "2082", "3183", "3237", "4005", "4010", "4047", "4090", "4100",
                                      "5060", "5090", "5071", "5085", "5120", "5150", "5165", "5181", "5280", "6002",
                                      "6059", "6036", "6070", "7300", "7320", "7500", "8001", "8006", "8018", "8042",
                                      "8045", "9029", "9120", "9151", "9200", "9320", "9340", "9480", "9545", "9555",
                                      "9570", "9580", "10070",	"10100", "10041", "10060", "11171", "11190", "12150",
                                      "12140", "12161", "12170", "12190", "12501", "12510", "12520", "12543", "12547",
                                      "12549", "12534", "12536"),
                      5, d$Level_4d)

### Level_6d, Level_7d and Level_8d
d$Level_6d <- d$Level_5d
d$Level_6d <- ifelse(d$PosType == 4 & d$Level_5d == 5, 6, d$Level_6d)

d$Level_7d <- d$Level_6d
d$Level_7d <- ifelse(d$PosType == 4 & d$Level_6d == 6, 7, d$Level_7d)

d$Level_8d <- d$Level_7d
d$Level_8d <- ifelse(d$PosType == 4 & d$Level_7d == 7, 8, d$Level_8d)


colnames(d)[6] <- labels.x[1]

d0_long <- d %>%
  pivot_longer(cols = 17:21, names_to = "tmp", values_to = labels.x[2])

# "Pulizia" del d_long
# Salvo i dati originali
d1 <- d0_long %>%
  filter(Level_0 %in% c(1, 2, 3, NA))

d4 <- d0_long %>%
  filter(tmp == "Level_4d",
         Level == 4)

d5 <- d0_long %>%
  filter(tmp == "Level_5d",
         Level == 5)

d6 <- d0_long %>%
  filter(tmp == "Level_6d",
         Level == 6)

d7 <- d0_long %>%
  filter(tmp == "Level_7d",
         Level == 7)

d8 <- d0_long %>%
  filter(tmp == "Level_8d",
         Level == 8)

d0 <- rbind(d1, d4, d5, d6, d7, d8)

d0 <- d0 %>%
  relocate(tmp:Level, .after = Level_0) %>%
  select(-tmp)  %>%
  distinct()

rm(d1, d4, d5, d6, d7, d8)

# Aggiungo colonna "wSaison"
d0$wSaison <- 0


# Carni fresche
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo >= 1075 & PosNo < 1134,
                                     w2022, wSaison))
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo == 1074,
                                     1.462, wSaison))

# Pesce fresco
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo == 1180,
                                     w2022, wSaison))
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo == 1179,
                                     0.298, wSaison))

# Frutta fresca
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo >= 1307 & PosNo < 1347,
                                     w2022, wSaison))
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo == 1306, 0.843, wSaison))


# Legumi freschi
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo >= 1360 & PosNo < 1408,
                                     w2022, wSaison))

# Patate
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo == 1417,
                                     w2022, wSaison))
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo == 1416,
                                     0.098, wSaison))


# Legumi, funghi e patate
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo == 1359,
                                     0.098 + 0.986, wSaison))

# Frutta
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo == 1305,
                                     0.843 + 1.084, wSaison))


# Prodotti alimentari
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo == 1001 | PosNo == 1,
                                     1.462 + 0.298 + 0.843 + 1.084, wSaison))

# Taxes pour la fourniture du logement (c'era un errore nella Tabella 5.11 dell'UST)
# d0 <- d0 %>% mutate(wSaison = ifelse((PosNo == 4028 | PosNo == 4030 | PosNo == 4036 | PosNo == 4042),
#                                     1, wSaison))

# Piante, fiori e prodotti per il giardino
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo >= 9300 & PosNo < 9306,
                                     w2022, wSaison))
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo == 9210 | PosNo == 9,
                                     0.602, wSaison))

# Hotellerie
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo == 11171,
                                     w2022, wSaison))
d0 <- d0 %>% mutate(wSaison = ifelse(PosNo == 11170 | PosNo == 11,
                                     0.992, wSaison))

# Totale
d0 <- d0 %>% mutate(wSaison = ifelse(Code == "100_100",
                                     5.281, wSaison))



# Aggiungo colonna "wEnergie"
d0$wEnergie <- 0

# Energia
d0 <- d0 %>% mutate(wEnergie = ifelse(PosNo >= 4049 & PosNo < 5000,
                                      w2022, wEnergie))

d0 <- d0 %>% mutate(wEnergie = ifelse(PosNo == 4,
                                      3.520, wEnergie))


# Carburante
d0 <- d0 %>% mutate(wEnergie = ifelse(PosNo >= 7105 & PosNo < 7112,
                                      w2022, wEnergie))

d0 <- d0 %>% mutate(wEnergie = ifelse(PosNo == 7 | PosNo == 7001 | PosNo == 7081,
                                      1.946, wEnergie))

# Totale
d0 <- d0 %>% mutate(wEnergie = ifelse(Code == "100_100",
                                      5.466, wEnergie))


# wCore
d0 <- d0 %>%
  mutate(wCore = ifelse(wEnergie == w2022 | wSaison == w2022, 0,
                        ifelse(wEnergie > 0 & wSaison == 0, w2022 - wEnergie,
                               ifelse(wSaison > 0 & wEnergie == 0, w2022 - wSaison,
                                      ifelse(wSaison > 0 & wEnergie > 0, w2022 - wSaison - wEnergie,
                                             w2022))))
  )


d0 <- d0 %>%
  relocate(w2022, .before = wSaison)

colnames(d0)[17] <- "wTotal"

d0_long <- d0 %>%
  pivot_longer(cols = 17:20, names_to = "wCat", values_to = "w2022") %>%
  relocate(wCat:w2022, .before = month.yr)

d0_long <- d0_long %>%
  filter(!is.na(w2022),
         w2022 > 0)

return(d0_long)

}


