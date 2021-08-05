library(tidyverse)

## Generate this CSV using the script here:
## https://github.com/maia-sh/intovalue-data/blob/main/R/05_prepare-clinical-dashboard-data.R
iv_umc <- read_csv(
    "../shiny_app/data/ct-dashboard-intovalue-umc.csv"
)

## This is the library of transformations
transforms <- read_csv("intovalue-city-transforms.csv")

## This will apply the transformations
iv_umc <- iv_umc %>%
    left_join(transforms)

## This writes the final CSV out
iv_umc %>%
    write_csv("../shiny_app/data/ct-dashboard-intovalue-umc.csv")
