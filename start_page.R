start_page <- tabPanel(
    "Start page",
    value = "tabStart",
    ## The following are defined in app.R in the Shiny server object
    uiOutput("startpage"),
    uiOutput("registry_metrics"),
    uiOutput("publication_metrics"),
    uiOutput("openscience_metrics"),
    bsCollapsePanel(strong("Impressum"),
                    impressum_text,
                    style = "default"),
    bsCollapsePanel(strong("Datenschutz"),
                    datenschutz_text,
                    style = "default")
)

