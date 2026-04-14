library(dplyr)
library(readxl)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
asnicar <- read.csv(file.path(filedir, "AsnicarF_2021.tsv"),
                    sep = "\t")

# Category: Study
asnicar <- asnicar %>%
  mutate(
    sample_id = sample_id,
    subject_id = subject_id,
    curator = curator,
    target_condition = NA,
    target_condition_ontology_term_id = NA,
    study_name = study_name,
    control = "Study Control",
    control_ontology_term_id = "NCIT:C142703",
    body_site = "feces",
    body_site_ontology_term_id = "UBERON:0001988",
    host_species = "Homo sapiens",
    host_species_ontology_term_id = "NCBITaxon:9606"
  )

# Category: Personal
asnicar <- asnicar %>%
  mutate(
    age = age,
    age_group = case_when(
      11 <= age & age < 18 ~ "Adolescent",
      18 <= age & age < 65 ~ "Adult",
      2 <= age & age < 11 ~ "Children 2-11 Years Old",
      65 <= age & age < 130 ~ "Elderly",
      0 <= age & age < 2 ~ "Infant"
    ),
    age_group_ontology_term_id = case_when(
      age_group == "Adolescent" ~ "NCIT:C27954",
      age_group == "Adult" ~ "NCIT:C49685",
      age_group == "Children 2-11 Years Old" ~ "NCIT:C49683",
      age_group == "Elderly" ~ "NCIT:C16268",
      age_group == "Infant" ~ "NCIT:C27956"
    ),
    age_unit = "Year",
    age_unit_ontology_term_id = "NCIT:C29848",
    sex = case_when(
      gender == "female" ~ "Female",
      gender == "male" ~ "Male"
    ),
    sex_ontology_term_id = case_when(
      sex == "Female" ~ "NCIT:C16576",
      sex == "Male" ~ "NCIT:C20197"
    )
  )

# Category: Disease
asnicar <- asnicar %>%
  mutate(disease = "Healthy",
         disease_ontology_term_id = "NCIT:C115935"
  )

# Select and save curated columns
curated_asnicar <- asnicar %>%
  mutate(curation_id = paste(study_name, subject_id, sep = ":")) %>%
  select(
    curation_id,
    study_name,
    sample_id,
    subject_id,
    target_condition,
    target_condition_ontology_term_id,
    body_site,
    body_site_ontology_term_id,
    host_species,
    host_species_ontology_term_id,
    control,
    control_ontology_term_id,
    age,
    age_group,
    age_group_ontology_term_id,
    age_unit,
    age_unit_ontology_term_id,
    sex,
    sex_ontology_term_id,
    disease,
    disease_ontology_term_id,
    curator
  )

write.csv(curated_asnicar, file = file.path(outdir, "AsnicarF_2021_curated_metadata.csv"), row.names = FALSE)
