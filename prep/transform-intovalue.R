library(tidyverse)

## Get intovalue.rds from here:
## https://github.com/maia-sh/intovalue-data/blob/main/data/processed/intovalue.rds
## Save it in the prep/ folder in this repo

intovalue <- read_rds("intovalue.rds")

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
transforms <- read_csv("intovalue-city-transforms.csv")

## This will apply the transformations
iv_umc <- iv_umc %>%
    left_join(transforms)

## This writes the final CSVs out
iv_all %>%
    write_csv("../data/ct-dashboard-intovalue-all.csv")

iv_umc %>%
    write_csv("../data/ct-dashboard-intovalue-umc.csv")
