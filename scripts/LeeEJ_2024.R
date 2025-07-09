library(dplyr)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
lee <- read.csv(file.path(filedir, "LeeEJ_2024.csv"))

# Category: Study
lee <- lee %>%
    mutate(
        sample_id = Sample.Name,
        subject_id = Sample.Name,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = "LeeEJ_2024",
        control = "Case",
        control_ontology_term_id = "NCIT:C49152"
    )

# Category: Disease
lee <- lee %>%
    mutate(
        disease = "Parkinson Disease",
        disease_ontology_term_id = "NCIT:C26845"
    )

# Select and save curated columns
curated_lee <- lee %>%
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

write.csv(curated_lee, file = file.path(outdir, "LeeEJ_2024_curated_metadata.csv"), row.names = FALSE)
