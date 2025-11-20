library(purrr)
library(dplyr)
library(readr)
library(readxl)

# file structure
curation_dir <- "/home/kaelyn/Desktop/Work/ASAP_MAC/parkinsonsManualCuration"
curated_dir <- file.path(curation_dir, "curated_metadata")
original_dir <- file.path(curation_dir, "original_metadata")
map_dir <- "/home/kaelyn/Desktop/Work/ASAP_MAC/parkinsons_data_search/shotgun_samples/sample_uuid_maps"
accession_dir <- "/home/kaelyn/Desktop/Work/ASAP_MAC/pipeline/data/ParkinsonAccessions/ParkinsonAccessions/"

# curated metadata
temp <- list.files(path = curated_dir, pattern="\\.csv$")
curated_meta <- lapply(file.path(curated_dir, temp), read.csv)
names(curated_meta) <- c("bedarf", "boktor1", "boktor2", "duru", "jo", "lee",
                         "mao", "decastro", "dumitrescu", "moiseyenko",
                         "schonhoff", "nishiwaki", "qian", "wallen", "zhang")
#all_curated <- bind_rows(curated_meta)

# UUID maps
temp <- list.files(path = map_dir, pattern="\\.tsv$")
uuid_maps <- lapply(file.path(map_dir, temp), read.delim)
uuid_maps <- lapply(uuid_maps, function(x) x %>% rename(BioSample = sample_id))
names(uuid_maps) <- c("bedarf", "boktor1", "boktor2", "duru", "jo", "lee",
                      "mao", "nishiwaki", "qian", "wallen", "zhang")
#all_uuids <- bind_rows(uuid_maps)

# accession lists
temp <- list.files(path = accession_dir, pattern="\\.csv$")
accession_lists <- lapply(file.path(accession_dir, temp), read.csv)
temp <- list.files(path = accession_dir, pattern="\\.tsv$")
accession_lists <- append(accession_lists,
                          list(read.delim(file.path(accession_dir, temp))), 8)
accession_lists <- lapply(accession_lists, function(x) x %>%
                              mutate(across(everything(), as.character)))
names(accession_lists) <- c("bedarf", "boktor1", "boktor2", "duru", "jo", "lee",
                            "mao", "nishiwaki", "qian", "wallen", "zhang")
#all_accessions <- bind_rows(accession_lists)

# combine curated with original metadata
all_metas <- list("bedarf" = NULL,
                  "boktor" = NULL,
                  "duru" = NULL,
                  "jo" = NULL,
                  "lee" = NULL,
                  "mao" = NULL,
                  "decastro" = NULL,
                  "dumitrescu" = NULL,
                  "moiseyenko" = NULL,
                  "schonhoff" = NULL,
                  "nishiwaki" = NULL,
                  "qian" = NULL,
                  "wallen" = NULL,
                  "zhang" = NULL)

final_metas <- list("bedarf" = NULL,
                    "boktor" = NULL,
                    "duru" = NULL,
                    "jo" = NULL,
                    "lee" = NULL,
                    "mao" = NULL,
                    "decastro" = NULL,
                    "dumitrescu" = NULL,
                    "moiseyenko" = NULL,
                    "schonhoff" = NULL,
                    "nishiwaki" = NULL,
                    "qian" = NULL,
                    "wallen" = NULL,
                    "zhang" = NULL)

curated_cols <- c("curation_id",
                  "study_name",
                  "sample_id",
                  "subject_id",
                  "target_condition",
                  "target_condition_ontology_term_id",
                  "body_site",
                  "body_site_ontology_term_id",
                  "host_species",
                  "host_species_ontology_term_id",
                  "control",
                  "control_ontology_term_id",
                  "age",
                  "age_group",
                  "age_group_ontology_term_id",
                  "age_unit",
                  "age_unit_ontology_term_id",
                  "sex",
                  "sex_ontology_term_id",
                  "disease",
                  "disease_ontology_term_id",
                  "curator")

# bedarf
bedarf <- read.csv(file.path(original_dir, "BedarfJR_2017_metadata_newgrammar.tsv"),
                   sep = "\t") %>% rename_with( ~ paste0("uncurated_", .x))
all_metas$bedarf <- curated_meta$bedarf %>%
    left_join(bedarf,
              by = join_by(sample_id == uncurated_sample_id),
              suffix = c("", ""),
              keep = TRUE)
