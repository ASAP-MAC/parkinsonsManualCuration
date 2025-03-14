library(dplyr)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
zhang <- read.csv(file.path(filedir, "ZhangM_2023.csv"))

# Category: Study
zhang <- zhang %>%
    mutate(
        sample_id = Sample.Name,
        subject_id = Sample.Name,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = "ZhangM_2023",
        control = "Case",
        control_ontology_term_id = "NCIT:C49152"
    )

# Category: Disease
zhang <- zhang %>%
    mutate(
        disease = "Parkinson disease",
        disease_ontology_term_id = "NCIT:C26845"
    )

# Select and save curated columns
curated_zhang <- zhang %>%
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

write.csv(curated_zhang, file = file.path(outdir, "ZhangM_2023_curated_metadata.csv"), row.names = FALSE)
