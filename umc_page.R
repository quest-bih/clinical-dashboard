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
                    "This dashboard displays the performance of University Medical
                    Centers (UMCs) in Germany on established registration and
                    reporting practices for clinical research transparency. On
                    this page, you can view the data for a UMC of interest
                    contextualized to that across all included UMCs. Select
                    the UMC of interest from the drop-down menu below. More
                    detailed information on the underlying methods can be found
                    in the methods and limitations widgets next to each plot, and
                    in the Methods page."
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
    uiOutput("umc_openscience_metrics"),
    bsCollapsePanel(strong("Impressum"),
                    impressum_text,
                    style = "default"),
    bsCollapsePanel(strong("Datenschutz"),
                    datenschutz_text,
                    style = "default")
)