final_metas$bedarf <- uuid_maps$bedarf %>%
    left_join(all_metas$bedarf,
              by = join_by(NCBI_accession == uncurated_ncbi_accession),
              suffix = c("", ""),
              keep = TRUE)

# boktor
boktor <- read_xlsx(file.path(original_dir, "mds29300-sup-0017-tables10.xlsx"),
                    sheet = "metadata") %>%
    mutate(across(everything(), as.character)) %>%
    rename_with( ~ paste0("uncurated_", .x))
boktor_curated <- bind_rows(curated_meta$boktor1, curated_meta$boktor2)
boktor_accessions_left <- bind_rows(accession_lists$boktor1,
                                    accession_lists$boktor2) %>%
    filter(!host_subject_id %in% boktor$uncurated_host_subject_id) %>%
    rename_with( ~ paste0("uncurated_", .x))
boktor_uncurated <- bind_rows(boktor, boktor_accessions_left)
all_metas$boktor <- boktor_curated %>%
    left_join(boktor_uncurated,
              by = join_by(subject_id == uncurated_host_subject_id),
              suffix = c("", ""),
              keep = TRUE)
boktor_accessions <- bind_rows(accession_lists$boktor1 %>%
                                   select(BioSample, host_subject_id),
                               accession_lists$boktor2 %>%
                                   select(BioSample, host_subject_id))
all_metas$boktor <- boktor_accessions %>%
    right_join(all_metas$boktor,
               by = join_by(host_subject_id == uncurated_host_subject_id),
               keep = TRUE) %>%
    select(-host_subject_id)
boktor_uuids <- bind_rows(uuid_maps$boktor1, uuid_maps$boktor2)
final_metas$boktor <- boktor_uuids %>%
    left_join(all_metas$boktor,
              by = join_by(BioSample),
              suffix = c("", ""),
              keep = TRUE)

# duru
duru <- read.csv(file.path(original_dir, "DuruIC_2024.csv")) %>%
    rename_with( ~ paste0("uncurated_", .x))
all_metas$duru <- curated_meta$duru %>%
    left_join(duru,
              by = join_by(sample_id == uncurated_Sample_name),
              suffix = c("", ""),
              keep = TRUE)
all_metas$duru <- accession_lists$duru %>%
    select(BioSample, Sample_name) %>%
    right_join(all_metas$duru,
               by = join_by(Sample_name == sample_id),
               keep = TRUE) %>%
    select(-Sample_name)
final_metas$duru <- uuid_maps$duru %>%
    left_join(all_metas$duru,
              by = join_by(BioSample),
              suffix = c("", ""),
              keep = TRUE)

# jo
jo <- read.csv(file.path(original_dir, "JoS_2022.csv")) %>%
    rename_with( ~ paste0("uncurated_", .x))
all_metas$jo <- curated_meta$jo %>%
    left_join(jo,
              by = join_by(sample_id == uncurated_Sample.Name),
              suffix = c("", ""),
              keep = TRUE)
all_metas$jo <- accession_lists$jo %>%
    select(BioSample, Sample.Name) %>%
    right_join(all_metas$jo,
               by = join_by(Sample.Name == sample_id),
               keep = TRUE) %>%
    select(-Sample.Name)
final_metas$jo <- uuid_maps$jo %>%
    left_join(all_metas$jo,
              by = join_by(BioSample),
              suffix = c("", ""),
              keep = TRUE)

# lee
lee <- read.csv(file.path(original_dir, "LeeEJ_2024.csv")) %>%
    rename_with( ~ paste0("uncurated_", .x))
all_metas$lee <- curated_meta$lee %>%
    left_join(lee,
              by = join_by(sample_id == uncurated_Sample.Name),
              suffix = c("", ""),
              keep = TRUE)
all_metas$lee <- accession_lists$lee %>%
    select(BioSample, Sample.Name) %>%
    right_join(all_metas$lee,
               by = join_by(Sample.Name == sample_id),
               keep = TRUE) %>%
    select(-Sample.Name)
final_metas$lee <- uuid_maps$lee %>%
    left_join(all_metas$lee,
              by = join_by(BioSample),
              suffix = c("", ""),
              keep = TRUE)

