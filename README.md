# Responsible Metrics dashboard for clinical trial transparency

**Please note that this dashboard is under active development**

This repository includes the code to generate an institutional dashboard for
clinical trial transparency (Shiny app).

Forked with many thanks from https://github.com/quest-bih/dashboard.

## Repo overview

Scripts that are directly involved in preparing data for use in the
dashboard are in the `prep/` folder. The file `prep/eutt-history.R` contains
instructions for how to generate the history data file from the EU Trials
Tracker (EUTT). The file `prep/prep-intovalue.R` contains instructions for how
to generate the IntoValue data files. These R scripts write CSVs directly to the
`data/` folder.

The Shiny app expects to find the final output data of these scripts in the 
`data/` folder.

The root folder contains the code that is run to generate the Shiny
app, `app.R`.
