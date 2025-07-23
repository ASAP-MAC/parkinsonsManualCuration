library(dplyr)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
qian <- read.csv(file.path(filedir, "QianY_2020.tsv"), sep = "\t")

# Category: Study
qian <- qian %>%
    mutate(
        sample_id = Sample.Name,
        subject_id = Sample.Name,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = "QianY_2020",
        control = case_when(
            startsWith(Sample.Name, "MP") ~ "Case",
            startsWith(Sample.Name, "MC") ~ "Study Control"
        ),
        control_ontology_term_id = case_when(
            control == "Case" ~ "NCIT:C49152",
            control == "Study Control" ~ "NCIT:C142703"
        ),
        body_site = "feces",
        body_site_ontology_term_id = "UBERON:0001988",
        host_species = "Homo sapiens",
        host_species_ontology_term_id = "NCBITaxon:9606"
    )

# Category: Disease
qian <- qian %>%
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
curated_qian <- qian %>%
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
        disease,
        disease_ontology_term_id,
        curator
    )

write.csv(curated_qian, file = file.path(outdir, "QianY_2020_curated_metadata.csv"), row.names = FALSE)
