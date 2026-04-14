library(uuid)
library(readr)
library(dplyr)

# load and prep metadata table
original_meta_dir <- "uuid_mapping/original_metadata"
meta_file <- "VilletteR_2025.csv"
study <- read_delim(file.path(original_meta_dir, meta_file))

study_name <- "VilletteR_2025"

study <- study %>%
    mutate(study_name = study_name)

# generate UUIDs
study$uuid <- UUIDgenerate(n = nrow(study), output = "string")

# check UUIDS against previous
filedirs <- c("uuid_mapping/input_tables/kneaddata_v1/",
              "uuid_mapping/input_tables/kneaddata_v2/")
temp = list.files(path = filedirs, pattern="\\.tsv$", full.names = TRUE)
old_studies = lapply(temp, read.delim)
old_frame = bind_rows(old_studies)

if (length(unique(c(studies$uuid, old_frame$sample_id))) == (nrow(studies)+nrow(old_frame))) {
    print("UUIDs are unique.")
} else {
    print("ERROR: duplicate UUIDs detected. Please regenerate new studies.")
}

# write full metadata table with UUIDs and smaller table used to input to pipeline
write_dir <- "uuid_mapping/"
map_dir <- "uuid_maps/kneaddata_v2"
pipeline_dir <- "input_tables/kneaddata_v2"

pipeline_table <- data.frame(sample_id = study$uuid,
                          NCBI_accession = study$Run)

write_tsv(study, file.path(write_dir, map_dir, paste0(study_name, ".tsv")))
write_tsv(pipeline_table, file.path(write_dir, pipeline_dir, paste0(study_name, ".tsv")))
