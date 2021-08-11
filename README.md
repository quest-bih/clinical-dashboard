# Responsible Metrics Dashboard

Code repo including the code to calculate the underlying metrics as well as the Shiny app to present the results.

Forked with many thanks from https://github.com/quest-bih/dashboard

## Repo overview

Scripts that are directly involved in preparing data for use in the dashboard are in the `prep/` folder. Please indicate what scripts/software/data sources are used to generate the inputs for these in a comment in the code itself.

The file `prep/eutt-history.R` contains instructions for how to generate the EUTT history data file. The file `prep/prep-intovalue.R` contains instructions for how to generate the IntoValue data files. These R scripts write CSVs directly to the `data/` folder.

The Shiny app expects to find the final output data of these scripts in the `data/` folder. These should only include the data that the dashboard Shiny app uses directly to generate plots.

The root folder contains the code that is run to generate the Shiny app, `app.R`.