# mao
mao <- read.csv(file.path(original_dir, "MaoL_2021_metadata.tsv"),
                sep = "\t") %>% rename_with( ~ paste0("uncurated_", .x))
all_metas$mao <- curated_meta$mao %>%
    left_join(mao,
              by = join_by(sample_id == uncurated_sample_id),
              suffix = c("", ""),
              keep = TRUE)
final_metas$mao <- uuid_maps$mao %>%
    left_join(all_metas$mao,
              by = join_by(NCBI_accession == uncurated_ncbi_accession),
              suffix = c("", ""),
              keep = TRUE)

# decastro
decastro1 <- read.csv(file.path(original_dir, "MazmanianS_DeCastroFonsecaM_metadata_project1.tsv"),
                      sep = "\t") %>%
    rename_with( ~ paste0("uncurated_", .x)) %>%
    mutate(temp_sample_name = uncurated_sample_name) %>%
    mutate(across(everything(), as.character))
decastro2 <- read.csv(file.path(original_dir, "MazmanianS_DeCastroFonsecaM_metadata_project2.tsv"),
                      sep = "\t") %>%
    rename_with( ~ paste0("uncurated_", .x)) %>%
    mutate(temp_sample_name = uncurated_sample_name) %>%
    mutate(across(everything(), as.character))
decastro3 <- read.csv(file.path(original_dir, "MazmanianS_DeCastroFonsecaM_metadata_project3.tsv"),
                      sep = "\t") %>%
    rename_with( ~ paste0("uncurated_", .x)) %>%
    mutate(temp_sample_name = uncurated_sample_name) %>%
    mutate(across(everything(), as.character))
decastro4 <- read.csv(file.path(original_dir, "MazmanianS_DeCastroFonsecaM_metadata_project4.tsv"),
                      sep = "\t") %>%
    rename_with( ~ paste0("uncurated_", .x)) %>%
    mutate(temp_sample_name = uncurated_sample_name) %>%
    mutate(across(everything(), as.character))
decastro5a <- read.csv(file.path(original_dir, "MazmanianS_DeCastroFonsecaM_5a.tsv"),
                       sep = "\t") %>%
    rename_with( ~ paste0("uncurated_", .x)) %>%
    mutate(temp_sample_name = uncurated_library.name) %>%
    mutate(across(everything(), as.character))
decastro5b <- read.csv(file.path(original_dir, "MazmanianS_DeCastroFonsecaM_5b.tsv"),
                       sep = "\t") %>%
    rename_with( ~ paste0("uncurated_", .x)) %>%
    mutate(temp_sample_name = uncurated_Sample_ID) %>%
    mutate(across(everything(), as.character))

decastro_all <- bind_rows(decastro1, decastro2, decastro3, decastro4,
                          decastro5a, decastro5b) %>%
    rename(uuid = uncurated_uuid)

all_metas$decastro <- curated_meta$decastro %>%
    left_join(decastro_all,
              by = join_by(sample_id == temp_sample_name),
              suffix = c("", ""),
              keep = TRUE) %>%
    select(-temp_sample_name)
final_metas$decastro <- all_metas$decastro

# dumitrescu
dumitrescu <- read.csv(file.path(original_dir, "MazmanianS_DumitrescuDG_metadata_4.0.tsv"),
                      sep = "\t") %>%
    rename_with( ~ paste0("uncurated_", .x)) %>%
    rename(uuid = uncurated_uuid)
all_metas$dumitrescu <- curated_meta$dumitrescu %>%
    left_join(dumitrescu,
              by = join_by(sample_id == uncurated_sample_name),
              suffix = c("", ""),
              keep = TRUE)
final_metas$dumitrescu <- all_metas$dumitrescu

# moiseyenko
moiseyenko <- read.csv(file.path(original_dir, "MazmanianS_MoiseyenkoA_metadata_4.0.tsv"),
                       sep = "\t") %>%
    rename_with( ~ paste0("uncurated_", .x)) %>%
    rename(uuid = uncurated_uuid)
all_metas$moiseyenko <- curated_meta$moiseyenko %>%
    left_join(moiseyenko,
              by = join_by(sample_id == uncurated_sample_name),
              suffix = c("", ""),
              keep = TRUE)
final_metas$moiseyenko <- all_metas$moiseyenko

