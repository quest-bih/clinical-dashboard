# Prospective registration
plot_clinicaltrials_prereg <- function (dataset, color_palette) {

    umc <- "All"

    dataset <- dataset %>%
        filter( ! is.na (start_date) )

    dataset$year <- dataset$completion_date %>%
        format("%Y")

    years <- seq(from=min(dataset$year), to=max(dataset$year))


    plot_data <- tribble(
        ~year, ~percentage
    )

    for (current_year in years) {

        numer_for_year <- dataset %>%
            filter(
                year == current_year,
                is_prospective
            ) %>%
            nrow()

        denom_for_year <- dataset %>%
            filter(
                year == current_year
            ) %>%
            nrow()

        percentage_for_year <- 100*numer_for_year/denom_for_year
        
        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~year, ~percentage,
                    current_year, percentage_for_year
                )
            )
        
    }
    
    plot_ly(
        plot_data,
        x = ~year,
        y = ~percentage,
        name = umc,
        type = 'scatter',
        mode = 'lines+markers',
        marker = list(
            color = color_palette[3],
            line = list(
                color = 'rgb(0,0,0)',
                width = 1.5
            )
        )
    ) %>%
        layout(
            yaxis = list(
                title = '<b>Percentage of trials (%)</b>',
                range = c(0, 100)
            ),
            xaxis = list(
                title = '<b>Completion year</b>',
                dtick = 1
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9],
            legend = list(xanchor= "right")
        )
}

## TRN

