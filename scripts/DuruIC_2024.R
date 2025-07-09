library(dplyr)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
duru <- read.csv(file.path(filedir, "DuruIC_2024.csv"))

# Category: Study
duru <- duru %>%
    mutate(
        sample_id = Sample_name,
        subject_id = Sample_name,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = "DuruIC_2024",
        control = case_when(
            startsWith(Sample_name, "P") ~ "Case",
            startsWith(Sample_name, "C") ~ "Study Control"
        ),
        control_ontology_term_id = case_when(
            control == "Case" ~ "NCIT:C49152",
            control == "Study Control" ~ "NCIT:C142703"
        )
    )

# Category: Disease
duru <- duru %>%
    mutate(
        disease = case_when(
            control == "Case" ~ "Parkinson Disease",
            control == "Study Control" ~ "Healthy"
        ),
        disease_ontology_term_id = case_when(
            disease == "Parkinson Disease" ~ "NCIT:C26845",
            disease == "Healthy" ~ "NCIT:C115935"
        )
    )

# Select and save curated columns
curated_duru <- duru %>%
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
        disease,
        disease_ontology_term_id,
        curator
    )

write.csv(curated_duru, file = file.path(outdir, "DuruIC_2024_curated_metadata.csv"), row.names = FALSE)