# schonhoff
schonhoff <- read.csv(file.path(original_dir, "MazmanianS_SchonhoffA_metadata_4.0.tsv"),
                       sep = "\t") %>%
    rename_with( ~ paste0("uncurated_", .x)) %>%
    rename(uuid = uncurated_uuid)
all_metas$schonhoff <- curated_meta$schonhoff %>%
    left_join(schonhoff,
              by = join_by(sample_id == uncurated_sample_name),
              suffix = c("", ""),
              keep = TRUE)
final_metas$schonhoff <- all_metas$schonhoff

# nishiwaki
nishiwaki <- read_xlsx(file.path(original_dir, "NishiwakiH_2024_rawMetadata.xlsx"),
                       sheet = "Sheet2")[,1:43] %>%
    rename_with( ~ paste0("uncurated_", .x))
all_metas$nishiwaki <- curated_meta$nishiwaki %>%
    left_join(nishiwaki,
              by = join_by(sample_id == uncurated_...1),
              suffix = c("", ""),
              keep = TRUE)
all_metas$nishiwaki <- accession_lists$nishiwaki %>%
    select(BioSample, Sample_name) %>%
    right_join(all_metas$nishiwaki,
               by = join_by(Sample_name == sample_id),
               keep = TRUE) %>%
    select(-Sample_name)
final_metas$nishiwaki <- uuid_maps$nishiwaki %>%
    left_join(all_metas$nishiwaki,
              by = join_by(BioSample),
              suffix = c("", ""),
              keep = TRUE)

# qian
qian <- read.delim(file.path(original_dir, "QianY_2020.tsv")) %>%
    rename_with( ~ paste0("uncurated_", .x))
all_metas$qian <- curated_meta$qian %>%
    left_join(qian,
              by = join_by(sample_id == uncurated_Sample.Name),
              suffix = c("", ""),
              keep = TRUE)
all_metas$qian <- accession_lists$qian %>%
    select(BioSample, Sample.Name) %>%
    right_join(all_metas$qian,
               by = join_by(Sample.Name == sample_id),
               keep = TRUE) %>%
    select(-Sample.Name)
final_metas$qian <- uuid_maps$qian %>%
    left_join(all_metas$qian,
              by = join_by(BioSample),
              suffix = c("", ""),
              keep = TRUE)

# wallen
wallen <- read.csv(file.path(original_dir, "WallenZD_2022.csv")) %>%
    rename_with( ~ paste0("uncurated_", .x))
all_metas$wallen <- curated_meta$wallen %>%
    left_join(wallen,
              by = join_by(sample_id == uncurated_Sample.Name),
              suffix = c("", ""),
              keep = TRUE)
all_metas$wallen <- accession_lists$wallen %>%
    select(BioSample, Sample.Name) %>%
    right_join(all_metas$wallen,
               by = join_by(Sample.Name == sample_id),
               keep = TRUE) %>%
    select(-Sample.Name)
final_metas$wallen <- uuid_maps$wallen %>%
    left_join(all_metas$wallen,
              by = join_by(BioSample),
              suffix = c("", ""),
              keep = TRUE)

# zhang
zhang <- read.csv(file.path(original_dir, "ZhangM_2023.csv")) %>%
    rename_with( ~ paste0("uncurated_", .x))
all_metas$zhang <- curated_meta$zhang %>%
    left_join(zhang,
              by = join_by(sample_id == uncurated_Sample.Name),
              suffix = c("", ""),
              keep = TRUE)
all_metas$zhang <- accession_lists$zhang %>%
    select(BioSample, Sample.Name) %>%
    right_join(all_metas$zhang,
               by = join_by(Sample.Name == sample_id),
               keep = TRUE) %>%
    select(-Sample.Name)
final_metas$zhang <- uuid_maps$zhang %>%
    left_join(all_metas$zhang,
              by = join_by(BioSample),
              suffix = c("", ""),
              keep = TRUE)

# merge
final_metas <- lapply(final_metas, function(x) x %>%
                          mutate(across(-any_of(curated_cols), as.character)))
sampleMetadata <- bind_rows(final_metas)
save(sampleMetadata, file = "../sampleMetadata.rda")
#write.csv(merged_metadata, file = "/home/kaelyn/Desktop/Work/ASAP_MAC/parkinsonsMetagenomicData/shotgun_samples/merged_metadata.csv", row.names = FALSE)

