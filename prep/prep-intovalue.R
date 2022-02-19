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
    mutate(city = strsplit(as.character(lead_cities), " ")) %>%
    tidyr::unnest(city)

## This creates a data folder, if it doesn't exist already
dir_create("data")

## This writes the final CSVs out
iv_all %>%
    write_csv(here("data", "ct-dashboard-intovalue-all.csv"))

iv_umc %>%
    write_csv(here("data", "ct-dashboard-intovalue-umc.csv"))

## Get prospective registration data for ClinicalTrials.gov (only)
prop_reg_ctgov <- read_csv("https://github.com/maia-sh/intovalue-data/blob/main/data/ctgov-2018/prospective-reg-ctgov-2018-trials.csv?raw=true")

# Apply exclusion criteria
prop_reg_ctgov <- prop_reg_ctgov %>%
    filter(start_2006_2018 & iv_interventional & iv_status)

## This writes the final CSV out
prop_reg_ctgov %>%
    write_csv(here("data", "prospective-reg-ctgov-2018-trials.csv"))

## Read IV lookup table
lookup_table <- read_csv("https://zenodo.org/record/5141343/files/iv_data_lookup_registries.csv?download=1")
lookup_table %>%
    write_csv(here("data", "iv_data_lookup_registries.csv"))
