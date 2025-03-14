library(dplyr)
library(readxl)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
boktor <- read_xlsx(file.path(filedir, "mds29300-sup-0017-tables10.xlsx"),
                    sheet = "metadata")
boktor_accessions1 <- read.csv(file.path(filedir, "BoktorJC_2023.csv"))

boktor1 <- boktor %>%
    filter(host_subject_id %in% boktor_accessions1$host_subject_id)
boktor_accessions1_left <- boktor_accessions1 %>%
    filter(!host_subject_id %in% boktor1$host_subject_id)

# Category: Study
boktor1 <- boktor1 %>%
    mutate(
        sample_id = id,
        subject_id = host_subject_id,
        curator = "Kaelyn Long",
        target_condition = "Parkinson disease",
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
        )
    )

boktor_accessions1_left <- boktor_accessions1_left %>%
    mutate(
        sample_id = host_subject_id,
        subject_id = host_subject_id,
        curator = "Kaelyn Long",
        target_condition = "Parkinson disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = "BoktorJC_2023",
        control = case_when(
            donor_group == "PD" ~ "Case",
            donor_group == "HC" ~ "Internal Comparison Group",
            donor_group == "PC" ~ "External Comparison Group",
            donor_group == "MSA" ~ "Multiple System Atrophy",
            donor_group == "BLANK" ~ "Study Control"
        ),
        control_ontology_term_id = case_when(
            control == "Case" ~ "NCIT:C49152",
            control == "Internal Comparison Group" ~ "NCIT:C71545",
            control == "External Comparison Group" ~ "NCIT:C71546",
            control == "Multiple System Atrophy" ~ "NCIT:C84909",
            control == "Study Control" ~ "NCIT:C142703"
        )
    )

# Category: Personal
boktor1 <- boktor1 %>%
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

boktor_accessions1_left <- boktor_accessions1_left %>%
    mutate(
        age = as.numeric(case_when(
            host_age %in% c("not provided", "") ~ NA,
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

# Category: Disease
boktor1 <- boktor1 %>%
    mutate(
        disease = case_when(
            PD == "Yes" ~ "Parkinson disease",
            PD == "No" ~ "Healthy"
        ),
        disease_ontology_term_id = case_when(
            disease == "Parkinson disease" ~ "NCIT:C26845",
            disease == "Healthy" ~ "NCIT:C115935"
        )
    )

boktor_accessions1_left <- boktor_accessions1_left %>%
    mutate(
        disease = case_when(
            control == "Case" ~ "Parkinson disease",
            control == "Multiple System Atrophy" ~ "Multiple System Atrophy",
            donor_group == "BLANK" ~ NA,
            .default = "Healthy"
        ),
        disease_ontology_term_id = case_when(
            disease == "Parkinson disease" ~ "NCIT:C26845",
            disease == "Multiple System Atrophy" ~ "NCIT:C84909",
            disease == "Healthy" ~ "NCIT:C115935"
        )
    )

# Select and save curated columns
curated_boktor1 <- bind_rows(boktor1, boktor_accessions1_left) %>%
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

write.csv(curated_boktor1, file = file.path(outdir, "BoktorJC_2023_curated_metadata.csv"), row.names = FALSE)
