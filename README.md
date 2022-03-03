# Responsible Metrics dashboard for clinical research transparency

**Please note that this dashboard is still under active development**

Code repo including the code to calculate the underlying metrics as
well as the Shiny app to present the results.

Forked with many thanks from https://github.com/quest-bih/dashboard

## Repo overview

Files that are directly involved in preparing data for use in the
dashboard are in the `prep/` folder. Please indicate what
scripts/software/data sources are used to generate the inputs for
these in a comment in the code itself.

The Shiny app expects to find the data necessary to generate plots in
the `data/` folder.

The root folder contains the code that is run to generate the Shiny
app, `app.R`.
