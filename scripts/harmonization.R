library(readxl)

setwd("/home/kaelyn/Desktop/Work/ASAP_MAC/parkinsonsManualCuration/scripts")
filedir <- "../original_metadata"

boktor <- read_xlsx(file.path(filedir, "mds29300-sup-0017-tables10.xlsx"),
                    sheet = "metadata")
wallen <- read_xlsx(file.path(filedir, "Source_Data_24Oct2022.xlsx"),
                    sheet = "subject_metadata")
bedarf <- read.csv(file.path(filedir, "BedarfJR_2017_metadata_newgrammar.tsv"),
                   sep = "\t")
mao <- read.csv(file.path(filedir, "MaoL_2021_metadata.tsv"),
                sep = "\t")
nishiwaki <- read_xlsx(file.path(filedir, "NishiwakiH_2024_rawMetadata.xlsx"),
                                 sheet = "Sheet2")
nishiwaki_info <- read_xlsx(file.path(filedir, "columnNamesExplained.xlsx"),
                            sheet = "Sheet1")
