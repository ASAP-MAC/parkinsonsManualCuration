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
jo <- read.csv(file.path(filedir, "JoS_2022.csv"))
lee <- read.csv(file.path(filedir, "LeeEJ_2024.csv"))
zhang <- read.csv(file.path(filedir, "ZhangM_2023.csv"))
duru <- read.csv(file.path(filedir, "DuruIC_2024.csv"))
qian <- read.csv(file.path(filedir, "QianY_2020.tsv"), sep = "\t")
