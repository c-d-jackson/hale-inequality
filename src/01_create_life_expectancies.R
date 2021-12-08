library(here)
library(haven)
library(stringr)
library(dplyr)

setwd(here())

# load data
files <- list.files("./data/chetty2016/data/derived/le_estimates/", full.names = T)
data.list <- lapply(files, read_dta)

# collect data
names(data.list) <- stringr::str_extract(files, "le[[:digit:]]{2}")
for (i in seq_along(data.list)) {
  data.list[[i]]$age <- as.numeric(gsub("le", "", names(data.list)[i]))
}
data.bind <- as.data.frame(dplyr::bind_rows(data.list))
data <- data.bind[, c("st", "gnd", "hh_inc_q", "year", "le_agg", "age")]
nrow(data) == nrow(data.list[[1]]) * length(data.list) # check
dim(data)

# create Life Expectancies from ages 40 - 80
# for each year, state, gender and household income quartile
le <- split(data, list(data$year, data$st, data$gnd, data$hh_inc_q))
data[which.max(data$le_agg), ]
data[which.min(data$le_agg), ]
le[["2001.11.M.1"]]
le[["2013.56.F.4"]]
