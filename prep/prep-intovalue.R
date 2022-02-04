library(tidyverse)
library(rio)
library(here)
library(fs)

## Get intovalue.rds from https://github.com/maia-sh/intovalue-data/
intovalue <- rio::import("https://github.com/maia-sh/intovalue-data/blob/main/data/processed/trials.rds?raw=true")

## Apply the IntoValue exclusion criteria
intovalue <- intovalue %>%
    filter(
        iv_completion,
        iv_status,
        iv_interventional,
        has_german_umc_lead,
        ## In case of dupes, exclude IV1 version
        !(is_dupe & iv_version == 1)
    )

# Trials with a journal article have a publication (disregard dissertations and abstracts) %>% 
intovalue <- intovalue %>%
    mutate(has_publication = if_else(publication_type == "journal publication", TRUE, FALSE, missing = FALSE))

iv_all <- intovalue

## Un-nest the cities
iv_umc <- intovalue %>%
    mutate(lead_cities = strsplit(as.character(lead_cities), " ")) %>%
    tidyr::unnest(lead_cities)

## This is the library of transformations
## Note that the `city` column CAN NOT contain spaces
transforms <- read_csv(here("prep", "intovalue-city-transforms.csv"))

## This will apply the transformations
iv_umc <- iv_umc %>%
    left_join(transforms)

## This creates a data folder, if it doesn't exist already
dir_create("data")

## This writes the final CSVs out
iv_all %>%
    write_csv(here("data", "ct-dashboard-intovalue-all.csv"))

iv_umc %>%
    write_csv(here("data", "ct-dashboard-intovalue-umc.csv"))

## Get prospective registration data for ClinicalTrials.gov (only)
prop_reg_ctgov <- read_csv("https://raw.githubusercontent.com/maia-sh/intovalue-data/ctgov-2018/data/ctgov-2018/prospective-reg-ctgov-2018-trials.csv")

prop_reg_ctgov %>%
    mutate(cities = str_replace_all(cities, "TU\ München", "TU-München")) %>%
    mutate(cities = str_replace_all(cities, "LMU\ München", "LMU-München")) %>%
    write_csv(here("data", "prospective-reg-ctgov-2018-trials.csv"))

## Read IV lookup table
lookup_table <- read_csv("https://zenodo.org/record/5141343/files/iv_data_lookup_registries.csv?download=1")
lookup_table %>%
    write_csv(here("data", "iv_data_lookup_registries.csv"))
