library(plotly)
library(shiny)
library(shinydashboard)
library(tidyverse)
library(ggvis)
library(ggplot2)
library(shinythemes)
library(shinyBS)
library(shinyjs)
library(DT)
library(fs)
library(gtsummary)
library(gt)

## Load data

## Generate this from the EUTT repo using the script in
## prep/eutt-history.R
eutt_date <- "2021-08-18"
eutt_hist <- read_csv(
    paste0("data/", eutt_date, "-eutt-history.csv")
)

## Data from the IntoValue 1-2 data set
## Generate these using the script in
## prep/transform-intovalue.R
iv_all <- read_csv(
    "data/ct-dashboard-intovalue-all.csv"
)
iv_umc <- read_csv(
    "data/ct-dashboard-intovalue-umc.csv"
)

## Data from the prospective registration refresh
pros_reg_data <- read_csv(
    "data/prospective-reg-ctgov-2018-trials.csv"
)

pros_reg_data_umc <- pros_reg_data %>%
    mutate(city = strsplit(as.character(cities), " ")) %>%
    tidyr::unnest(city)

## Load functions
source("ui_elements.R")
source("start_page_plots.R")
source("umc_plots.R")
source("all_umc_plots.R")

## Load pages
source("start_page.R")
source("umc_page.R")
source("all_umcs_page.R")
source("why_page.R")
source("methods_page.R")
source("datasets_page.R")
source("about_rm.R")
source("faq_page.R")
source("trial_characteristics_page.R")

## Define UI
ui <- tagList(
    tags$head(tags$script(type="text/javascript", src = "code.js")),
    navbarPage(
        "Dashboard for clinical research transparency", theme = shinytheme("flatly"), id = "navbarTabs",
        start_page,
        all_umcs_page,
        umc_page,
        why_page,
        trial_characteristics_page,
        methods_page,
        datasets_page,
        faq_page,
        about_rm_page,
        tags$head
        (
            tags$script
            ('
                        var width = 0;
                        $(document).on("shiny:connected", function(e) {
                          width = window.innerWidth;
                          Shiny.onInputChange("width", width);
                        });
                        '
            )
        )
    )
)

