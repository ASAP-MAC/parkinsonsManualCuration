library(dplyr)
library(readxl)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
nishiwaki <- read_xlsx(file.path(filedir, "NishiwakiH_2024_rawMetadata.xlsx"),
                       sheet = "Sheet2")

# Category: Study
nishiwaki <- nishiwaki %>%
    mutate(
        sample_id = ...1,
        subject_id = ...1,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = "NishiwakiH_2024",
        control = case_when(
            !is.na(HY) ~ "Case",
            is.na(HY) ~ "Study Control"
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

# Category: Personal
nishiwaki <- nishiwaki %>%
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
        age_unit_ontology_term_id = case_when(
            age_unit == "Year" ~ "NCIT:C29848"
        )#,
        #sex = case_when(
        #    Sex == "1" ~ "Female",
        #    Sex == "2" ~ "Male"
        #),
        #sex_ontology_term_id = case_when(
        #    sex == "Female" ~ "NCIT:C16576",
        #    sex == "Male" ~ "NCIT:C20197"
        #)
    )

# Category: Disease
nishiwaki <- nishiwaki %>%
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
curated_nishiwaki <- nishiwaki %>%
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
        #sex,
        #sex_ontology_term_id,
        disease,
        disease_ontology_term_id,
        curator
    )

write.csv(curated_nishiwaki, file = file.path(outdir, "NishiwakiH_2024_curated_metadata.csv"), row.names = FALSE)
