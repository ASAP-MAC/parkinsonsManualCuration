library(dplyr)
library(readxl)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
boktor <- read_xlsx(file.path(filedir, "mds29300-sup-0017-tables10.xlsx"),
                    sheet = "metadata")
boktor_accessions2 <- read.csv(file.path(filedir, "BoktorJC.2_2023.csv"))

boktor2 <- boktor %>%
    filter(host_subject_id %in% boktor_accessions2$host_subject_id)
boktor_accessions2_left <- boktor_accessions2 %>%
    filter(!host_subject_id %in% boktor2$host_subject_id)

# Category: Study
boktor2 <- boktor2 %>%
    mutate(
        sample_id = id,
        subject_id = host_subject_id,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = "BoktorJC_2023",
        control = case_when(
            donor_group == "PD" ~ "Case",
            donor_group == "HC" ~ "Internal Comparison Group",
            donor_group == "PC" ~ "External Comparison Group"
        ),
        control_ontology_term_id = case_when(
            control == "Case" ~ "NCIT:C49152",
            control == "Internal Comparison Group" ~ "NCIT:C71545",
            control == "External Comparison Group" ~ "NCIT:C71546"
        ),
        body_site = "feces",
        body_site_ontology_term_id = "UBERON:0001988",
        host_species = "Homo sapiens",
        host_species_ontology_term_id = "NCBITaxon:9606"
    )

boktor_accessions2_left <- boktor_accessions2_left %>%
    mutate(
        sample_id = host_subject_id,
        subject_id = host_subject_id,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = "BoktorJC_2023",
        control = case_when(
            donor_group == "PD Patient" ~ "Case",
            donor_group == "Household Control" ~ "Internal Comparison Group"
        ),
        control_ontology_term_id = case_when(
            control == "Case" ~ "NCIT:C49152",
            control == "Internal Comparison Group" ~ "NCIT:C71545"
        ),
        body_site = "feces",
        body_site_ontology_term_id = "UBERON:0001988",
        host_species = "Homo sapiens",
        host_species_ontology_term_id = "NCBITaxon:9606"
    )

# Category: Personal
boktor2 <- boktor2 %>%
    mutate(
        age = as.numeric(case_when(
            host_age %in% c("not provided", "not collected") ~ NA,
            .default = host_age
            )),
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
        age_unit = case_when(
            !is.na(age) ~ "Year"
        ),
        age_unit_ontology_term_id = case_when(
            !is.na(age_unit) ~ "NCIT:C29848"
        ),
        sex = case_when(
            sex == "female" ~ "Female",
            sex == "male" ~ "Male"
        ),
        sex_ontology_term_id = case_when(
            sex == "Female" ~ "NCIT:C16576",
            sex == "Male" ~ "NCIT:C20197"
        )
    )

boktor_accessions2_left <- boktor_accessions2_left %>%
    mutate(
        age = as.numeric(host_age),
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
        age_unit_ontology_term_id = "NCIT:C29848",
        sex = case_when(
            sex == "female" ~ "Female",
            sex == "male" ~ "Male"
        ),
        sex_ontology_term_id = case_when(
            sex == "Female" ~ "NCIT:C16576",
            sex == "Male" ~ "NCIT:C20197"
        )
    )

# Category: Disease
boktor2 <- boktor2 %>%
    mutate(
        disease = case_when(
            PD == "Yes" ~ "Parkinson Disease",
            PD == "No" ~ "Healthy"
        ),
        disease_ontology_term_id = case_when(
            disease == "Parkinson Disease" ~ "NCIT:C26845",
            disease == "Healthy" ~ "NCIT:C115935"
        )
    )

boktor_accessions2_left <- boktor_accessions2_left %>%
    mutate(
        disease = case_when(
            control == "Case" ~ "Parkinson Disease",
            .default = "Healthy"
        ),
        disease_ontology_term_id = case_when(
            disease == "Parkinson Disease" ~ "NCIT:C26845",
            disease == "Healthy" ~ "NCIT:C115935"
        )
    )

# Select and save curated columns
curated_boktor2 <- bind_rows(boktor2, boktor_accessions2_left) %>%
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

write.csv(curated_boktor2, file = file.path(outdir, "BoktorJC.2_2023_curated_metadata.csv"), row.names = FALSE)

