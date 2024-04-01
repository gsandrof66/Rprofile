library(profvis)
library(glue)
library(data.table)
library(dtplyr)
library(dplyr)
# getDTthreads()
setDTthreads(4L)
library(readr)

FILE <- "datareview.csv"
EXCEL <- "Base.xlsx"
DIR <- "RESULT/"
readr_funct <- function(dir, word, s){
  data <- read_csv(dir)
  print(class(data))
  matching_rows <- grep(word, data$review_text, ignore.case = TRUE)
  matched <- data[matching_rows, ]
  matched <- matched[sample(nrow(matched), size = s), ]
  return(matched)
}
base_funct <- function(dir, word, s){
  data <- read.csv(dir, sep=",")
  print(class(data))
  matching_rows <- grep(word, data$review_text, ignore.case = TRUE)
  matched <- data[matching_rows, ]
  matched <- matched[sample(nrow(matched), size = s), ]
  return(matched)
}
datatable_funct <- function(dir, word, s){
  data <- fread(dir, sep=",")
  print(class(data))
  matched <- data[grepl(word, review_text, ignore.case = TRUE)]
  matched <- matched[sample(nrow(matched), size = s), ]
  return(matched)
}
# grepl() logical output: TRUE or FALSE.
# grep() numeric output: Indexes.
fast_funct <- function(x, y){
  z <- x + y
  return(z)
}
save_datawb1 <- function(d1,d2,d3, PATH, FILE){
  wb <- openxlsx::loadWorkbook(FILE)
  wb |> openxlsx::writeData(sheet = "data1", d1)
  wb |> openxlsx::writeData(sheet = "data2", d2)
  wb |> openxlsx::writeData(sheet = "data3", d3)
  wb |> 
  openxlsx::saveWorkbook(glue("{PATH}input_file_{Sys.Date()}.xlsx"),
                         overwrite=TRUE)
}

profvis(
  {
    word <- "good"
    n <- 2000
    d1 <- readr_funct(FILE, word, n)
    d2 <- base_funct(FILE, word, n)
    d3 <- datatable_funct(FILE, word, n)
    fast_funct(2, 3)
    save_datawb1(d1, d2, d3, DIR, EXCEL)
  },interval = 0.01
)
rm(d1,d2,d3)
gc()
# default 0.01
# waiting list 0.1 very long
# short code (lowest value) 0.005
