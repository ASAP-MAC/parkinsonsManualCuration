library(dplyr)
library(readxl)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
decastro1 <- read.csv(file.path(filedir, "MazmanianS_DeCastroFonsecaM_metadata_project1.tsv"),
                   sep = "\t")
decastro2 <- read.csv(file.path(filedir, "MazmanianS_DeCastroFonsecaM_metadata_project2.tsv"),
                      sep = "\t")
decastro3 <- read.csv(file.path(filedir, "MazmanianS_DeCastroFonsecaM_metadata_project3.tsv"),
                      sep = "\t")
decastro4 <- read.csv(file.path(filedir, "MazmanianS_DeCastroFonsecaM_metadata_project4.tsv"),
                      sep = "\t")

# Category: Study
decastro1 <- decastro1 %>%
    mutate(
        sample_id = sample_name,
        subject_id = library_ID,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = study_name,
        control = case_when(
            genotype == "ASO" ~ "Case",
            genotype == "WT" ~ "Study Control"
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

decastro2 <- decastro2 %>%
    mutate(
        sample_id = sample_name,
        subject_id = library_ID,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = study_name,
        control = case_when(
            genotype == "ASO" ~ "Case",
            genotype == "WT" ~ "Study Control"
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

decastro3 <- decastro3 %>%
    mutate(
        sample_id = sample_name,
        subject_id = library_ID,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = study_name,
        control = case_when(
            FMT.donor == "ASO 5 months" ~ "Case",
            FMT.donor == "WT 2 months" ~ "Study Control"
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

decastro4 <- decastro4 %>%
    mutate(
        sample_id = sample_name,
        subject_id = library_ID,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = study_name,
        control = case_when(
            donor_abx_treatment == "None" ~ "Study Control",
            .default = "Case",
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
decastro1 <- decastro1 %>%
    mutate(
        age = age..months.,
        age_group = NA,
        age_group_ontology_term_id = NA,
        age_unit = "Month",
        age_unit_ontology_term_id = case_when(
            age_unit == "Month" ~ "NCIT:C29846"
        ),
        sex = NA,
        sex_ontology_term_id = NA
    )

decastro2 <- decastro2 %>%
    mutate(
        age = age..days.,
        age_group = NA,
        age_group_ontology_term_id = NA,
        age_unit = "Day",
        age_unit_ontology_term_id = case_when(
            age_unit == "Day" ~ "NCIT:C25301"
        ),
        sex = NA,
        sex_ontology_term_id = NA
    )

decastro3 <- decastro3 %>%
    mutate(
        age = age..months.,
        age_group = NA,
        age_group_ontology_term_id = NA,
        age_unit = "Month",
        age_unit_ontology_term_id = case_when(
            age_unit == "Month" ~ "NCIT:C29846"
        ),
        sex = NA,
        sex_ontology_term_id = NA
    )

decastro4 <- decastro4 %>%
    mutate(
        age = age..months.,
        age_group = NA,
        age_group_ontology_term_id = NA,
        age_unit = "Month",
        age_unit_ontology_term_id = case_when(
            age_unit == "Month" ~ "NCIT:C29846"
        ),
        sex = NA,
        sex_ontology_term_id = NA
    )

# Category: Disease
decastro1 <- decastro1 %>%
    mutate(
        disease = NA,
        disease_ontology_term_id = NA
    )

decastro2 <- decastro2 %>%
    mutate(
        disease = NA,
        disease_ontology_term_id = NA
    )

decastro3 <- decastro3 %>%
    mutate(
        disease = NA,
        disease_ontology_term_id = NA
    )

decastro4 <- decastro4 %>%
    mutate(
        disease = NA,
        disease_ontology_term_id = NA
    )

# Select and save curated columns
curated_decastro1 <- decastro1 %>%
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

curated_decastro2 <- decastro2 %>%
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

curated_decastro3 <- decastro3 %>%
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

curated_decastro4 <- decastro4 %>%
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

curated_decastro <- bind_rows(curated_decastro1, curated_decastro2,
                              curated_decastro3, curated_decastro4)

write.csv(curated_decastro, file = file.path(outdir, "MazmanianS_DeCastroFonsecaM_curated_metadata.csv"), row.names = FALSE)
