library(dplyr)
library(readxl)

filedir <- "/home/kaelyn/Desktop/Work/ASAP_MAC/harmonization/original_metadata"
boktor <- read_xlsx(file.path(filedir, "mds29300-sup-0017-tables10.xlsx"),
                    sheet = "metadata")

# Category: Study
boktor <- boktor %>%
    mutate(
        sample_id = id,
        subject_id = host_subject_id,
        curator = "Kaelyn Long",
        target_condition = "Parkinsons disease",
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
#boktor$pmid
#boktor$ncbi_accession

# Category: Personal
boktor <- boktor %>%
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
            age == "Adolescent" ~ "NCIT:C27954",
            age == "Adult" ~ "NCIT:C49685",
            age == "Children 2-11 Years Old" ~ "NCIT:C49683",
            age == "Elderly" ~ "NCIT:C16268",
            age == "Infant" ~ "NCIT:C27956"
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
boktor <- boktor %>%
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

# Select and save curated columns
curated_boktor <- boktor %>%
    mutate(curation_id = paste(study_name, subject_id, sep = ":"))
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