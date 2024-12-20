# PDmanualCuration

This repository keeps track of the process of manually curating Parkinson's metadata.
At the moment, we are prioritizing the curation of the following metadata features: Case/Control Status (for Parkinson's Disease), Age, and Sex.
Curation is carried out following the data dictionary, merging schema, and ontology maps outlined in [OmicsMLRepoData](https://github.com/waldronlab/OmicsMLRepoData) (OmicsMLRepoData contains the latest version of [curatedMetagenomicData](https://github.com/waldronlab/curatedMetagenomicData) curation) where possible.
Original metadata files are stored in `original_metadata/`, and each dataset is curated in its respectively named R script, stored in `scripts/`.
Also within `scripts/`, `harmonization.R` loads all of the original metadata for visualization.
Harmonized metadata will be output to `curated_metadata/`.
