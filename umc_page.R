## Define the page layout

iv_umc <- read_csv(
    "data/ct-dashboard-intovalue-umc.csv"
)

umc_page <- tabPanel(
    "One UMC", value = "tabUMC",
    wellPanel(
        br(),
        fluidRow(
            column(
                12,
                h1(
                    style = "margin-left: 0",
                    strong("Dashboard for clinical research transparency: Individual UMC data"),
                    align = "left"
                ),
                h4(
                    style = "margin-left: 0",
                    "This dashboard provides an overview of the performance of UMCs
                    in Germany on a set of practices relating to clinical research
                    transparency. Select the UMC of interest from the drop-down
                    menu below. More detailed information on the underlying
                    methods can be found by clicking on the methods and limitations
                    widgets next to each plot, or by consulting the Methods page."
                ),
                h4(style = "margin-left:0cm",
                   "The dashboard was developed as part of a scientific research
                   project with the overall aim to support the adoption of responsible
                   research practices at UMCs. The dashboard is a pilot and continues
                       to be updated. More metrics may be added in the future."),
                br()
            )
        ),
        fluidRow(
            column(
                4,
                br(),
                br(),
                selectInput(
                    "selectUMC",
                    strong("Select a UMC from the drop-down menu"),
                    choices = c(
                        "Select a UMC",
                        iv_umc %>%
                        arrange(city) %>%
                        distinct(city) %>%
                        pull()
                    ),
                    selected = NA
                )
            )
        )
    ),
    uiOutput("umc_registry_metrics"),
    uiOutput("umc_publication_metrics"),
    uiOutput("umc_openscience_metrics")
)
