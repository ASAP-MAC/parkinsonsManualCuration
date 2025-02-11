library(dplyr)
library(readxl)

filedir <- "../original_metadata"
outdir <- "../curated_metadata"
wallen <- read_xlsx(file.path(filedir, "Source_Data_24Oct2022.xlsx"),
                    sheet = "subject_metadata")

# Category: Study
wallen <- wallen %>%
    mutate(
        sample_id = sample_name,
        subject_id = sample_name,
        curator = "Kaelyn Long",
        target_condition = "Parkinson Disease",
        target_condition_ontology_term_id = "NCIT:C26845",
        study_name = "WallenZD_2022",
        control = case_when(
            Case_status == "PD" ~ "Case",
            Case_status == "Control" ~ "Study Control"
        ),
        control_ontology_term_id = case_when(
            control == "Case" ~ "NCIT:C49152",
            control == "Study Control" ~ "NCIT:C142703"
        )
    )

# Category: Personal
wallen <- wallen %>%
    mutate(
        age = Age_at_collection,
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
        ),
        sex = case_when(
            Sex == "F" ~ "Female",
            Sex == "M" ~ "Male"
        ),
        sex_ontology_term_id = case_when(
            sex == "Female" ~ "NCIT:C16576",
            sex == "Male" ~ "NCIT:C20197"
        )
    )

# Category: Disease
wallen <- wallen %>%
    mutate(
        IBS = case_when(
            IBS == "Y" ~ "Irritable Bowel Syndrome"
        ),
        IBD = case_when(
            IBD == "Y" ~ "Inflammatory Bowel Disease"
        ),
        SIBO = case_when(
            SIBO == "Y" ~ "Small bowel bacterial overgrowth syndrome (disorder)"
        ),
        Celiac_disease = case_when(
            Celiac_disease == "Y" ~ "Celiac Disease"
        ),
        Crohns_disease = case_when(
            Crohns_disease == "Y" ~ "Crohn's disease (disorder)"
        ),
        Colitis = case_when(
            Colitis == "Y" ~ "Colitis"
        ),
        Intestinal_disease = case_when(
            Intestinal_disease == "Y" ~ "Intestinal Disorder"
        ),
        PD = case_when(
            Case_status == "PD" ~ "Parkinson disease"
        )
    ) %>%
    unite("disease", PD, IBS, IBD, SIBO, Celiac_disease, Crohns_disease,
          Colitis, Intestinal_disease, sep = ";", na.rm = TRUE) %>%
    mutate(
        disease = str_remove(disease, ";Intestinal Disorder"),
        disease = case_when(
            disease == "" ~ "Healthy",
            disease != "" ~ disease
        ),
        disease_ontology_term_id = str_replace_all(disease, c(
            "Parkinson disease" = "NCIT:C26845",
            "Irritable Bowel Syndrome" = "NCIT:C82343",
            "Inflammatory Bowel Disease" = "NCIT:C3138",
            "Small bowel bacterial overgrowth syndrome (disorder)" = "SNOMED:446081009",
            "Celiac Disease" = "NCIT:C26714",
            "Crohn's disease (disorder)" = "SNOMED:34000006",
            "Colitis" = "NCIT:C26723",
            "Intestinal Disorder" = "NCIT:C26801",
            "Healthy" = "NCIT:C115935")
        )
    )

# Select and save curated columns
curated_wallen <- wallen %>%
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

write.csv(curated_wallen, file = file.path(outdir, "wallen_2022_curated_metadata.csv"), row.names = FALSE)
