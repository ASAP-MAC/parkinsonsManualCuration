library(dplyr)
library(readxl)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
schonhoff <- read.csv(file.path(filedir, "MazmanianS_SchonhoffA_metadata_4.0.tsv"),
                       sep = "\t")

# Category: Study
schonhoff <- schonhoff %>%
    mutate(
        sample_id = sample_name,
        subject_id = library_ID,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = study_name,
        control = case_when(
            genotype == "PINK1 KO" ~ "Case",
            genotype == "B6J" ~ "Study Control"
        ),
        control_ontology_term_id = case_when(
            control == "Case" ~ "NCIT:C49152",
            control == "Study Control" ~ "NCIT:C142703"
        ),
        body_site = "feces",
        body_site_ontology_term_id = "UBERON:0001988",
        host_species = "Mus musculus",
        host_species_ontology_term_id = "NCBITaxon:10090"
    )

# Category: Personal
schonhoff <- schonhoff %>%
    mutate(
        age = age_weeks,
        age_group = NA,
        age_group_ontology_term_id = NA,
        age_unit = "Week",
        age_unit_ontology_term_id = case_when(
            age_unit == "Week" ~ "NCIT:C29844"
        ),
        sex = case_when(
            sex == "M" ~ "Male",
            sex == "F" ~ "Female"
        ),
        sex_ontology_term_id = case_when(
            sex == "Female" ~ "NCIT:C16576",
            sex == "Male" ~ "NCIT:C20197"
        )
    )

# Category: Disease
schonhoff <- schonhoff %>%
    mutate(
        disease = NA,
        disease_ontology_term_id = NA
    )

# Select and save curated columns
curated_schonhoff <- schonhoff %>%
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

write.csv(curated_schonhoff, file = file.path(outdir, "MazmanianS_SchonhoffA_curated_metadata.csv"), row.names = FALSE)
