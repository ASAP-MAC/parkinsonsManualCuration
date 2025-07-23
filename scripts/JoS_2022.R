library(dplyr)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
jo <- read.csv(file.path(filedir, "JoS_2022.csv"))

# Category: Study
jo <- jo %>%
    mutate(
        sample_id = Sample.Name,
        subject_id = host_status,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = "JoS_2022",
        control = case_when(
            startsWith(host_status, "Patient") ~ "Case",
            startsWith(host_status, "Control") ~ "Study Control"
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
jo <- jo %>%
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
curated_jo <- jo %>%
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

write.csv(curated_jo, file = file.path(outdir, "JoS_2022_curated_metadata.csv"), row.names = FALSE)
