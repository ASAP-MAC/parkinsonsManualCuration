library(dplyr)
library(readxl)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
sampson <- read.csv(file.path(filedir, "SampsonTR_2025.tsv"),
                    sep = "\t")

# Category: Study
sampson <- sampson %>%
  mutate(
    sample_id = Sample.Name,
    subject_id = mouse_id,
    curator = "Kaelyn Long",
    target_condition = "Parkinson Disease",
    target_condition_ontology_term_id = "NCIT:C26845",
    study_name = study_name,
    control = case_when(
      Group == "TG" ~ "Case",
      Group == "NTG" ~ "Study Control"
    ),
    control_ontology_term_id = case_when(
      control == "Case" ~ "NCIT:C49152",
      control == "Study Control" ~ "NCIT:C142703"
    ),
    host_species = HOST,
    host_species_ontology_term_id = "NCBITaxon:10090"
  )

# Category: Personal
sampson <- sampson %>%
  mutate(
    age = AGE,
    age_unit = "Month",
    age_unit_ontology_term_id = "NCIT:C29846",
    sex = "Male",
    sex_ontology_term_id = "NCIT:C20197"
  )

# Select and save curated columns
curated_sampson <- sampson %>%
  mutate(curation_id = paste(study_name, subject_id, sep = ":")) %>%
  select(
    curation_id,
    study_name,
    sample_id,
    subject_id,
    target_condition,
    target_condition_ontology_term_id,
    host_species,
    host_species_ontology_term_id,
    control,
    control_ontology_term_id,
    age,
    age_unit,
    age_unit_ontology_term_id,
    sex,
    sex_ontology_term_id,
    curator
  )

write.csv(curated_sampson, file = file.path(outdir, "SampsonJR_2017_curated_metadata.csv"), row.names = FALSE)
