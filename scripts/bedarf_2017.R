library(dplyr)
library(readxl)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
bedarf <- read.csv(file.path(filedir, "BedarfJR_2017_metadata_newgrammar.tsv"),
                   sep = "\t")

# Category: Study
bedarf <- bedarf %>%
    mutate(
        sample_id = sample_id,
        subject_id = subject_id,
        curator = curator,
        target_condition = "Parkinson disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = "BedarfJR_2017",
        control = case_when(
            control == "Case" ~ "Case",
            control == "Study control" ~ "Study Control"
        ),
        control_ontology_term_id = case_when(
            control == "Case" ~ "NCIT:C49152",
            control == "Study Control" ~ "NCIT:C142703"
        )
    )

# Category: Personal
bedarf <- bedarf %>%
    mutate(
        age = age,
        age_group = age_group,
        age_group_ontology_term_id = case_when(
            age_group == "Adolescent" ~ "NCIT:C27954",
            age_group == "Adult" ~ "NCIT:C49685",
            age_group == "Children 2-11 Years Old" ~ "NCIT:C49683",
            age_group == "Elderly" ~ "NCIT:C16268",
            age_group == "Infant" ~ "NCIT:C27956"
        ),
        age_unit = "Year",
        age_unit_ontology_term_id = case_when(
            age_unit == "Year" ~ "NCIT:C29848"
        ),
        sex = case_when(
            sex == "Male" ~ "Male",
            sex == "Na" ~ NA
        ),
        sex_ontology_term_id = case_when(
            sex == "Female" ~ "NCIT:C16576",
            sex == "Male" ~ "NCIT:C20197"
        )
    )

# Category: Disease
bedarf <- bedarf %>%
    mutate(
        disease = case_when(
            disease == "Parkinson disease" ~ "Parkinson disease",
            disease == "healthy" ~ "Healthy"
        ),
        disease_ontology_term_id = case_when(
            disease == "Parkinson disease" ~ "NCIT:C26845",
            disease == "Healthy" ~ "NCIT:C115935"
        )
    )

# Select and save curated columns
curated_bedarf <- bedarf %>%
    mutate(curation_id = paste(study_name, subject_id, sep = ":")) %>%
    select(
        curation_id,
        study_name,
        sample_id,
        subject_id,
        target_condition,
        target_condition_ontology_term_id,
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

write.csv(curated_bedarf, file = file.path(outdir, "bedarf_2017_curated_metadata.csv"), row.names = FALSE)
