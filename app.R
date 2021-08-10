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

## Load data

## Generate this from the EUTT repo using the script in
## prep/eutt-history.R
eutt_date <- "2021-06-16"
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

## Define UI
ui <- tagList(
    tags$head(tags$script(type="text/javascript", src = "code.js")),
    navbarPage(
        "Open science in clinical research", theme = shinytheme("flatly"), id = "navbarTabs",
        start_page,
        all_umcs_page,
        umc_page,
        why_page,
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

    ## Dynamically generate options for UMC drop-down menu

    output$startpage <- renderUI({

        wellPanel(
            br(),
            fluidRow(
                column(
                    8,
                    h1(style = "margin-left:0cm", strong("Dashboard for open science in clinical research"), align = "left"),
                    h4(style = "margin-left:0cm",
                       "This is a proof-of-principle dashboard for Open Science in clinical research at University
                       Medical Centers (UMCs) in Germany. This dashboard is a pilot that is still under development,
                       and should not be used to compare UMCs or inform policy. More metrics may be added in the future."),
                    h4(style = "margin-left:0cm",
                       "The dashboard includes data relating to clinical trials of UMCs in Germany. While the dashboard
                       displays the average across all UMCs, you can also view the data for a given UMC by selecting
                       it in the drop-down menu. Once selected, you will see this UMC's data contextualized to the average
                       of all included UMCs. For the Open Access metrics, the data can be viewed as either 1) the percentage
                       of analyzable publications which display the given metric; or 2) the absolute number of eligible
                       publications which display the given metric (click on the toggle to visualise both options). For
                       each metric, you can find an overview of the methods and limitations by clicking on the relevant
                       symbols. For more detailed information on the methods and underlying datasets used to calculate
                       those metrics, visit the Methods or Datasets pages."),
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
            alignment <- "left"
        } else {
            col_width <- 3
            alignment <- "right"
        }

        ## Value for prereg

        iv_data_unique <- iv_all %>%
            filter(! is.na (start_date))
        
        # Filter for 2017 completion date for the pink descriptor text
        all_numer_prereg <- iv_data_unique %>%
            filter(completion_date >= as.Date("2017-01-01")) %>%
            filter(is_prospective) %>%
            nrow()
        
        # Filter for 2017 completion date for the pink descriptor text
        all_denom_prereg <- iv_data_unique %>%
            filter(completion_date >= as.Date("2017-01-01")) %>%
            nrow()

        if (all_denom_prereg == 0) {
            preregval <- "Not applicable"
            preregvaltext <- "No clinical trials for this metric were captured by this method for this UMC"
        } else {
            preregval <- paste0(round(100*all_numer_prereg/all_denom_prereg), "%")
            preregvaltext <- "of registered clinical trials completed in 2017 were prospectively registered"
        }

        ## Value for TRN
        
        all_numer_trn <- iv_all %>%
            filter(has_iv_trn_abstract == TRUE) %>%
            nrow()
        
        all_denom_trn <- iv_all %>%
            filter(has_pubmed == TRUE) %>%
            nrow()

        ## Value for linkage

        link_num <- iv_all %>%
            filter(has_reg_pub_link == TRUE) %>%
            filter(publication_type == "journal publication") %>%
            nrow()

        link_den <- iv_all %>%
            filter (has_pubmed == TRUE | ! is.na (doi)) %>%
            filter(publication_type == "journal publication") %>%
            nrow()
            
        linkage <- paste0(round(100*link_num/link_den), "%")

        wellPanel(
            style="padding-top: 0px; padding-bottom: 0px;",
            h2(strong("Trial Registration"), align = "left"),
            fluidRow(
                column(
                    col_width,
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
                        lim_text = lim_prereg_tooltip
                    )
                ),
                column(
                    col_width,
                    metric_box(
                        title = "Reporting of Trial Registration Number in publications",
                        value = paste0(round(100*all_numer_trn/all_denom_trn), "%"),
                        value_text = "of clinical trials reported a trial registration number in the abstract",
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
                        value_text = "of clinical trial registry entries link to the journal publication",
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

    ## Start page: Trial reporting
    output$publication_metrics <- renderUI({

        req(input$width)

        if (input$width < 1400) {
            col_width <- 6
            alignment <- "left"
        } else {
            col_width <- 3
            alignment <- "right"
        }
        
        ## Value for summary results
        
        sumres_percent <- eutt_hist %>%
            group_by(date) %>%
            mutate(avg = mean(percent_reported)) %>%
            slice_head() %>%
            ungroup() %>%
            slice_tail() %>%
            select(avg) %>%
            pull() %>%
            format(digits=3)

        n_eutt_records <- eutt_hist %>%
            nrow()

        if (n_eutt_records == 0) {
            sumresval <- "Not applicable"
            sumresvaltext <- "No clinical trials for this metric were captured by this method for this UMC"
        } else {
            sumresval <- paste0(sumres_percent, "%")
            sumresvaltext <- paste("of due clinical trials registered in EUCTR reported summary results as of", eutt_date)
        }

        wellPanel(
            style="padding-top: 0px; padding-bottom: 0px;",
            h2(strong("Trial Reporting"), align = "left"),
            fluidRow(
                column(
                    col_width,
                    metric_box(
                        title = "Summary Results Reporting in EUCTR",
                        value = sumresval,
                        value_text = sumresvaltext,
                        plot = plotlyOutput('plot_clinicaltrials_sumres', height="300px"),
                        info_id = "infoSumRes",
                        info_title = "Summary Results Reporting in EUCTR",
                        info_text = sumres_tooltip,
                        lim_id = "limSumRes",
                        lim_title = "Limitations: Summary Results Reporting in EUCTR",
                        lim_text = lim_sumres_tooltip
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

    ## Start page 2 year reporting toggle
    output$startreport2a <- renderUI({

        iv_data_unique <- iv_all %>%
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
            timpubvaltext <- "of clinical trials registered in ClinicalTrials.gov or DRKS and completed in 2017 reported results within 2 years"
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
            lim_text = lim_timpub_tooltip5
        )
    })

    ## Start page 5 year reporting toggle
    output$startreport5a <-  renderUI({

        iv_data_unique <- iv_all %>%
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
            timpubvaltext5a <- "of clinical trials registered in ClinicalTrials.gov or DRKS and completed in 2015 reported results within 5 years"
        }

        metric_box(
            title = "Reporting within 5 years",
            value = timpubval5a,
            value_text = timpubvaltext5a,
            plot = plotlyOutput('plot_clinicaltrials_timpub_5a', height="300px"),
            info_id = "infoTimPub5",
            info_title = "Publication by 5 years",
            info_text = timpub_tooltip2,
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
            alignment <- "left"
        } else {
            col_width <- 3
            alignment <- "right"
        }

        ## Value for Open Access
            
        all_numer_oa <- iv_all %>%
            filter(
                color == "gold" | color == "green" | color == "hybrid"
                
            ) %>%
            nrow()

        all_denom_oa <- iv_all %>%
            filter(
                ! is.na(color)
                
            ) %>%
            nrow()
        
        closed_with_potential <- iv_all %>%
            filter(
                is_closed_archivable == TRUE
            ) %>%
            nrow()
        
        greenoa_only <- iv_all %>%
            filter(
                color_green_only == "green"
                ) %>%
            nrow()
        
        denom_greenoa <- closed_with_potential + greenoa_only
        
        numer_greenoa <- greenoa_only
        
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
                        value_text = "of publications are Open Access (Gold, Green or Hybrid)",
                        plot = plotlyOutput('plot_opensci_oa', height="300px"),
                        info_id = "infoOpenAccess",
                        info_title = "Open Access",
                        info_text = openaccess_tooltip,
                        lim_id = "limOpenAccess",
                        lim_title = "Limitations: Open Access",
                        lim_text = lim_openaccess_tooltip
                    )
                ),
                column(
                    col_width,
                    metric_box(
                        title = "Realized potential for Green OA",
                        value = paste0(round(100*numer_greenoa/denom_greenoa), "%"),
                        value_text = "of paywalled publications with the potential for green OA have been made available via this route",
                        plot = plotlyOutput('plot_opensci_green_oa', height="300px"),
                        info_id = "infoGreenOA",
                        info_title = "Potential Green Open Access",
                        info_text = greenopenaccess_tooltip,
                        lim_id = "limGreenOA",
                        lim_title = "Limitations: Potential Green Open Access",
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
                alignment <- "left"
            } else {
                col_width <- 3
                alignment <- "right"
            }

            ## Value for prereg

            iv_data_unique <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter(! is.na (start_date))
            
            # Filter for 2017 completion date for the pink descriptor text
            all_numer_prereg <- iv_data_unique %>%
                filter(completion_date >= as.Date("2017-01-01")) %>%
                filter(is_prospective) %>%
                nrow()
            
            # Filter for 2017 completion date for the pink descriptor text
            all_denom_prereg <- iv_data_unique %>%
                filter(completion_date >= as.Date("2017-01-01")) %>%
                nrow()

            if (all_denom_prereg == 0) {
                preregval <- "Not applicable"
                preregvaltext <- "No clinical trials for this metric were captured by this method for this UMC"
            } else {
                preregval <- paste0(round(100*all_numer_prereg/all_denom_prereg), "%")
                preregvaltext <- "of registered clinical trials completed in 2017 were prospectively registered"
            }

            ## Value for TRN

            all_numer_trn <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter(has_iv_trn_abstract == TRUE) %>%
                nrow()
            
            all_denom_trn <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter(has_pubmed == TRUE) %>%
                nrow()

            ## Value for linkage

            link_num <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter(has_reg_pub_link == TRUE) %>%
                filter(publication_type == "journal publication") %>%
                nrow()

            link_den <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter (has_pubmed == TRUE | ! is.na (doi)) %>%
                filter(publication_type == "journal publication") %>%
                nrow()

            linkage <- paste0(round(100*link_num/link_den), "%")

            wellPanel(
                style="padding-top: 0px; padding-bottom: 0px;",
                h2(strong("Trial Registration"), align = "left"),
                fluidRow(
                    column(
                        col_width,
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
                            lim_text = lim_prereg_tooltip
                        )
                    ),
                    column(
                        col_width,
                        metric_box(
                            title = "Reporting of Trial Registration Number in publications",
                            value = paste0(round(100*all_numer_trn/all_denom_trn), "%"),
                            value_text = "of clinical trials reported a trial registration number in the abstract",
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
                            value_text = "of clinical trial registry entries link to the journal publication",
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

    ## One UMC: Trial Reporting
    output$umc_publication_metrics <- renderUI({
        
        if (input$selectUMC != "Select a UMC") {
            ## Nothing will be diplayed if the selector is still on
            ## "Select a UMC"
            
            req(input$width)
            req(input$selectUMC)

            if (input$width < 1400) {
                col_width <- 6
                alignment <- "left"
            } else {
                col_width <- 3
                alignment <- "right"
            }

            ## Value for summary results

            sumres_percent <- eutt_hist %>%
                filter(city == input$selectUMC) %>%
                slice_head() %>%
                select(percent_reported) %>%
                pull()

            n_eutt_records <- eutt_hist %>%
                filter(city == input$selectUMC) %>%
                nrow()
                
            if (n_eutt_records == 0) {
                sumresval <- "Not applicable"
                sumresvaltext <- "No clinical trials for this metric were captured by this method for this UMC"
            } else {
                sumresval <- paste0(sumres_percent, "%")
                sumresvaltext <- paste("of due clinical trials registered in EUCTR reported summary results as of", eutt_date)
            }
            
            wellPanel(
                style="padding-top: 0px; padding-bottom: 0px;",
                h2(strong("Trial Reporting"), align = "left"),
                fluidRow(
                    column(
                        col_width,
                        metric_box(
                            title = "Summary Results Reporting in EUCTR",
                            value = sumresval,
                            value_text = sumresvaltext,
                            plot = plotlyOutput('umc_plot_clinicaltrials_sumres', height="300px"),
                            info_id = "UMCinfoSumRes",
                            info_title = "Summary Results Reporting in EUCTR",
                            info_text = sumres_tooltip,
                            lim_id = "UMClimSumRes",
                            lim_title = "Limitations: Summary Results Reporting in EUCTR",
                            lim_text = lim_sumres_tooltip
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

    ## One UMC page 2 year reporting toggle
    output$report2a <- renderUI({

        iv_data_unique <- iv_umc %>%
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
            timpubvaltext <- "of clinical trials registered in ClinicalTrials.gov or DRKS and completed in 2017 reported results within 2 years"
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

        iv_data_unique <- iv_umc %>%
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
            timpubvaltext <- "of clinical trials registered in ClinicalTrials.gov or DRKS and completed in 2015 reported results within 5 years"
        }
        
        metric_box(
            title = "Reporting within 5 years (timely)",
            value = timpubval,
            value_text = timpubvaltext,
            plot = plotlyOutput('umc_plot_clinicaltrials_timpub_5a', height="300px"),
            info_id = "UMCinfoTimPub5",
            info_title = "Timely Publication (5 years)",
            info_text = timpub_tooltip2,
            lim_id = "UMClimTimPub5",
            lim_title = "Limitations: Timely Publication",
            lim_text = lim_timpub_tooltip2
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
                alignment <- "left"
            } else {
                col_width <- 3
                alignment <- "right"
            }

            ## Value for Open Access

            all_numer_oa <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter(
                    color == "gold" | color == "green" | color == "hybrid"
                    
                ) %>%
                nrow()

            all_denom_oa <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter(
                    ! is.na(color)
                    
                ) %>%
                nrow()

            ##
                
            closed_with_potential <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter(
                    is_closed_archivable == TRUE
                ) %>%
                nrow()
            
            greenoa_only <- iv_umc %>%
                filter(city == input$selectUMC) %>%
                filter(
                    color_green_only == "green"
                ) %>%
                nrow()
            
            denom_greenoa <- closed_with_potential + greenoa_only
            
            numer_greenoa <- greenoa_only

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
                            value_text = "of publications are Open Access (Gold, Green or Hybrid)",
                            plot = plotlyOutput('umc_plot_opensci_oa', height="300px"),
                            info_id = "UMCinfoOpenAccess",
                            info_title = "Open Access",
                            info_text = openaccess_tooltip,
                            lim_id = "UMClimOpenAccess",
                            lim_title = "Limitations: Open Access",
                            lim_text = lim_openaccess_tooltip
                        )
                    ),
                    column(
                        col_width,
                        metric_box(
                            title = "Realized potential for Green OA",
                            value = paste0(round(100*numer_greenoa/denom_greenoa), "%"),
                            value_text = "of paywalled publications with the potential for green OA have been made available via this route",
                            plot = plotlyOutput('umc_plot_opensci_green_oa', height="300px"),
                            info_id = "UMCinfoGreenOA",
                            info_title = "Potential Green Open Access",
                            info_text = greenopenaccess_tooltip,
                            lim_id = "UMClimGreenOA",
                            lim_title = "Limitations: Potential Green Open Access",
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

        ## Value for prereg

        all_numer_prereg <- iv_all %>%
            filter(is_prospective == TRUE) %>%
            nrow()

        all_denom_prereg <- iv_all %>%
            filter(! is.na(start_date)) %>%
            nrow()

        ## Value for All UMC TRN

        all_numer_trn <- iv_all %>%
            filter(has_iv_trn_abstract == TRUE) %>%
            nrow()
        
        all_denom_trn <- iv_all %>%
            filter(has_pubmed == TRUE) %>%
            nrow()

        ## Value for linkage

        all_numer_link <- iv_all %>%
            filter(has_reg_pub_link == TRUE) %>%
            filter(publication_type == "journal publication") %>%
            nrow()

        all_denom_link <- iv_all %>%
            filter(has_pubmed == TRUE | ! is.na (doi)) %>%
            filter(publication_type == "journal publication") %>%
            nrow()

        wellPanel(
            style="padding-top: 0px; padding-bottom: 0px;",
            h2(strong("Trial registration"), align = "left"),
            fluidRow(
                column(
                    12,
                    metric_box(
                        title = "Prospective registration",
                        value = paste0(round(100*all_numer_prereg/all_denom_prereg), "%"),
                        value_text = "of clinical trials were prospectively registered",
                        plot = plotlyOutput('plot_allumc_clinicaltrials_prereg', height="300px"),
                        info_id = "infoALLUMCPreReg",
                        info_title = "Prospective registration (All UMCs)",
                        info_text = allumc_clinicaltrials_prereg_tooltip,
                        lim_id = "limALLUMCPreReg",
                        lim_title = "Limitations: Prospective registration (All UMCs)",
                        lim_text = lim_allumc_clinicaltrials_prereg_tooltip
                    )
                )
            ),
            fluidRow(
                column(
                    12,
                    metric_box(
                        title = "Reporting of Trial Registration Number in publications",
                        value = paste0(round(100*all_numer_trn/all_denom_trn), "%"),
                        value_text = "of clinical trials reported a trial registration number in the abstract",
                        plot = plotlyOutput('plot_allumc_clinicaltrials_trn', height="300px"),
                        info_id = "infoALLUMCTRN",
                        info_title = "TRN reporting (All UMCs)",
                        info_text = allumc_clinicaltrials_trn_tooltip,
                        lim_id = "limALLUMCTRN",
                        lim_title = "Limitations: TRN reporting (All UMCs)",
                        lim_text = lim_allumc_clinicaltrials_trn_tooltip
                    )
                )
            ),
            fluidRow(
                column(
                    12,
                    metric_box(
                        title = "Publication link in registry",
                        value = paste0(round(100*all_numer_link/all_denom_link), "%"),
                        value_text = "of clinical trial registry entries link to the journal publication",
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
                        value_text = paste("of due clinical trials registered in EUCTR reported summary results as of", eutt_date),
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
        
        all_numer_oa <- iv_all %>%
            filter(
                color == "gold" | color == "green" | color == "hybrid"
            ) %>%
            nrow()

        all_denom_oa <- iv_all %>%
            filter(
                ! is.na(color)
                
            ) %>%
            nrow()

        ## Value for Green OA

        closed_with_potential <- iv_all %>%
                filter(is_closed_archivable == TRUE) %>%
                nrow()
            
        greenoa_only <- iv_all %>%
            filter(
                color_green_only == "green"
            ) %>%
            nrow()
        
        denom_greenoa <- closed_with_potential + greenoa_only
        
        numer_greenoa <- greenoa_only
        
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
                        title = "Realized potential for Green OA",
                        value = paste0(round(100*numer_greenoa/denom_greenoa), "%"),
                        value_text = "of paywalled publications with the potential for green OA have been made available via this route",
                        plot = plotlyOutput('plot_allumc_greenoa', height="300px"),
                        info_id = "infoALLUMCGreenOA",
                        info_title = "Green OA (All UMCs)",
                        info_text = allumc_greenoa_tooltip,
                        lim_id = "limALLUMCGreenOA",
                        lim_title = "Limitations: Green OA (All UMCs)",
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
                              "#303A3E", "#2f4858", "#158376", "#007265", 
                              "#DCE3E5", "#634587", "#000000", "#539d66")

    color_palette_bars <- c("#AA1C7D", "#879C9D", "#F1BA50", "#AA493A", "#303A3E", "#007265", "#634587", "#AA1C7D", "#879C9D", "#F1BA50", "#AA493A", "#303A3E", "#007265", "#634587", "#AA1C7D", "#879C9D", "#F1BA50", "#AA493A", "#303A3E", "#007265", "#634587", "#AA1C7D", "#879C9D", "#F1BA50", "#AA493A", "#303A3E", "#007265", "#634587", "#AA1C7D", "#879C9D", "#F1BA50", "#AA493A", "#303A3E", "#007265", "#634587", "#AA1C7D")

                                        # Start page plots #
    
    ## Preregistration plot
    output$plot_clinicaltrials_prereg <- renderPlotly({
        return (plot_clinicaltrials_prereg(iv_all, color_palette))
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
        return (plot_clinicaltrials_sumres(eutt_hist, color_palette))
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
        return (umc_plot_clinicaltrials_prereg(iv_umc, input$selectUMC, color_palette))
    })
    
    ## TRN plot
    output$umc_plot_clinicaltrials_trn <- renderPlotly({
        return (umc_plot_clinicaltrials_trn(iv_umc, input$selectUMC, color_palette))
    })

    ## Linkage plot
    output$umc_plot_linkage <- renderPlotly({
        return (umc_plot_linkage(iv_umc, input$selectUMC, color_palette))
    })
    
    ## Open Access plot
    output$umc_plot_opensci_oa <- renderPlotly({
        return (umc_plot_opensci_oa(iv_umc, input$selectUMC, input$umc_opensci_absnum, color_palette_delwen))
    })
    
    ## Green Open Access plot
    output$umc_plot_opensci_green_oa <- renderPlotly({
        return (umc_plot_opensci_green_oa(iv_umc, input$selectUMC, input$umc_opensci_absnum, color_palette_delwen))
    })
    
    ## Summary results plot
    output$umc_plot_clinicaltrials_sumres <- renderPlotly({
        return (umc_plot_clinicaltrials_sumres(eutt_hist, input$selectUMC, color_palette))
    })
    
    ## Timely Publication plot 2a
    output$umc_plot_clinicaltrials_timpub_2a <- renderPlotly({
        return (umc_plot_clinicaltrials_timpub_2a(iv_umc, input$selectUMC, input$reporttype2a, color_palette))
    })
    
    ## Timely Publication plot 5a
    output$umc_plot_clinicaltrials_timpub_5a <- renderPlotly({
        return (umc_plot_clinicaltrials_timpub_5a(iv_umc, input$selectUMC, input$reporttype5a, color_palette))
    })

                                        # All UMC's page plots #

    ## Preregistration
    output$plot_allumc_clinicaltrials_prereg <- renderPlotly({
        return(plot_allumc_clinicaltrials_prereg(iv_umc, color_palette, color_palette_bars))
    })

    ## TRN
    output$plot_allumc_clinicaltrials_trn <- renderPlotly({
        return(plot_allumc_clinicaltrials_trn(iv_umc, color_palette))
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
    
    output$data_table_eutt_data <- DT::renderDataTable({
        make_datatable(eutt_hist %>% select (!hash))
    })

    output$data_table_iv_data <- DT::renderDataTable({
        make_datatable(iv_umc)
    })
    
}

## Create Shiny object
shinyApp(ui, server)
