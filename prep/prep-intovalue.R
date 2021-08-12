library(tidyverse)
library(rio)
library(here)
library(fs)

## Get intovalue.rds from https://github.com/maia-sh/intovalue-data/
intovalue <- rio::import("https://github.com/maia-sh/intovalue-data/blob/main/data/processed/intovalue.rds?raw=true")

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

iv_all <- intovalue

## Un-nest the cities
iv_umc <- intovalue %>%
    mutate(lead_cities = strsplit(as.character(lead_cities), " ")) %>%
    tidyr::unnest(lead_cities)

## This is the library of transformations
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