plot_clinicaltrials_trn <- function (dataset, color_palette) {

    umc <- "All"
 
    all_numer_abs <- dataset %>%
        filter(has_iv_trn_abstract == TRUE) %>%
        nrow()
    abs_denom <- dataset %>%
        filter(has_publication,
               publication_type == "journal publication",
               has_pubmed == TRUE) %>%
        nrow()
    
    all_numer_ft <- dataset %>%
        filter(has_iv_trn_ft_pdf == TRUE) %>%
        nrow()
    ft_denom <- dataset %>%
        filter(has_publication,
               publication_type == "journal publication",
               has_ft_pdf == TRUE) %>%
        nrow()
    
    plot_data <- tribble(
        ~x_label, ~colour, ~percentage,
        "All", "In abstract", round(100*all_numer_abs/abs_denom),
        "All", "In full text", round(100*all_numer_ft/ft_denom)
    )

    plot_ly(
        plot_data,
        x = ~x_label,
        color = ~colour,
        y = ~percentage,
        type = 'bar',
        colors = c(
            "#F1BA50",
            "#007265",
            "#634587"
        ),
        marker = list(
            line = list(
                color = 'rgb(0,0,0)',
                width = 1.5
            )
        )
    ) %>%
        layout(
            xaxis = list(
                title = '<b>UMC</b>'
            ),
            yaxis = list(
                title = '<b>Trials with publication (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    
}

## Linkage
plot_linkage <- function (dataset, color_palette) {

    numer <- dataset %>%
        filter(has_reg_pub_link == TRUE) %>%
        filter(publication_type == "journal publication") %>%
        nrow()
    denom <- dataset %>%
        filter(has_publication) %>%
        filter(publication_type == "journal publication") %>%
        filter(has_pubmed == TRUE | ! is.na (doi)) %>%
        nrow()

    plot_data <- tribble(
        ~x_label, ~percentage,
        "All", round(100*numer/denom)
    )

    upperlimit <- 100
    ylabel <- "Trials with publication (%)"

    plot_ly(
        plot_data,
        x = ~x_label,
        y = ~percentage,
        type = 'bar',
        marker = list(
            color = color_palette[3],
            line = list(
                color = 'rgb(0,0,0)',
                width = 1.5
            )
        )
    ) %>%
        layout(
            xaxis = list(
                title = '<b>UMC</b>'
            ),
            yaxis = list(
                title = paste('<b>', ylabel, '</b>'),
                range = c(0, upperlimit)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    
}

                                        # Summary results
plot_clinicaltrials_sumres <- function (dataset, color_palette) {

    dataset <- dataset %>%
        filter (date > Sys.Date()-365*1.5) ## Only look at the last year and a half

    plot_data <- dataset %>%
        group_by(date) %>%
        mutate(avg = mean(percent_reported)) %>%
        slice_head() %>%
        select(date, avg) %>%
        rename(percent_reported = avg) %>%
        mutate(city = "All") %>%
        ungroup()

    plot_ly(
        plot_data,
        x = ~date,
        y = ~percent_reported,
        name = "All",
        type = 'scatter',
        mode = 'lines+markers',
        marker = list(
            color = color_palette[3],
            line = list(
                color = 'rgb(0,0,0)',
                width = 1.5
            )
        )
    ) %>%
        layout(
            xaxis = list(
                title = '<b>Date</b>'
            ),
            yaxis = list(
                title = '<b>Percentage of trials (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9],
            legend = list(xanchor= "right")
        )
    
}

# Timely publication within 2 years
plot_clinicaltrials_timpub_2a <- function (dataset, rt, color_palette) {

    dataset <- dataset %>%
        filter(has_followup_2y == TRUE)

    if (rt != "Summary results or publication") {

        if (rt == "Summary results only") {
            dataset$published_2a <- dataset$is_summary_results_2y
        }
        
        if (rt == "Publication only") {
            dataset$published_2a <- dataset$is_publication_2y
        }
        
    } else {
        dataset$published_2a <- dataset$is_summary_results_2y | dataset$is_publication_2y
    }

    umc <- "All"

    dataset$year <- dataset$completion_date %>%
        format("%Y")

    years <- seq(from=min(dataset$year), to=max(dataset$year))

    all_denom <- dataset %>%
        nrow()
    
    all_numer <- dataset %>%
        filter(published_2a) %>%
        nrow()

    plot_data <- tribble(
        ~year, ~all_percentage
    )

    for (current_year in years) {

        all_numer <-  dataset %>%
            filter(
                year == current_year,
                published_2a
            ) %>%
            nrow()

        all_denom <-  dataset %>%
            filter(
                year == current_year
            ) %>%
            nrow()
        all_percentage <- 100*all_numer/all_denom
        
        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~year, ~all_percentage,
                    current_year, all_percentage
                )
            )
        
    }

    plot_ly(
        plot_data,
        x = ~year,
        y = ~all_percentage,
        name = umc,
        type = 'scatter',
        mode = 'lines+markers',
        marker = list(
            color = color_palette[3],
            line = list(
                color = 'rgb(0,0,0)',
                width = 1.5
            )
        )
    ) %>%
        layout(
            xaxis = list(
                title = '<b>Completion year</b>',
                dtick = 1
            ),
            yaxis = list(
                title = '<b>Percentage of trials (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9],
            legend = list(xanchor= "right")
        )
    
}

# Timely publication within 5 years
plot_clinicaltrials_timpub_5a <- function (dataset, rt, color_palette) {

    dataset <- dataset %>%
        filter(has_followup_5y == TRUE)
    
    if (rt != "Summary results or publication") {

        if (rt == "Summary results only") {
            dataset$published_5a <- dataset$is_summary_results_5y
        }
        
        if (rt == "Publication only") {
            dataset$published_5a <- dataset$is_publication_5y
        }
        
    } else {
        dataset$published_5a <- dataset$is_summary_results_5y | dataset$is_publication_5y
    }

    umc <- "All"

    dataset$year <- dataset$completion_date %>%
        format("%Y")

    years <- seq(from=min(dataset$year), to=max(dataset$year))

    all_denom <- dataset %>%
        nrow()
    
    all_numer <- dataset %>%
        filter(published_5a) %>%
        nrow()

    plot_data <- tribble(
        ~year, ~all_percentage
    )

    for (current_year in years) {

        all_numer <-  dataset %>%
            filter(
                year == current_year,
                published_5a
            ) %>%
            nrow()

        all_denom <-  dataset %>%
            filter(
                year == current_year
            ) %>%
            nrow()
        all_percentage <- 100*all_numer/all_denom

        

        if (all_denom > 5) { ## This is because we only have 1 data
                             ## point in 2013 with 5 years of
                             ## follow-up

            plot_data <- plot_data %>%
                bind_rows(
                    tribble(
                        ~year, ~all_percentage,
                        current_year, all_percentage
                    )
                )
        }
        
    }

    plot_ly(
        plot_data,
        x = ~year,
        y = ~all_percentage,
        name = umc,
        type = 'scatter',
        mode = 'lines+markers',
        marker = list(
            color = color_palette[3],
            line = list(
                color = 'rgb(0,0,0)',
                width = 1.5
            )
        )
    ) %>%
        layout(
            xaxis = list(
                title = '<b>Date</b>',
                dtick = 1
            ),
            yaxis = list(
                title = '<b>Reported within 5 years (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9],
            legend = list(xanchor= "right")
        )
    
}

plot_opensci_oa <- function (dataset, absnum, color_palette) {

    umc <- "All"

    ## Calculate the numerators and the denominator for the
    ## "all" bars

    plot_data <- dataset %>%
        filter(
            has_publication,
            publication_type == "journal publication",
            !is.na(doi)
        )

    all_denom <- plot_data %>%
        nrow()

    all_gold <- plot_data %>%
        filter( color == "gold") %>%
        nrow()

    all_green <- plot_data %>%
        filter( color == "green") %>%
        nrow()

    all_hybrid <- plot_data %>%
        filter( color == "hybrid") %>%
        nrow()

    all_na <- dataset %>%
        filter( is.na(color) ) %>%
        nrow()

    all_closed <- plot_data %>%
        filter( color == "closed") %>%
        nrow()

    all_bronze <- plot_data %>%
        filter( color == "bronze") %>%
        nrow()

    
    if (absnum) {
        
        plot_data <- tribble(
            ~x_label, ~gold,    ~green,    ~hybrid,    ~na,    ~closed,    ~bronze,
            "All",    all_gold, all_green, all_hybrid, all_na, all_closed, all_bronze
        )

        upperlimit <- 1.1*sum(all_gold, all_green, all_hybrid, all_na, all_closed, all_bronze)
        ylabel <- "Number of publications"

        plot_ly(
        plot_data,
        x = ~x_label,
        y = ~gold,
        name = "Gold",
        type = 'bar',
        marker = list(
            color = color_palette[3],
            line = list(
                color = 'rgb(0,0,0)',
                width = 1.5
            )
        )
    ) %>%
        add_trace(
            y = ~green,
            name = "Green",
            marker = list(
                color = color_palette[8],
                line = list(
                    color = 'rgb(0,0,0)',
                    width = 1.5
                )
            )
        ) %>%
        add_trace(
            y = ~hybrid,
            name = "Hybrid",
            marker = list(
                color = color_palette[10],
                line = list(
                    color = 'rgb(0,0,0)',
                    width = 1.5
                )
            )
        ) %>%
        add_trace(
            y = ~bronze,
            name = "Bronze",
            marker = list(
                color = color_palette[4],
                line = list(
                    color = 'rgb(0,0,0)',
                    width = 1.5
                )
            )
        ) %>%
        add_trace(
            y = ~closed,
            name = "Closed",
            marker = list(
                color = color_palette[1],
                line = list(
                    color = 'rgb(0,0,0)',
                    width = 1.5
                )
            )
        ) %>%
        add_trace(
            y = ~na,
            name = "No data",
            marker = list(
                color = color_palette[11],
                line = list(
                    color = 'rgb(0,0,0)',
                    width = 1.5
                )
            )
        ) %>%
        layout(
            barmode = 'stack',
            xaxis = list(
                title = '<b>UMC</b>'
            ),
            yaxis = list(
                title = paste('<b>', ylabel, '</b>'),
                range = c(0, upperlimit)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )

        
    } else {
        
        plot_data <- tribble(
            ~x_label, ~gold,                         ~green,                         ~hybrid,                         ~na,                         ~closed,                         ~bronze,
            "All",    round(100*all_gold/all_denom), round(100*all_green/all_denom), round(100*all_hybrid/all_denom), round(100*all_na/all_denom), round(100*all_closed/all_denom), round(100*all_bronze/all_denom)
        )

        upperlimit <- 100
        ylabel <- "Percentage Open Access (%)"

        plot_ly(
        plot_data,
        x = ~x_label,
        y = ~gold,
        name = "Gold",
        type = 'bar',
        marker = list(
            color = color_palette[3],
            line = list(
                color = 'rgb(0,0,0)',
                width = 1.5
            )
        )
    ) %>%
        add_trace(
            y = ~green,
            name = "Green",
            marker = list(
                color = color_palette[8],
                line = list(
                    color = 'rgb(0,0,0)',
                    width = 1.5
                )
            )
        ) %>%
        add_trace(
            y = ~hybrid,
            name = "Hybrid",
            marker = list(
                color = color_palette[10],
                line = list(
                    color = 'rgb(0,0,0)',
                    width = 1.5
                )
            )
        ) %>%
        layout(
            barmode = 'stack',
            xaxis = list(
                title = '<b>UMC</b>'
            ),
            yaxis = list(
                title = paste('<b>', ylabel, '</b>'),
                range = c(0, upperlimit)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )


    }

        
}

plot_opensci_green_oa <- function (dataset, absnum, color_palette) {

    umc <- "All"

    all_closed_with_potential <- dataset %>%
        filter(
            is_closed_archivable == TRUE
        ) %>%
        nrow()
    
    all_greenoa_only <- dataset %>%
        filter(
            color_green_only == "green"
        ) %>%
        nrow()
    
    all_denom <- all_closed_with_potential + all_greenoa_only
    
    all_numer <- all_greenoa_only
    
    all_can_archive <- all_closed_with_potential
    
    all_cant_archive <- dataset %>%
        filter(
            is_closed_archivable == FALSE
        ) %>%
        nrow()
    
    all_no_data <- dataset %>%
        filter(
            color == "bronze" | color == "closed",
            is.na(is_closed_archivable)
        ) %>%
        nrow()


    if (absnum) {
        
        plot_data <- tribble(
            ~x_label, ~percentage, ~can_archive,   ~cant_archive,    ~no_data,
            "All",    all_numer,   all_can_archive, all_cant_archive, all_no_data
        )
        
        upperlimit <- 1.1 * sum(all_numer, all_can_archive, all_cant_archive, all_no_data)
        ylabel <- "Number of publications"
        
    } else {
        
        plot_data <- tribble(
            ~x_label, ~percentage,
            "All", round(100*all_numer/all_denom)
        )
        
        upperlimit <- 100
        ylabel <- "Percentage of publications"
        
    }
             
    if (absnum) {
        
        plot_ly(
            plot_data,
            x = ~x_label,
            y = ~percentage,
            name = "Archived",
            type = 'bar',
            marker = list(
                color = color_palette[3],
                line = list(
                    color = 'rgb(0,0,0)',
                    width = 1.5
                )
            )
        ) %>%
            add_trace(
                y = ~can_archive,
                name = "Can archive",
                marker = list(
                    color = color_palette[12],
                    line = list(
                        color = 'rgb(0,0,0)',
                        width = 1.5
                    )
                )
            ) %>% 
            add_trace(
                y = ~cant_archive,
                name = "Cannot archive",
                marker = list(
                    color = color_palette[7],
                    line = list(
                        color = 'rgb(0,0,0)',
                        width = 1.5
                    )
                )
            ) %>%
            add_trace(
                y = ~no_data,
                name = "No data",
                marker = list(
                    color = color_palette[6],
                    line = list(
                        color = 'rgb(0,0,0)',
                        width = 1.5
                    )
                )
            ) %>%
            layout(
                barmode = 'stack',
                xaxis = list(
                    title = '<b>UMC</b>'
                ),
                yaxis = list(
                    title = paste('<b>', ylabel, '</b>'),
                    range = c(0, upperlimit)
                ),
                paper_bgcolor = color_palette[9],
                plot_bgcolor = color_palette[9]
            )
        
    } else {
        
        plot_ly(
            plot_data,
            x = ~x_label,
            y = ~percentage,
            type = 'bar',
            marker = list(
                color = color_palette[3],
                line = list(
                    color = 'rgb(0,0,0)',
                    width = 1.5
                )
            )
        ) %>%
            layout(
                xaxis = list(
                    title = '<b>UMC</b>'
                ),
                yaxis = list(
                    title = paste('<b>', ylabel, '</b>'),
                    range = c(0, upperlimit)
                ),
                paper_bgcolor = color_palette[9],
                plot_bgcolor = color_palette[9]
            )
        
    }
    
}
