# Verify assumptions for numerators/denominators for metrics in dashboard

library(tidyverse)
library(here)

# Trial registration in ClinicalTrials.gov ------------------------------------------------------

pros_reg_ctgov <-
  read_csv(here("data", "prospective-reg-ctgov-2018-trials.csv"))

# Create start_year variable

pros_reg_ctgov$start_year <- pros_reg_ctgov$start_date %>%
  format(
    "%Y"
  )

pros_reg_ctgov %>%
  
  filter(!is.na(start_date)) %>%
  
  # dashboard highlights 2018
  filter(start_year == 2018) %>%
  
  summarize(
    denom = n(),
    num = sum(is_prospective),
    prop = num/denom
  )

# Load IV dataset for all other metrics

iv_all <-
  read_csv(here("data", "ct-dashboard-intovalue-all.csv"))

# Create start_year variable

iv_all$start_year <- iv_all$start_date %>%
  format(
    "%Y"
  )

# All publication metrics are limited to trials with journal publication
# Each metric has additional limitations as needed to maximize accuracy
iv_all %>%
  filter(
    has_publication,
    publication_type == "journal publication"
  ) %>%
  nrow()


# Trial registration in DRKS ------------------------------------------------------

# Prospective registration (given start date available in registry)

iv_all %>%
  
  filter(registry == "DRKS") %>%

  filter(!is.na(start_date)) %>%

  # dashboard highlights 2017
  filter(start_year == 2017) %>%

  summarize(
    denom = n(),
    num = sum(is_prospective),
    prop = num/denom
  )

# Trial registration numbers in abstract (given a pubmed record)
iv_all %>%

  filter(
    has_publication,
    publication_type == "journal publication",
    has_pubmed
  ) %>%

  summarize(
    denom = n(),
    num = sum(has_iv_trn_abstract),
    prop = num/denom
  )

# Trial registration numbers in full-text  (given a full-text pdf publication)
iv_all %>%

  filter(
    has_publication,
    publication_type == "journal publication",
    has_ft
  ) %>%

  summarize(
    denom = n(),
    num = sum(has_iv_trn_ft),
    prop = num/denom
  )

# Link to publication in registration (given JOURNAL publication with doi or has_pubmed)
iv_all %>%

  filter(
    has_publication,
    publication_type == "journal publication",
    !is.na(doi) | has_pubmed
  ) %>%
  
  # dashboard highlights 2017
  filter(completion_year == 2017) %>%

  summarize(
    denom = n(),
    num = sum(has_reg_pub_link),
    prop = num/denom
  )


# Timely reporting --------------------------------------------------------

# Reporting within 2 years (given 2 years follow-up)
# Publication or summary results
iv_all %>%

  filter(has_followup_2y_pub & has_followup_2y_sumres) %>%

  # NA indicates no summary results regardless of dates so recode to FALSE
  mutate(
    is_publication_2y = replace_na(is_publication_2y, FALSE),
    is_summary_results_2y = replace_na(is_summary_results_2y, FALSE)
  ) %>%

  # dashboard highlights 2017
  filter(completion_year == 2017) %>%

  summarize(
    denom = n(),
    num = sum(is_publication_2y | is_summary_results_2y),
    prop = num/denom
  )

# Summary results only
iv_all %>%

  filter(has_followup_2y_sumres) %>%

  # NA indicates no summary results regardless of dates so recode to FALSE
  mutate(is_summary_results_2y = replace_na(is_summary_results_2y, FALSE)) %>%

  # dashboard highlights 2017
  filter(completion_year == 2017) %>%

  summarize(
    denom = n(),
    num = sum(is_summary_results_2y),
    prop = num/denom
  )

# Publication-only
iv_all %>%

  filter(has_followup_2y_pub) %>%

  # NA indicates no publication regardless of dates so recode to FALSE
  mutate(is_publication_2y = replace_na(is_publication_2y, FALSE)) %>%

  # dashboard highlights 2017
  filter(completion_year == 2017) %>%

  summarize(
    denom = n(),
    num = sum(is_publication_2y),
    prop = num/denom
  )

