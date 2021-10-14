trial_characteristics <- iv_all %>%

  # Prepare industry sponsor
  mutate(industry_sponsor = ifelse(main_sponsor == "Industry", TRUE, FALSE)) %>%

  # Prepare registration and start year
  mutate(
    # registration_year = lubridate::year(registration_date),
    start_year = lubridate::year(start_date)
  ) %>%

  mutate(across(ends_with("_year"), factor)) %>%

  # Prepare phase
  left_join(phase_lookup, by = "phase") %>%

  # Tidy center size
  # mutate(center_size = str_to_title(center_size)) %>%

  select(
    registry,
    is_randomized,
    is_multicentric,
    industry_sponsor,
    enrollment,
    has_crossreg_eudract,
    # center_size,
    phase_unified,
    intervention_type,

    # TODO: decide which date to present and how
    # registration_date,
    # start_date,
    # completion_date,

    # registration_year,
    start_year,
    completion_year
  ) %>%

  gtsummary::tbl_summary(
    by = registry,
    label = list(
      is_randomized ~ "Randomized",
      is_multicentric ~ "Multicentric trial",
      enrollment ~ "Trial enrollment",
      industry_sponsor ~ "Industry sponsor",
      phase_unified ~ "Phase",
      intervention_type ~ "Intervention Type",
      # center_size ~ "Center Size",

      # Note: EUCTR IDs haven't been manually verified
      has_crossreg_eudract ~ "EUCTR Trial ID in Registration",

      # registration_year ~ "Trial registration year",
      start_year ~ "Trial start year",
      completion_year ~ "Trial completion year"

      # registration_date ~ "Trial registration date",
      # start_date ~ "Trial start date",
      # completion_date ~ "Trial completion date"
    )
  ) %>%

  add_overall() %>%

  # Move stats legend to each line
  add_stat_label() %>%

  modify_caption("**Characteristics of German UMC-conducted trials** A trial was considered randomized if allocation included randomization. Trials considered to be conducted by a German UMC if the UMC is in the `sponsors`, `overall officials`, or `responsible parties` from ClinicalTrials.gov, or any `addresses` from DRKS. 'Unknowns' are not counted in the denominator for percentages.") %>%

  bold_labels() %>%

  # Remove rowname label
    modify_header(label = "") %>%
    as_gt()

# Center size is considered 'large' if it conducted more trials than the median trial number per UMC across all UMCs included in the IntoValue1 or Intovalue2 studies, respectively.

trial_characteristics_page <- tabPanel(
    "Characteristics", value = "tabCharacteristics",
    wellPanel(
        br(),
        fluidRow(
            column(
                12,
                gt_output('trial_characteristics_table')
            )
        )
    )
)