## Define server function
server <- function (input, output, session) {

    ## Define button actions

    observeEvent(
        input$buttonUMC, {
            updateTabsetPanel(
                session, "navbarTabs",
                selected = "tabUMC"
            )
        }
    )

    observeEvent(
        input$buttonAllUMCs, {
            updateTabsetPanel(
                session, "navbarTabs",
                selected = "tabAllUMCs"
            )
        }
    )
    
    observeEvent(
        input$buttonMethods, {
            updateTabsetPanel(
                session, "navbarTabs",
                selected = "tabMethods"
            )
        }
    )

    observeEvent(
        input$buttonDatasets, {
            updateTabsetPanel(
                session, "navbarTabs",
                selected = "tabDatasets"
            )
        }
    )

    observeEvent(
        input$link_to_methods, {
            updateTabsetPanel(
                session, "navbarTabs",
                selected = "tabMethods"
            )
        }
    )

    observeEvent(
        input$link_to_methods2, {
            updateTabsetPanel(
                session, "navbarTabs",
                selected = "tabMethods"
            )
        }
    )

    observeEvent(
        input$link_to_why_these_metrics, {
            updateTabsetPanel(
                session, "navbarTabs",
                selected = "tabWhy"
            )
        }
    )

    ## Dynamically generate options for UMC drop-down menu

    output$startpage <- renderUI({

        wellPanel(
            br(),
            fluidRow(
                column(
                    8,
                    h1(style = "margin-left:0cm", strong("Dashboard for clinical research transparency"), align = "left"),
                    h4(style = "margin-left:0cm",
                       "This is a dashboard of clinical research transparency at
                       University Medical Centers (UMCs) in Germany. It displays
                       data relating to clinical trials conducted at UMCs
                       in Germany and completed between 2009 - 2017. Metrics
                       included refer to the registration and reporting of these
                       trials. With the exception of summary results reporting in
                       EUCTR, we focused on trials registered in ClinicalTrials.gov
                       and/or the German Clinical Trials Registry (DRKS). The
                       dashboard was developed as part of a scientific research
                       project with the overall aim to support
                       the adoption of responsible research practices at UMCs.
                       The dashboard is a pilot and continues to be updated.
                       More metrics may be added in the future."),
                    h4(style = "margin-left:0cm",
                       "The \"Start page\" displays the average data across all
                       included UMCs. The \"All UMCs\" page displays the data
                       of all UMCs side-by-side. The \"One UMC\" page allows you
                       to focus on any given UMC by selecting it in the drop-down
                       menu. The data for this UMC is then contextualized to the
                       average of all included UMCs. Besides each plot, you can
                       find an overview of the methods and limitations by clicking
                       on the associated widgets. For more detailed information
                       on the methods and underlying datasets used to calculate
                       the metrics displayed in this dashboard, visit the Methods
                       and Datasets pages. The \"Trial Characteristics\" page
                       provides an overview of the characteristics of trials included
                       in the dashboard.The \"FAQ\" and \"Why these metrics?\"
                       pages provide more general information about this
                       dashboard and our selection of metrics."),
                    h3(style = "margin-left:0cm; color: purple",
                       "More information on the overall aim and methodology can be
                       found in the associated publication [enter DOI]. "),
                    br()
                ),
                column(
                    4,
                    hr(),
                    br(),
                    br(),
                    actionButton(
                        style = "color: white; background-color: #aa1c7d;",
                        'buttonUMC',
                        'See one UMC'
                    ),
                    actionButton(
                        style = "color: white; background-color: #aa1c7d;",
                        'buttonAllUMCs',
                        'See all UMCs'
                    ),
                    actionButton(
                        style = "color: white; background-color: #aa1c7d;",
                        'buttonMethods',
                        'See methods'
                    ),
                    actionButton(
                        style = "color: white; background-color: #aa1c7d;",
                        'buttonDatasets',
                        'See datasets'
                    ),
                    br()
                )
            )
        )
        
    })

                                        # Start page metrics #

    ## Start page: Trial Registration
    output$registry_metrics <- renderUI({

        req(input$width)

        if (input$width < 1400) {
            col_width <- 6
            first_lim_align <- "left"
        } else {
            col_width <- 4
            first_lim_align <- "right"
        }
        
        ## Value for TRN in abstract
        
        all_numer_trn <- iv_all %>%
            filter(has_iv_trn_abstract == TRUE) %>%
            nrow()
        
        all_denom_trn <- iv_all %>%
            filter(
                has_publication == TRUE,
                publication_type == "journal publication",
                has_pubmed == TRUE
            ) %>%
            nrow()

        ## Value for linkage

        link_num <- iv_all %>%
            filter(has_reg_pub_link == TRUE) %>%
            filter(publication_type == "journal publication") %>%
            filter(completion_year == 2017) %>%
            nrow()

        link_den <- iv_all %>%
            filter(has_publication == TRUE) %>%
            filter(publication_type == "journal publication") %>%
            filter(completion_year == 2017) %>%
            filter(has_pubmed == TRUE | ! is.na (doi)) %>%
            nrow()
            
        linkage <- paste0(round(100*link_num/link_den), "%")

        wellPanel(
            style="padding-top: 0px; padding-bottom: 0px;",
            h2(strong("Trial Registration"), align = "left"),
            fluidRow(
                column(
                    col_width,
                    uiOutput("startprereg"),
                    selectInput(
                        "startpreregregistry",
                        strong("Trial registry"),
                        choices = c(
                            "ClinicalTrials.gov",
                            "DRKS"
                        )
                    )
                ),
                column(
                    col_width,
                    metric_box(
                        title = "Reporting of Trial Registration Number in publications",
                        value = paste0(round(100*all_numer_trn/all_denom_trn), "%"),
                        value_text = paste0("of trials with a publication (n=", all_denom_trn, ") reported a trial registration number in the abstract"),
                        plot = plotlyOutput('plot_clinicaltrials_trn', height="300px"),
                        info_id = "infoTRN",
                        info_title = "Reporting of Trial Registration Number in publications",
                        info_text = trn_tooltip,
                        lim_id = "limTRN",
                        lim_title = "Limitations: Reporting of Trial Registration Number in publications",
                        lim_text = lim_trn_tooltip
                    )
                ),
                
                column(
                    col_width,
                    metric_box(
                        title = "Publication link in registry",
                        value = linkage,
                        value_text = paste0("of trials completed in 2017 with a publication (n=", link_den, ") provide a link to this publication in the registry entry"),
                        plot = plotlyOutput('plot_linkage', height="300px"),
                        info_id = "infoLinkage",
                        info_title = "Publication link in registry",
                        info_text = linkage_tooltip,
                        lim_id = "limLinkage",
                        lim_title = "Limitations: Publication link in registry",
                        lim_text = lim_linkage_tooltip
                    )
                )
                
            )
            
        )

        
    })

    ## Start page prospective registration toggle
    output$startprereg <- renderUI({
        
        req(input$width)

        if (input$width < 1400) {
            col_width <- 6
            first_lim_align <- "left"
        } else {
            col_width <- 4
            first_lim_align <- "right"
        }

        if (input$startpreregregistry == "ClinicalTrials.gov") {

            ## Value for prereg

            pr_unique <- pros_reg_data %>%
                filter(! is.na (start_date))

            pr_unique$start_year <- format(pr_unique$start_date, "%Y")

            max_start_year <- max(pr_unique$start_year)
            
                                        # Filter for max start date for the pink descriptor text
            all_numer_prereg <- pr_unique %>%
                filter(start_year == max_start_year) %>%
                filter(is_prospective) %>%
                nrow()
            
                                        # Filter for 2017 completion date for the pink descriptor text
            all_denom_prereg <- pr_unique %>%
                filter(start_year == max_start_year) %>%
                nrow()

            if (all_denom_prereg == 0) {
                preregval <- "Not applicable"
                preregvaltext <- "No clinical trials for this metric were captured by this method for this UMC"
            } else {
                preregval <- paste0(round(100*all_numer_prereg/all_denom_prereg), "%")
                preregvaltext <- paste0("of registered clinical trials started in ", max_start_year, " (n=", all_denom_prereg, ") were prospectively registered")
            }
            
        }

        if (input$startpreregregistry == "DRKS") {

            ## Value for prereg

            iv_data_unique <- iv_all %>%
                filter(! is.na (start_date)) %>%
                filter(registry == input$startpreregregistry) %>%
                mutate(start_year = format(start_date, "%Y"))
            
            ## Filter for 2017 completion date for the pink descriptor text
            all_numer_prereg <- iv_data_unique %>%
                filter(start_year == 2017) %>%
                filter(is_prospective) %>%
                nrow()
            
            ## Filter for 2017 completion date for the pink descriptor text
            all_denom_prereg <- iv_data_unique %>%
                filter(start_year == 2017) %>%
                nrow()

            if (all_denom_prereg == 0) {
                preregval <- "Not applicable"
                preregvaltext <- "No clinical trials for this metric were captured by this method for this UMC"
            } else {
                preregval <- paste0(round(100*all_numer_prereg/all_denom_prereg), "%")
                preregvaltext <- paste0("of registered clinical trials started in 2017 (n=", all_denom_prereg, ") were prospectively registered")
            }
            
        }
        
        metric_box(
            title = "Prospective registration",
            value = preregval,
            value_text = preregvaltext,
            plot = plotlyOutput('plot_clinicaltrials_prereg', height="300px"),
            info_id = "infoPreReg",
            info_title = "Prospective registration",
            info_text = prereg_tooltip,
            lim_id = "limPreReg",
            lim_title = "Limitations: Prospective registration",
            lim_text = lim_prereg_tooltip,
            lim_align = first_lim_align
        )
    })

    ## Start page: Trial reporting
    output$publication_metrics <- renderUI({

        req(input$width)

        if (input$width < 1400) {
            col_width <- 6
            first_lim_align <- "left"
        } else {
            col_width <- 4
            first_lim_align <- "right"
        }
        
        wellPanel(
            style="padding-top: 0px; padding-bottom: 0px;",
            h2(strong("Trial Reporting"), align = "left"),
            fluidRow(
                column(
                    col_width,
                    uiOutput("startsumres"),
                    selectInput(
                        "startsumresregistry",
                        strong("Trial registry"),
                        choices = c(
                            "EUCTR",
                            "ClinicalTrials.gov",
                            "DRKS"
                        )
                    )
                ),
                column(
                    col_width,
                    uiOutput("startreport2a"),
                    selectInput(
                        "startreporttype2a",
                        strong("Reporting type"),
                        choices = c(
                            "Summary results or publication",
                            "Summary results only",
                            "Publication only"
                        )
                    )
                ),
                column(
                    col_width,
                    uiOutput("startreport5a"),
                    selectInput(
                        "startreporttype5a",
                        strong("Reporting type"),
                        choices = c(
                            "Summary results or publication",
                            "Summary results only",
                            "Publication only"
                        )
                    )
                )
                
            )

        )

        
    })

    ## Start page summary results reporting toggle
    output$startsumres <- renderUI({

        req(input$width)

        if (input$width < 1400) {
            col_width <- 6
            first_lim_align <- "left"
        } else {
            col_width <- 4
            first_lim_align <- "right"
        }

        if (input$startsumresregistry == "EUCTR") {
        ## Value for summary results EUCTR
            
            sumres_percent <- eutt_hist %>%
                group_by(date) %>%
                mutate(avg = 100*sum(total_reported)/sum(total_due)) %>%
                slice_head() %>%
                ungroup() %>%
                slice_tail() %>%
                select(avg) %>%
                pull() %>%
                format(digits=2)

            n_eutt_records <- eutt_hist %>%
                nrow()

            sumres_denom <- eutt_hist %>%
                group_by(city) %>%
                arrange(date) %>%
                slice_tail() %>%
                ungroup() %>%
                select(total_due) %>%
                sum()

            
            if (n_eutt_records == 0) {
                sumresval <- "Not applicable"
                sumresvaltext <- "No clinical trials for this metric were captured by this method for this UMC"
            } else {
                sumresval <- paste0(sumres_percent, "%")
                sumresvaltext <- paste0("of clinical trials registered in EUCTR (n=", sumres_denom, ") reported summary results (as of: ", eutt_date, ")")
            }
            
        } else {
            ## Summary results for CT dot gov and DRKS
            
            sumres_numer <- iv_all %>%
                filter(
                    registry == input$startsumresregistry,
                    has_summary_results == TRUE
                ) %>%
                nrow()
            
            sumres_denom <- iv_all %>%
                filter(
                    registry == input$startsumresregistry
                ) %>%
                nrow()

            sumres_percent <- format(100*sumres_numer/sumres_denom, digits=2)

            sumresval <- paste0(sumres_percent, "%")

            sumresvaltext <- paste0("of clinical trials registered in ", input$startsumresregistry, " (n=", sumres_denom, ") reported summary results")
            
        }

        metric_box(
            title = "Summary Results Reporting",
            value = sumresval,
            value_text = sumresvaltext,
            plot = plotlyOutput('plot_clinicaltrials_sumres', height="300px"),
            info_id = "infoSumRes",
            info_title = "Summary Results Reporting",
            info_text = sumres_tooltip,
            lim_id = "limSumRes",
            lim_title = "Limitations: Summary Results Reporting",
            lim_text = lim_sumres_tooltip,
            lim_align = first_lim_align
        )
    })

    ## Start page 2 year reporting toggle
    output$startreport2a <- renderUI({
        
        # Filter for 2017 completion date for pink descriptor text
        iv_data_unique <- iv_all %>%
            filter(completion_year == 2017) %>%
            filter(has_followup_2y == TRUE)

        all_numer_timpub <- iv_data_unique %>%
            filter(is_publication_2y | is_summary_results_2y) %>%
            nrow()

        if (input$startreporttype2a == "Summary results only") {
            all_numer_timpub <- iv_data_unique %>%
                filter(is_summary_results_2y) %>%
                nrow()
        }

        if (input$startreporttype2a == "Publication only") {
            all_numer_timpub <- iv_data_unique %>%
                filter(is_publication_2y) %>%
                
                nrow()
        }
        
        all_denom_timpub <- iv_data_unique %>%
            nrow()

        if (all_denom_timpub == 0) {
            timpubval <- "Not applicable"
            timpubvaltext <- "No clinical trials for this metric were captured by this method for this UMC"
        } else {
                        
            timpubval <- paste0(round(100*all_numer_timpub/all_denom_timpub), "%")
            timpubvaltext <- paste0("of clinical trials completed in 2017 (n=", all_denom_timpub, ") reported results within 2 years")
        }
        
        metric_box(
            title = "Reporting within 2 years (timely)",
            value = timpubval,
            value_text = timpubvaltext,
            plot = plotlyOutput('plot_clinicaltrials_timpub_2a', height="300px"),
            info_id = "infoTimPub2",
            info_title = "Timely Publication (2 years)",
            info_text = timpub_tooltip2,
            lim_id = "limTimPub2",
            lim_title = "Limitations: Timely Publication",
            lim_text = lim_timpub_tooltip2
        )
    })

    ## Start page 5 year reporting toggle
    output$startreport5a <-  renderUI({
        
        # Filter for 2015 completion date for pink descriptor text
        iv_data_unique <- iv_all %>%
            filter(completion_year == 2015) %>%
            filter(has_followup_5y == TRUE)

        all_numer_timpub5a <- iv_data_unique %>%
            filter(is_publication_5y | is_summary_results_5y) %>%
            nrow()

        if (input$startreporttype5a == "Summary results only") {
            all_numer_timpub5a <- iv_data_unique %>%
                filter(is_summary_results_5y) %>%
                nrow()
        }

        if (input$startreporttype5a == "Publication only") {
            all_numer_timpub5a <- iv_data_unique %>%
                filter(is_publication_5y) %>%
                nrow()
        }

        all_denom_timpub5a <- iv_data_unique %>%
            nrow()

        if (all_denom_timpub5a == 0) {
            timpubval5a <- "Not applicable"
            timpubvaltext5a <- "No clinical trials for this metric were captured by this method for this UMC"
        } else {
            timpubval5a <- paste0(round(100*all_numer_timpub5a/all_denom_timpub5a), "%")
            timpubvaltext5a <- paste0("of clinical trials completed in 2015 (n=", all_denom_timpub5a, ") reported results within 5 years")
        }

        metric_box(
            title = "Reporting within 5 years",
            value = timpubval5a,
            value_text = timpubvaltext5a,
            plot = plotlyOutput('plot_clinicaltrials_timpub_5a', height="300px"),
            info_id = "infoTimPub5",
            info_title = "Publication by 5 years",
            info_text = timpub_tooltip5,
            lim_id = "limTimPub5",
            lim_title = "Limitations: Timely Publication",
            lim_text = lim_timpub_tooltip5
        )
        
    })

    ## Start page: Open Access
    output$openscience_metrics <- renderUI({

        req(input$width)

        if (input$width < 1400) {
            col_width <- 6
            first_lim_align <- "left"
        } else {
            col_width <- 6
            first_lim_align <- "right"
        }

        ## Value for Open Access
        
        #Create set for OA percentage plot
        oa_set <- iv_all %>%
            filter(
                has_publication == TRUE,
                publication_type == "journal publication",
                ! is.na(doi),
                ! is.na(publication_date_unpaywall)
            )

        oa_set$oa_year <- oa_set$publication_date_unpaywall %>%
            format("%Y")
        
        all_numer_oa <- oa_set %>%
            filter(
                color == "gold" | color == "green" | color == "hybrid",
                oa_year == "2020"
            ) %>%
            nrow()

        # Keep pubs with NA color for now 
        all_denom_oa <- oa_set %>%
            filter(oa_year == "2020") %>%
            nrow()
        
        #Create set for Green OA percentage plot
        oa_set_green <- iv_all %>%
            filter(
                has_publication == TRUE,
                publication_type == "journal publication",
                ! is.na(doi),
                is_closed_archivable == TRUE | color_green_only == "green",
                ! is.na(publication_date_unpaywall)
            )

        oa_set_green$oa_year <- oa_set_green$publication_date_unpaywall %>%
            format("%Y")

        oa_set_green <- oa_set_green %>%
            filter(oa_year == "2020")
        
        denom_greenoa <- oa_set_green %>%
            nrow()
        
        numer_greenoa <- oa_set_green %>%
            filter(
                color_green_only == "green"
            ) %>%
            nrow()
        
        wellPanel(
            style="padding-top: 0px; padding-bottom: 0px;",
            h2(strong("Open Access"), align = "left"),
            checkboxInput(
                "opensci_absnum",
                strong("Show absolute numbers"),
                value = FALSE
            ),
            fluidRow(
                column(
                    col_width,
                    metric_box(
                        title = "Open Access (OA)",
                        value = paste0(round(100*all_numer_oa/all_denom_oa), "%"),
                        value_text = paste0("of publications from 2020 (n=", all_denom_oa, ") are Open Access (Gold, Green or Hybrid)"),
                        plot = plotlyOutput('plot_opensci_oa', height="300px"),
                        info_id = "infoOpenAccess",
                        info_title = "Open Access",
                        info_text = openaccess_tooltip,
                        lim_id = "limOpenAccess",
                        lim_title = "Limitations: Open Access",
                        lim_text = lim_openaccess_tooltip,
                        lim_align = first_lim_align
                    )
                ),
                column(
                    col_width,
                    metric_box(
                        title = "Realized potential of Green OA",
                        value = paste0(round(100*numer_greenoa/denom_greenoa), "%"),
                        value_text = paste0("of paywalled or bronze publications from 2020 with the potential for green OA (n=", denom_greenoa, ") have been made available via this route"),
                        plot = plotlyOutput('plot_opensci_green_oa', height="300px"),
                        info_id = "infoGreenOA",
                        info_title = "Realized potential of Green OA",
                        info_text = greenopenaccess_tooltip,
                        lim_id = "limGreenOA",
                        lim_title = "Limitations: Realized potential of Green OA",
                        lim_text = lim_greenopenaccess_tooltip
                    )
                )
                
            )
        )

    })
    
                                        # One UMC metrics #
    
    ## One UMC: Trial registration
    output$umc_registry_metrics <- renderUI({

        if (input$selectUMC != "Select a UMC") {
            ## Nothing will be diplayed if the selector is still on
            ## "Select a UMC"
            
            req(input$width)
            req(input$selectUMC)

            if (input$width < 1400) {
                col_width <- 6
                first_lim_align <- "left"
            } else {
                col_width <- 4
                first_lim_align <- "right"
            }

            ## Value for TRN in abstract

            all_numer_trn <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter(has_iv_trn_abstract == TRUE) %>%
                nrow()
            
            all_denom_trn <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter(
                    has_publication == TRUE,
                    publication_type == "journal publication",
                    has_pubmed == TRUE
                ) %>%
                nrow()

            ## Value for linkage

            link_num <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter(has_reg_pub_link == TRUE) %>%
                filter(publication_type == "journal publication") %>%
                filter(completion_year == 2017) %>%
                nrow()

            link_den <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter(has_publication == TRUE) %>%
                filter(publication_type == "journal publication") %>%
                filter (has_pubmed == TRUE | ! is.na (doi)) %>%
                filter(completion_year == 2017) %>%
                nrow()

            linkage <- paste0(round(100*link_num/link_den), "%")

            wellPanel(
                style="padding-top: 0px; padding-bottom: 0px;",
                h2(strong("Trial Registration"), align = "left"),
                fluidRow(
                    column(
                        col_width,
                        uiOutput("oneumcprereg"),
                        selectInput(
                            "oneumcpreregregistry",
                            strong("Trial registry"),
                            choices = c(
                                "ClinicalTrials.gov",
                                "DRKS"
                            )
                        )
                    ),
                    column(
                        col_width,
                        metric_box(
                            title = "Reporting of Trial Registration Number in publications",
                            value = paste0(round(100*all_numer_trn/all_denom_trn), "%"),
                            value_text = paste0("of trials with a publication (n=", all_denom_trn, ") reported a trial registration number in the abstract"),
                            plot = plotlyOutput('umc_plot_clinicaltrials_trn', height="300px"),
                            info_id = "UMCinfoTRN",
                            info_title = "Reporting of Trial Registration Number in publications",
                            info_text = trn_tooltip,
                            lim_id = "UMClimTRN",
                            lim_title = "Limitations: Reporting of Trial Registration Number in publications",
                            lim_text = lim_trn_tooltip
                        )
                    ),
                    column(
                        col_width,
                        metric_box(
                            title = "Publication link in registry",
                            value = linkage,
                            value_text = paste0("of trials completed in 2017 with a publication (n=", link_den, ") provide a link to this publication in the registry entry"),
                            plot = plotlyOutput('umc_plot_linkage', height="300px"),
                            info_id = "UMCinfoLinkage",
                            info_title = "Publication link in registry",
                            info_text = linkage_tooltip,
                            lim_id = "UMClimLinkage",
                            lim_title = "Limitations: Publication link in registry",
                            lim_text = lim_linkage_tooltip
                        )
                    )
                    
                )

            )
            
        }
        
    })

    ## One UMC Prospective Registration Registry Toggle
    output$oneumcprereg <- renderUI({
        
        req(input$width)

        if (input$width < 1400) {
            col_width <- 6
            first_lim_align <- "left"
        } else {
            col_width <- 4
            first_lim_align <- "right"
        }

        if (input$oneumcpreregregistry == "ClinicalTrials.gov") {
            
            ## Value for prereg

            pr_unique <- pros_reg_data_umc %>%
                filter(city == input$selectUMC) %>%
                filter(! is.na (start_date)) %>%
                mutate(start_year = format(start_date, "%Y"))

            max_start_year <- max(pr_unique$start_year)
            
                                        # Filter for 2017 completion date for the pink descriptor text
            all_numer_prereg <- pr_unique %>%
                filter(start_year == max_start_year) %>%
                filter(is_prospective) %>%
                nrow()
            
                                        # Filter for 2017 completion date for the pink descriptor text
            all_denom_prereg <- pr_unique %>%
                filter(start_year == max_start_year) %>%
                nrow()

            if (all_denom_prereg == 0) {
                preregval <- "Not applicable"
                preregvaltext <- "No clinical trials for this metric were captured by this method for this UMC"
            } else {
                preregval <- paste0(round(100*all_numer_prereg/all_denom_prereg), "%")
                preregvaltext <- paste0("of registered clinical trials started in ", max_start_year, " (n=", all_denom_prereg, ") were prospectively registered")
            }

            
        }

        if (input$oneumcpreregregistry == "DRKS") {

            ## Value for prereg

            iv_data_unique <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter(! is.na (start_date)) %>%
                filter(registry == input$oneumcpreregregistry) %>%
                mutate(start_year = format(start_date, "%Y"))
            
            ## Filter for 2017 completion date for the pink descriptor text
            all_numer_prereg <- iv_data_unique %>%
                filter(start_year == 2017) %>%
                filter(is_prospective) %>%
                nrow()
            
            ## Filter for 2017 completion date for the pink descriptor text
            all_denom_prereg <- iv_data_unique %>%
                filter(start_year == 2017) %>%
                nrow()

            if (all_denom_prereg == 0) {
                preregval <- "Not applicable"
                preregvaltext <- "No clinical trials for this metric were captured by this method for this UMC"
            } else {
                preregval <- paste0(round(100*all_numer_prereg/all_denom_prereg), "%")
                preregvaltext <- paste0("of registered clinical trials started in 2017 (n=", all_denom_prereg, ") were prospectively registered")
            }

        }

        metric_box(
            title = "Prospective registration",
            value = preregval,
            value_text = preregvaltext,
            plot = plotlyOutput('umc_plot_clinicaltrials_prereg', height="300px"),
            info_id = "UMCinfoPreReg",
            info_title = "Prospective registration",
            info_text = prereg_tooltip,
            lim_id = "UMClimPreReg",
            lim_title = "Limitations: Prospective registration",
            lim_text = lim_prereg_tooltip,
            lim_align = first_lim_align
        )
        
    })

    ## One UMC: Trial Reporting
    output$umc_publication_metrics <- renderUI({
        
        if (input$selectUMC != "Select a UMC") {
            ## Nothing will be diplayed if the selector is still on
            ## "Select a UMC"
            
            req(input$width)
            req(input$selectUMC)

            if (input$width < 1400) {
                col_width <- 6
                first_lim_align <- "left"
            } else {
                col_width <- 4
                first_lim_align <- "right"
            }

           
            
            wellPanel(
                style="padding-top: 0px; padding-bottom: 0px;",
                h2(strong("Trial Reporting"), align = "left"),
                fluidRow(
                    column(
                        col_width,
                        uiOutput("oneumcsumres"),
                        selectInput(
                            "oneumcsumresregistry",
                            strong("Trial registry"),
                            choices = c(
                                "EUCTR",
                                "ClinicalTrials.gov",
                                "DRKS"
                            )
                        )
                    ),
                    column(
                        col_width,
                        uiOutput("report2a"),
                        selectInput(
                            "reporttype2a",
                            strong("Reporting type"),
                            choices = c(
                                "Summary results or publication",
                                "Summary results only",
                                "Publication only"
                            )
                        )
                    ),
                    column(
                        col_width,
                        uiOutput("report5a"),
                        selectInput(
                            "reporttype5a",
                            strong("Reporting type"),
                            choices = c(
                                "Summary results or publication",
                                "Summary results only",
                                "Publication only"
                            )
                        )
                    )
                    
                )

            )

            
        }
    })

    ## One UMC page summary results reporting toggle
    output$oneumcsumres <- renderUI({
        
        req(input$width)

        if (input$width < 1400) {
            col_width <- 6
            first_lim_align <- "left"
        } else {
            col_width <- 4
            first_lim_align <- "right"
        }

        if (input$oneumcsumresregistry == "EUCTR") {
            ## Value for summary results

            sumres_percent <- eutt_hist %>%
                filter(city == input$selectUMC) %>%
                slice_head() %>%
                select(percent_reported) %>%
                pull()

            n_eutt_records <- eutt_hist %>%
                filter(city == input$selectUMC) %>%
                nrow()

            sumres_denom <- eutt_hist %>%
                filter(city == input$selectUMC) %>%
                slice_head() %>%
                select(total_due) %>%
                pull()

            if (n_eutt_records == 0) {
                sumresval <- "Not applicable"
                sumresvaltext <- "No clinical trials for this metric were captured by this method for this UMC"
            } else {
                sumresval <- paste0(sumres_percent, "%")
                sumresvaltext <- paste0("of due clinical trials registered in EUCTR (n=", sumres_denom, ") reported summary results within 1 year (as of: ", eutt_date, ")")
            }
            
        } else {
            ## Summary results for CT dot gov and DRKS
            
            sumres_numer <- iv_umc %>%
                filter(
                    city == input$selectUMC,
                    registry == input$oneumcsumresregistry,
                    has_summary_results == TRUE
                ) %>%
                nrow()
            
            sumres_denom <- iv_umc %>%
                filter(
                    city == input$selectUMC,
                    registry == input$oneumcsumresregistry
                ) %>%
                nrow()

            sumres_percent <- format(100*sumres_numer/sumres_denom, digits=2)

            sumresval <- paste0(sumres_percent, "%")

            sumresvaltext <- paste0("of clinical trials registered in ", input$oneumcsumresregistry, " (n=", sumres_denom, ") reported summary results")
            
        }


        metric_box(
            title = "Summary Results Reporting",
            value = sumresval,
            value_text = sumresvaltext,
            plot = plotlyOutput('umc_plot_clinicaltrials_sumres', height="300px"),
            info_id = "UMCinfoSumRes",
            info_title = "Summary Results Reporting",
            info_text = sumres_tooltip,
            lim_id = "UMClimSumRes",
            lim_title = "Limitations: Summary Results Reporting",
            lim_text = lim_sumres_tooltip,
            lim_align = first_lim_align
        )
            
    })

    ## One UMC page 2 year reporting toggle
    output$report2a <- renderUI({
        
        # Filter for 2017 completion date for the pink descriptor text
        iv_data_unique <- iv_umc %>%
            filter(completion_year == 2017) %>%
            filter(city == input$selectUMC) %>%
            filter(has_followup_2y == TRUE)

        all_numer_timpub <- iv_data_unique %>%
            filter(is_publication_2y | is_summary_results_2y) %>%
            nrow()

        if (input$reporttype2a == "Summary results only") {
            all_numer_timpub <- iv_data_unique %>%
                filter(is_summary_results_2y) %>%
                nrow()
        }

        if (input$reporttype2a == "Publication only") {
            all_numer_timpub <- iv_data_unique %>%
                filter(is_publication_2y) %>%
                nrow()
        }

        all_denom_timpub <- iv_data_unique %>%
            nrow()

        if (all_denom_timpub == 0) {
            timpubval <- "Not applicable"
            timpubvaltext <- "No clinical trials for this metric were captured by this method for this UMC"
        } else {
            timpubval <- paste0(round(100*all_numer_timpub/all_denom_timpub), "%")
            timpubvaltext <- paste0("of clinical trials completed in 2017 (n=", all_denom_timpub, ") reported results within 2 years")
        }
        
        metric_box(
            title = "Reporting within 2 years (timely)",
            value = timpubval,
            value_text = timpubvaltext,
            plot = plotlyOutput('umc_plot_clinicaltrials_timpub_2a', height="300px"),
            info_id = "UMCinfoTimPub2",
            info_title = "Timely Publication (2 years)",
            info_text = timpub_tooltip2,
            lim_id = "UMClimTimPub2",
            lim_title = "Limitations: Timely Publication",
            lim_text = lim_timpub_tooltip2
        )
    })

    ## One UMC page 5 year reporting toggle
    output$report5a <- renderUI({
        
        # Filter for 2015 completion date for the pink descriptor text
        iv_data_unique <- iv_umc %>%
            filter(completion_year == 2015) %>%
            filter(city == input$selectUMC) %>%
            filter(has_followup_5y == TRUE)
            
        
        all_numer_timpub <- iv_data_unique %>%
            filter(is_publication_5y | is_summary_results_5y) %>%
            nrow()

        if (input$reporttype5a == "Summary results only") {
            all_numer_timpub <- iv_data_unique %>%
                filter(is_summary_results_5y) %>%
                nrow()
        }

        if (input$reporttype5a == "Publication only") {
            all_numer_timpub <- iv_data_unique %>%
                filter(is_publication_5y) %>%
                nrow()
        }

        all_denom_timpub <- iv_data_unique %>%
            nrow()

        if (all_denom_timpub == 0) {
            timpubval <- "Not applicable"
            timpubvaltext <- "No clinical trials for this metric were captured by this method for this UMC"
        } else {
            timpubval <- paste0(round(100*all_numer_timpub/all_denom_timpub), "%")
            timpubvaltext <- paste0("of clinical trials completed in 2015 (n=", all_denom_timpub, ") reported results within 5 years")
        }
        
        metric_box(
            title = "Reporting within 5 years (timely)",
            value = timpubval,
            value_text = timpubvaltext,
            plot = plotlyOutput('umc_plot_clinicaltrials_timpub_5a', height="300px"),
            info_id = "UMCinfoTimPub5",
            info_title = "Timely Publication (5 years)",
            info_text = timpub_tooltip5,
            lim_id = "UMClimTimPub5",
            lim_title = "Limitations: Timely Publication",
            lim_text = lim_timpub_tooltip5
        )
    })

    ## One UMC: Open Access
    output$umc_openscience_metrics <- renderUI({

        if (input$selectUMC != "Select a UMC") {
            ## Nothing will be diplayed if the selector is still on
            ## "Select a UMC"

            req(input$width)
            req(input$selectUMC)

            if (input$width < 1400) {
                col_width <- 6
                first_lim_align <- "left"
            } else {
                col_width <- 6
                first_lim_align <- "right"
            }

            ## Value for Open Access
            
            ## Create set for OA percentage plot
            oa_set <- iv_umc %>%
                filter(
                    has_publication == TRUE,
                    publication_type == "journal publication",
                    ! is.na(doi)
                )

            all_numer_oa <- oa_set %>%
                filter(
                    city == input$selectUMC,
                    color == "gold" | color == "green" | color == "hybrid"
                    ) %>%
                nrow()

            all_denom_oa <- oa_set %>%
                filter(
                    city == input$selectUMC
                    ) %>%
                nrow()

            ## Date range for OA
            min_oa <- oa_set %>%
                select(publication_date) %>%
                arrange(publication_date) %>%
                slice_head() %>%
                pull() %>%
                format("%Y")

            max_oa <- oa_set %>%
                select(publication_date) %>%
                arrange(publication_date) %>%
                slice_tail() %>%
                pull() %>%
                format("%Y")
            
            ## Create set for Green OA percentage plot
            oa_set_green <- iv_umc %>%
                filter(
                    has_publication == TRUE,
                    publication_type == "journal publication",
                    ! is.na(doi),
                    is_closed_archivable == TRUE | color_green_only == "green"
                )
            
            denom_greenoa <- oa_set_green %>%
                filter(
                    city == input$selectUMC
                    ) %>%
                nrow()
            
            numer_greenoa <- oa_set_green %>%
                filter(
                    city == input$selectUMC,
                    color_green_only == "green"
                    ) %>%
                nrow()

            ## Date range for Green OA
            min_oa_green <- oa_set_green %>%
                select(publication_date) %>%
                arrange(publication_date) %>%
                slice_head() %>%
                pull() %>%
                format("%Y")

            max_oa_green <- oa_set_green %>%
                select(publication_date) %>%
                arrange(publication_date) %>%
                slice_tail() %>%
                pull() %>%
                format("%Y")

            wellPanel(
                style="padding-top: 0px; padding-bottom: 0px;",
                h2(strong("Open Access"), align = "left"),
                checkboxInput(
                    "umc_opensci_absnum",
                    strong("Show absolute numbers"),
                    value = FALSE
                ),
                fluidRow(
                    column(
                        col_width,
                        metric_box(
                            title = "Open Access (OA)",
                            value = paste0(round(100*all_numer_oa/all_denom_oa), "%"),
                            value_text = paste0("of publications published between ", min_oa, " and ", max_oa, " (n=", all_denom_oa, ") are Open Access (Gold, Green or Hybrid)"),
                            plot = plotlyOutput('umc_plot_opensci_oa', height="300px"),
                            info_id = "UMCinfoOpenAccess",
                            info_title = "Open Access",
                            info_text = openaccess_tooltip,
                            lim_id = "UMClimOpenAccess",
                            lim_title = "Limitations: Open Access",
                            lim_text = lim_openaccess_tooltip,
                            lim_align = first_lim_align
                        )
                    ),
                    column(
                        col_width,
                        metric_box(
                            title = "Realized potential of Green OA",
                            value = paste0(round(100*numer_greenoa/denom_greenoa), "%"),
                            value_text = paste0("of paywalled or bronze publications published between ", min_oa_green, " and ", max_oa_green, " with the potential for green OA (n=", denom_greenoa, ") have been made available via this route"),
                            plot = plotlyOutput('umc_plot_opensci_green_oa', height="300px"),
                            info_id = "UMCinfoGreenOA",
                            info_title = "Realized potential of Green OA",
                            info_text = greenopenaccess_tooltip,
                            lim_id = "UMClimGreenOA",
                            lim_title = "Limitations: Realized potential of Green OA",
                            lim_text = lim_greenopenaccess_tooltip
                        )
                    )
                    
                )
            )


        }

    })

    

                                        # All UMCs metrics #

    ## All UMCs: Trial registration
    output$allumc_registration <- renderUI({

        ## Value for linkage

        all_numer_link <- iv_all %>%
            filter(has_reg_pub_link == TRUE) %>%
            filter(publication_type == "journal publication") %>%
            nrow()

        all_denom_link <- iv_all %>%
            filter(has_publication == TRUE) %>%
            filter(publication_type == "journal publication") %>%
            filter(has_pubmed == TRUE | ! is.na(doi)) %>%
            nrow()

        wellPanel(
            style="padding-top: 0px; padding-bottom: 0px;",
            h2(strong("Trial registration"), align = "left"),
            fluidRow(
                column(
                    12,
                    uiOutput("prereg_all"),
                    selectInput(
                        "allumc_prereg_registry",
                        strong("Trial registry"),
                        choices = c(
                            "ClinicalTrials.gov",
                            "DRKS"
                        )
                    )
                    
                )
            ),
            fluidRow(
                column(
                    12,
                    uiOutput("trn_in_pubs_all"),
                    selectInput(
                        "allumc_trnpub",
                        strong("Location of reported trial registration number"),
                        choices = c(
                            "In abstract",
                            "In full-text",
                            "In abstract or full-text"
                        )
                    )
                )
            ),
            fluidRow(
                column(
                    12,
                    metric_box(
                        title = "Publication link in registry",
                        value = paste0(round(100*all_numer_link/all_denom_link), "%"),
                        value_text = "of trials with a publication provide a link to this publication in the registry entry",
                        plot = plotlyOutput('plot_allumc_linkage', height="300px"),
                        info_id = "infoALLUMCLinkage",
                        info_title = "Linkage (All UMCs)",
                        info_text = allumc_linkage_tooltip,
                        lim_id = "limALLUMCLinkage",
                        lim_title = "Limitations: Linkage (All UMCs)",
                        lim_text = lim_allumc_linkage_tooltip
                    )
                )
            )
        )
        
    })

    output$prereg_all <- renderUI({

        ## Value for prereg

        if (input$allumc_prereg_registry == "ClinicalTrials.gov") {
            
            all_numer_prereg <- pros_reg_data %>%
                filter(is_prospective == TRUE) %>%
                nrow()

            all_denom_prereg <- pros_reg_data %>%
                filter(! is.na(start_date)) %>%
                nrow()
        
        }

        if (input$allumc_prereg_registry == "DRKS") {
            
            all_numer_prereg <- iv_all %>%
                filter(is_prospective == TRUE) %>%
                filter(registry == "DRKS") %>%
                nrow()

            all_denom_prereg <- iv_all %>%
                filter(! is.na(start_date)) %>%
                filter(registry == "DRKS") %>%
                nrow()
            
        }

        metric_box(
            title = "Prospective registration",
            value = paste0(round(100*all_numer_prereg/all_denom_prereg), "%"),
            value_text = paste("of clinical trials registered on", input$allumc_prereg_registry, "were prospectively registered"),
            plot = plotlyOutput('plot_allumc_clinicaltrials_prereg', height="300px"),
            info_id = "infoALLUMCPreReg",
            info_title = "Prospective registration (All UMCs)",
            info_text = allumc_clinicaltrials_prereg_tooltip,
            lim_id = "limALLUMCPreReg",
            lim_title = "Limitations: Prospective registration (All UMCs)",
            lim_text = lim_allumc_clinicaltrials_prereg_tooltip
        )
    })

    output$trn_in_pubs_all <- renderUI({
        
        ## Value for All UMC TRN in abstract/full-text

        if (input$allumc_trnpub == "In abstract") {

            all_numer_trn <- iv_all %>%
                filter(has_iv_trn_abstract == TRUE) %>%
                nrow()
            
            all_denom_trn <- iv_all %>%
                filter(
                    has_publication == TRUE,
                    publication_type == "journal publication",
                    has_pubmed == TRUE) %>%
                nrow()

            all_trn_value_text <- "of trials with a publication reported a trial registration number in the abstract"

        }

        if (input$allumc_trnpub == "In full-text") {
            
            all_numer_trn <- iv_all %>%
                filter(has_iv_trn_ft == TRUE) %>%
                nrow()

            all_denom_trn <- iv_all %>%
                filter(
                    has_publication == TRUE,
                    publication_type == "journal publication",
                    has_ft,
                    ! is.na(has_iv_trn_ft)
                ) %>%
                nrow()

            all_trn_value_text <- "of trials with a publication reported a trial registration number in the full-text"

        }

        if (input$allumc_trnpub == "In abstract or full-text") {

            all_numer_trn <- iv_all %>%
                filter(
                    has_iv_trn_abstract == TRUE | has_iv_trn_ft == TRUE
                ) %>%
                nrow()

            all_denom_trn <- iv_all %>%
                filter(
                    has_publication == TRUE,
                    publication_type == "journal publication",
                    has_ft | has_pubmed,
                    ! is.na(has_iv_trn_ft) | ! is.na(has_iv_trn_abstract)
                ) %>%
                nrow()

            all_trn_value_text <- "of trials with a publication reported a trial registration number in the abstract or the full-text"
            
        }

        metric_box(
            title = "Reporting of Trial Registration Number in publications",
            value = paste0(round(100*all_numer_trn/all_denom_trn), "%"),
            value_text = all_trn_value_text,
            plot = plotlyOutput('plot_allumc_clinicaltrials_trn', height="300px"),
            info_id = "infoALLUMCTRN",
            info_title = "TRN reporting (All UMCs)",
            info_text = allumc_clinicaltrials_trn_tooltip,
            lim_id = "limALLUMCTRN",
            lim_title = "Limitations: TRN reporting (All UMCs)",
            lim_text = lim_allumc_clinicaltrials_trn_tooltip
        )
    })

    ## All UMCs: Trial reporting
    output$allumc_reporting <- renderUI({

        ## Value for All UMC summary results reporting
           
        sumres_percent <- eutt_hist %>%
            group_by(date) %>%
            mutate(avg = mean(percent_reported)) %>%
            slice_head() %>%
            ungroup() %>%
            slice_tail() %>%
            select(avg) %>%
            pull()

        ## Value for timely pub 2a

        all_numer_timpub <- iv_all %>%
            filter(
                is_publication_2y | is_summary_results_2y,
                has_followup_2y == TRUE
            ) %>%
            nrow()

        all_denom_timpub <- iv_all %>%
            filter(has_followup_2y == TRUE) %>%
            nrow()

        ## Value for timely pub 5a

        all_numer_timpub5a <- iv_all %>%
            filter(
                is_publication_5y | is_summary_results_5y,
                has_followup_5y == TRUE
            ) %>%
            nrow()

        all_denom_timpub5a <- iv_all %>%
            filter(has_followup_5y == TRUE) %>%
            nrow()

        wellPanel(
            style="padding-top: 0px; padding-bottom: 0px;",
            h2(strong("Trial reporting"), align = "left"),
            
            fluidRow(
                column(
                    12,
                    metric_box(
                        title = "Summary Results Reporting in EUCTR",
                        value = paste0(round(sumres_percent), "%"),
                        value_text = paste("of due clinical trials registered in EUCTR reported summary results within 1 year (as of:", eutt_date, ")"),
                        plot = plotlyOutput('plot_allumc_clinicaltrials_sumres', height="300px"),
                        info_id = "infoALLUMCSumRes",
                        info_title = "Summary results reporting in EUCTR (All UMCs)",
                        info_text = allumc_clinicaltrials_sumres_tooltip,
                        lim_id = "limALLUMCSumRes",
                        lim_title = "Limitations: Summary results reporting in EUCTR (All UMCs)",
                        lim_text = lim_allumc_clinicaltrials_sumres_tooltip
                    )
                )
            ),
            fluidRow(
                column(
                    12,
                    metric_box(
                        title = "Timely Publication (2 years)",
                        value = paste0(round(100*all_numer_timpub/all_denom_timpub), "%"),
                        value_text = "of clinical trials published results within 2 years",
                        plot = plotlyOutput('plot_allumc_clinicaltrials_timpub', height="300px"),
                        info_id = "infoALLUMCTimPub",
                        info_title = "Timely Publication (All UMCs)",
                        info_text = allumc_clinicaltrials_timpub_tooltip,
                        lim_id = "limALLUMCTimPub",
                        lim_title = "Limitations: Timely Publication (All UMCs)",
                        lim_text = lim_allumc_clinicaltrials_timpub_tooltip
                    )
                )
            ),
            fluidRow(
                column(
                    12,
                    metric_box(
                        title = "Publication within 5 years",
                        value = paste0(round(100*all_numer_timpub5a/all_denom_timpub5a), "%"),
                        value_text = "of clinical trials published results within 5 years",
                        plot = plotlyOutput('plot_allumc_timpub_5a', height="300px"),
                        info_id = "infoALLUMCTimPub5a",
                        info_title = "Publication within 5 years (All UMCs)",
                        info_text = allumc_clinicaltrials_timpub_tooltip5a,
                        lim_id = "limALLUMCTimPub5a",
                        lim_title = "Limitations: Publication within 5 years (All UMCs)",
                        lim_text = lim_allumc_clinicaltrials_timpub_tooltip5a
                    )
                )
            )
        )
        
    })

    ## All UMCs: Open Access
    output$allumc_openscience <- renderUI({

        ## Value for All UMC Open Access
        
        #Create set for OA percentage plot
        oa_set <- iv_all %>%
            filter(
                has_publication == TRUE,
                publication_type == "journal publication",
                ! is.na(doi)
            )
        
        all_numer_oa <- oa_set %>%
            filter(
                color == "gold" | color == "green" | color == "hybrid"
            ) %>%
            nrow()

        # Keep NA color for now
        all_denom_oa <- oa_set %>%
            nrow()

        #Create set for Green OA percentage plot
        oa_set_green <- iv_all %>%
            filter(
                has_publication == TRUE,
                publication_type == "journal publication",
                ! is.na(doi),
                is_closed_archivable | color_green_only == "green"
            )

        denom_greenoa <- oa_set_green %>%
            nrow()
        
        numer_greenoa <- oa_set_green %>%
            filter(
                color_green_only == "green"
            ) %>%
            nrow()
        
        wellPanel(
            style="padding-top: 0px; padding-bottom: 0px;",
            h2(strong("Open Access"), align = "left"),
            fluidRow(
                column(
                    12,
                    metric_box(
                        title = "Open Access",
                        value = paste0(round(100*all_numer_oa/all_denom_oa), "%"),
                        value_text = "of publications are Open Access (Gold, Green or Hybrid)",
                        plot = plotlyOutput('plot_allumc_openaccess', height="300px"),
                        info_id = "infoALLUMCOpenAccess",
                        info_title = "Open Access (All UMCs)",
                        info_text = allumc_openaccess_tooltip,
                        lim_id = "limALLUMCOpenAccess",
                        lim_title = "Limitations: Open Access (All UMCs)",
                        lim_text = lim_allumc_openaccess_tooltip
                    )
                )
            ),
            fluidRow(
                column(
                    12,
                    metric_box(
                        title = "Realized potential of Green OA",
                        value = paste0(round(100*numer_greenoa/denom_greenoa), "%"),
                        value_text = "of paywalled or bronze publications with the potential for green OA have been made available via this route",
                        plot = plotlyOutput('plot_allumc_greenoa', height="300px"),
                        info_id = "infoALLUMCGreenOA",
                        info_title = "Realized potential of Green OA (All UMCs)",
                        info_text = allumc_greenoa_tooltip,
                        lim_id = "limALLUMCGreenOA",
                        lim_title = "Limitations: Realized potential of Green OA (All UMCs)",
                        lim_text = lim_allumc_greenoa_tooltip
                    )
                )
            )
            
        )
    })


                                        # Color palettes #

    color_palette <- c("#B6B6B6", "#879C9D", "#F1BA50", "#AA493A",
                     "#303A3E", "#007265", "#634587", "#000000",   #363457 #533A71 #011638 #634587
                     "#DCE3E5")
    
    color_palette_delwen <- c("#B6B6B6", "#879C9D", "#F1BA50", "#cf9188",  
                              "#303A3E", "#20303b", "#158376", "#007265", 
                              "#DCE3E5", "#634587", "#000000", "#539d66",
                              "#ab880c")

    color_palette_bars <- c("#AA1C7D", "#879C9D", "#F1BA50", "#AA493A", "#303A3E", "#007265", "#634587", "#AA1C7D", "#879C9D", "#F1BA50", "#AA493A", "#303A3E", "#007265", "#634587", "#AA1C7D", "#879C9D", "#F1BA50", "#AA493A", "#303A3E", "#007265", "#634587", "#AA1C7D", "#879C9D", "#F1BA50", "#AA493A", "#303A3E", "#007265", "#634587", "#AA1C7D", "#879C9D", "#F1BA50", "#AA493A", "#303A3E", "#007265", "#634587", "#AA1C7D")

                                        # Start page plots #
    
    ## Preregistration plot
    output$plot_clinicaltrials_prereg <- renderPlotly({
        return (plot_clinicaltrials_prereg(pros_reg_data, iv_all, input$startpreregregistry, color_palette))
    })
    
    ## TRN plot
    output$plot_clinicaltrials_trn <- renderPlotly({
        return (plot_clinicaltrials_trn(iv_all, color_palette))
    })

    ## Linkage plot
    output$plot_linkage <- renderPlotly({
        return (plot_linkage(iv_all, color_palette))
    })
    
    ## Summary results plot
    output$plot_clinicaltrials_sumres <- renderPlotly({
        return (plot_clinicaltrials_sumres(eutt_hist, iv_all, input$startsumresregistry, color_palette))
    })
    
    ## Timely Publication plot 2a
    output$plot_clinicaltrials_timpub_2a <- renderPlotly({
        return (plot_clinicaltrials_timpub_2a(iv_all, input$startreporttype2a, color_palette))
    })
    
    ## Timely Publication plot 5a
    output$plot_clinicaltrials_timpub_5a <- renderPlotly({
        return (plot_clinicaltrials_timpub_5a(iv_all, input$startreporttype5a, color_palette))
    })

    ## Open Access plot
    output$plot_opensci_oa <- renderPlotly({
        return (plot_opensci_oa(iv_all, input$opensci_absnum, color_palette_delwen))
    })
    
    ## Green Open Access plot
    output$plot_opensci_green_oa <- renderPlotly({
        return (plot_opensci_green_oa(iv_all, input$opensci_absnum, color_palette_delwen))
    })
    
                                        # One UMC page plots #

    ## Preregistration plot
    output$umc_plot_clinicaltrials_prereg <- renderPlotly({
        return (umc_plot_clinicaltrials_prereg(pros_reg_data_umc, pros_reg_data, iv_umc, iv_all, input$oneumcpreregregistry, input$selectUMC, color_palette))
    })
    
    ## TRN plot
    output$umc_plot_clinicaltrials_trn <- renderPlotly({
        return (umc_plot_clinicaltrials_trn(iv_umc, iv_all, input$selectUMC, color_palette))
    })

    ## Linkage plot
    output$umc_plot_linkage <- renderPlotly({
        return (umc_plot_linkage(iv_umc, iv_all, input$selectUMC, color_palette))
    })
    
    ## Open Access plot
    output$umc_plot_opensci_oa <- renderPlotly({
        return (umc_plot_opensci_oa(iv_umc, iv_all, input$selectUMC, input$umc_opensci_absnum, color_palette_delwen))
    })
    
    ## Green Open Access plot
    output$umc_plot_opensci_green_oa <- renderPlotly({
        return (umc_plot_opensci_green_oa(iv_umc, iv_all, input$selectUMC, input$umc_opensci_absnum, color_palette_delwen))
    })
    
    ## Summary results plot
    output$umc_plot_clinicaltrials_sumres <- renderPlotly({
        return (umc_plot_clinicaltrials_sumres(eutt_hist, iv_umc, iv_all, input$oneumcsumresregistry, input$selectUMC, color_palette))
    })
    
    ## Timely Publication plot 2a
    output$umc_plot_clinicaltrials_timpub_2a <- renderPlotly({
        return (umc_plot_clinicaltrials_timpub_2a(iv_umc, iv_all, input$selectUMC, input$reporttype2a, color_palette))
    })
    
    ## Timely Publication plot 5a
    output$umc_plot_clinicaltrials_timpub_5a <- renderPlotly({
        return (umc_plot_clinicaltrials_timpub_5a(iv_umc, iv_all, input$selectUMC, input$reporttype5a, color_palette))
    })

                                        # All UMC's page plots #

    ## Preregistration
    output$plot_allumc_clinicaltrials_prereg <- renderPlotly({
        return(plot_allumc_clinicaltrials_prereg(pros_reg_data_umc, iv_umc, input$allumc_prereg_registry, color_palette, color_palette_bars))
    })

    ## TRN
    output$plot_allumc_clinicaltrials_trn <- renderPlotly({
        return(plot_allumc_clinicaltrials_trn(iv_umc, input$allumc_trnpub, color_palette))
    })

    ## Linkage
    output$plot_allumc_linkage <- renderPlotly({
        return(plot_allumc_linkage(iv_umc, color_palette, color_palette_bars))
    })
    
    ## Summary results
    output$plot_allumc_clinicaltrials_sumres <- renderPlotly({
        return(plot_allumc_clinicaltrials_sumres(eutt_hist, color_palette, color_palette_bars))
    })

    ## Timely publication
    output$plot_allumc_clinicaltrials_timpub <- renderPlotly({
        return(plot_allumc_clinicaltrials_timpub(iv_umc, color_palette, color_palette_bars))
    })

    output$plot_allumc_timpub_5a <- renderPlotly({
        return(plot_allumc_timpub_5a(iv_umc, color_palette, color_palette_bars))
    })

    ## Open Access
    output$plot_allumc_openaccess <- renderPlotly({
        return(plot_allumc_openaccess(iv_umc, color_palette))
    })

    ## Green OA
    output$plot_allumc_greenoa <- renderPlotly({
        return(plot_allumc_greenoa(iv_umc, color_palette, color_palette_bars))
    })

                                        # Data tables #
    
    output$data_table_pros_reg_data <- DT::renderDataTable({
        make_datatable(pros_reg_data)
    })
    
    output$data_table_eutt_data <- DT::renderDataTable({
        make_datatable(eutt_hist %>% select (!hash))
    })

    output$data_table_iv_data <- DT::renderDataTable({
        make_datatable(iv_umc)
    })

                                        # Trial characteristics tables #
    output$trial_characteristics_table <- render_gt(trial_characteristics)
    
    output$pros_reg_trial_characteristics_table <- render_gt(pros_reg_trial_characteristics)
    
}

## Create Shiny object
shinyApp(ui, server)