# Reporting within 5 years (given 5 years follow-up)
# Publication or summary results
iv_all %>%

  filter(has_followup_5y_pub & has_followup_5y_sumres) %>%

  # NA indicates no summary results regardless of dates so recode to FALSE
  mutate(
    is_publication_5y = replace_na(is_publication_5y, FALSE),
    is_summary_results_5y = replace_na(is_summary_results_5y, FALSE)
  ) %>%

  # dashboard highlights 2015
  filter(completion_year == 2015) %>%

  summarize(
    denom = n(),
    num = sum(is_publication_5y | is_summary_results_5y),
    prop = num/denom
  )

# Summary results only
iv_all %>%

  filter(has_followup_5y_sumres) %>%

  # NA indicates no summary results regardless of dates so recode to FALSE
  mutate(is_summary_results_5y = replace_na(is_summary_results_5y, FALSE)) %>%

  # dashboard highlights 2015
  filter(completion_year == 2017) %>%

  summarize(
    denom = n(),
    num = sum(is_summary_results_5y),
    prop = num/denom
  )

# Publication-only
iv_all %>%

  filter(has_followup_5y_pub) %>%

  # NA indicates no publication regardless of dates so recode to FALSE
  mutate(is_publication_5y = replace_na(is_publication_5y, FALSE)) %>%

  # dashboard highlights 2015
  filter(completion_year == 2015) %>%

  summarize(
    denom = n(),
    num = sum(is_publication_5y),
    prop = num/denom
  )


# Open access -------------------------------------------------------------

# open access (given publication with doi)
iv_all %>%

  filter(
    has_publication,
    publication_type == "journal publication",
    !is.na(publication_date_unpaywall),
    !is.na(doi)
  ) %>%
  
  distinct(doi, .keep_all = TRUE) %>%

  # convert unresolved pubs in unpaywall to false
  #mutate(is_oa = replace_na(is_oa, FALSE)) %>%
  # alternatively, could filter out unresolved publications
  # filter(!is.na(is_oa)) %>%
  
  # dashboard highlights 2020
  filter(publication_date_unpaywall %>% format("%Y") == 2020) %>%

  summarize(
    denom = n(),
    num = sum(is_oa),
    prop = num/denom
  )

# absolute numbers

iv_all %>%
  
  filter(
    has_publication,
    publication_type == "journal publication",
    !is.na(publication_date_unpaywall),
    !is.na(doi)
  ) %>%
  
  distinct(doi, .keep_all = TRUE) %>%
  
  # dashboard highlights 2020
  filter(publication_date_unpaywall %>% format("%Y") == 2020) %>%
  
  count(is_oa, color)

# realized potential for green oa (given publication that is closed and archivable, i.e., EITHER accepted or published version may be archived according to SYP AND publication is closed according to unpaywall, OR accessible via green oa)

iv_all %>%

  filter(
    has_publication,
    publication_type == "journal publication",
    !is.na(doi),
    is_closed_archivable | color_green_only == "green"
  ) %>%

  # dashboard highlights 2020
  filter(publication_date_unpaywall %>% format("%Y") == 2020) %>%

  summarize(
    denom = n(),
    num = sum(color_green_only == "green"),
    prop = num/denom
  )

# absolute numbers
iv_all %>%

  filter(
    has_publication,
    publication_type == "journal publication",
    !is.na(doi),
  ) %>%
  
  filter(publication_date_unpaywall %>% format("%Y") == 2020) %>%

  summarise(
    archived = sum(color_green_only == "green", na.rm = TRUE),
    closed_can_archive = sum(is_closed_archivable, na.rm = TRUE),
    closed_cant_archive = sum(!is_closed_archivable, na.rm = TRUE),
    closed_no_data = sum(color %in% c("bronze", "closed") & is.na(is_closed_archivable))
  )
