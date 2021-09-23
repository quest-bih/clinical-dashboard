# Prospective registration
plot_clinicaltrials_prereg <- function (dataset, iv_dataset, toggled_registry, color_palette) {

    if (toggled_registry == "ClinicalTrials.gov") {
        
        dataset <- dataset %>%
            filter( ! is.na (start_date) )

        dataset$start_year <- dataset$start_date %>%
            format("%Y")

        years <- seq(from=min(dataset$start_year, na.rm=TRUE), to=max(dataset$start_year, na.rm=TRUE))

        plot_data <- tribble(
            ~year, ~percentages
        )

        for (current_year in years) {

            numer_for_year <- dataset %>%
                filter(
                    start_year == current_year,
                    is_prospective
                ) %>%
                nrow()

            denom_for_year <- dataset %>%
                filter(
                    start_year == current_year
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
        
    }

    if (toggled_registry == "DRKS") {

        dataset <- iv_dataset %>%
            filter( ! is.na (start_date) ) %>%
            filter(registry == toggled_registry) %>%
            mutate(start_year = format(start_date, "%Y"))

        years <- seq(from=min(dataset$start_year), to=max(dataset$start_year))

        plot_data <- tribble(
            ~year, ~percentage
        )

        for (current_year in years) {

            numer_for_year <- dataset %>%
                filter(
                    start_year == current_year,
                    is_prospective
                ) %>%
                nrow()

            denom_for_year <- dataset %>%
                filter(
                    start_year == current_year
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
        
    }
        
    plot_ly(
        plot_data,
        x = ~year,
        y = ~percentage,
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
            yaxis = list(
                title = '<b>Percentage of trials (%)</b>',
                range = c(0, 105)
            ),
            xaxis = list(
                title = '<b>Start year</b>',
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
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            has_pubmed == TRUE
        ) %>%
        nrow()
    
    all_numer_ft <- dataset %>%
        filter(has_iv_trn_ft == TRUE) %>%
        nrow()
    ft_denom <- dataset %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            has_ft == TRUE
        ) %>%
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
                range = c(0, 105)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    
}

## Linkage
plot_linkage <- function (dataset, color_palette) {

    dataset <- dataset %>%
        filter(has_publication == TRUE) %>%
        filter(publication_type == "journal publication") %>%
        filter(has_pubmed == TRUE | ! is.na (doi))

    years <- seq(from=min(dataset$completion_year), to=max(dataset$completion_year))

    plot_data <- tribble(
        ~year, ~percentage
    )

    for (current_year in years) {
        
        numer_for_year <- dataset %>%
            filter(has_reg_pub_link == TRUE) %>%
            filter(completion_year == current_year) %>%
            nrow()

        denom_for_year <- dataset %>%
            filter(completion_year == current_year) %>%
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
    
    ylabel <- "Trials with publication (%)"

    plot_ly(
        plot_data,
        x = ~year,
        y = ~percentage,
        name = 'All',
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
                title = '<b>Completion year</b>'
            ),
            yaxis = list(
                title = paste('<b>', ylabel, '</b>'),
                range = c(0, 105)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    
}

## Summary results
plot_clinicaltrials_sumres <- function (eutt_dataset, iv_dataset, toggled_registry, color_palette) {

    if (toggled_registry == "EUCTR") {
        
        dataset <- eutt_dataset %>%
            filter (date > Sys.Date()-365*1.5) ## Only look at the last year and a half

        ## Only take the latest data point per month
        dataset$month <- dataset$date %>%
            format("%Y-%m")

        dataset <- dataset %>%
            group_by(city, month) %>%
            arrange(desc(date)) %>%
            slice_head()

        plot_data <- dataset %>%
            group_by(date) %>%
            mutate(avg = 100*sum(total_reported)/sum(total_due)) %>%
            mutate(mouseover = paste0(sum(total_reported), "/", sum(total_due))) %>%
            slice_head() %>%
            select(date, avg, mouseover) %>%
            rename(percent_reported = avg) %>%
            mutate(city = "All") %>%
            ungroup()
        
    } else { ## The registry is not EUCTR
        
        dataset <- iv_dataset %>%
            filter(
                registry == toggled_registry
            )

        min_year <- dataset$completion_year %>%
            min()

        max_year <- dataset$completion_year %>%
            max()

        plot_data <- tribble(
            ~date, ~percent_reported
        )

        for (currentyear in seq(from=min_year, to=max_year)) {

            currentyear_trials <- dataset %>%
                filter(
                    completion_year <= currentyear
                )

            currentyear_denom <- nrow(currentyear_trials)

            currentyear_numer <- currentyear_trials %>%
                filter(has_summary_results == TRUE) %>%
                nrow()

            plot_data <- plot_data %>%
                bind_rows(
                    tribble(
                        ~date, ~percent_reported, ~mouseover,
                        currentyear, 100*currentyear_numer/currentyear_denom, paste0(currentyear_numer, "/", currentyear_denom)
                    )
                )
            
        }

    }

    plot_ly(
        plot_data,
        x = ~date,
        y = ~percent_reported,
        name = "All",
        text = ~mouseover,
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
                range = c(0, 105)
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

    years <- seq(from=min(dataset$completion_year), to=max(dataset$completion_year))

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
                completion_year == current_year,
                published_2a
            ) %>%
            nrow()

        all_denom <-  dataset %>%
            filter(
                completion_year == current_year
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
                range = c(0, 105)
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

    years <- seq(from=min(dataset$completion_year), to=max(dataset$completion_year))

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
                completion_year == current_year,
                published_5a
            ) %>%
            nrow()

        all_denom <-  dataset %>%
            filter(
                completion_year == current_year
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
                title = '<b>Completion year</b>',
                dtick = 1
            ),
            yaxis = list(
                title = '<b>Percentage of trials (%)</b>',
                range = c(0, 105)
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

    dataset <- dataset %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            !is.na(doi),
            ! is.na (publication_date_unpaywall)
        )

    dataset$oa_year <- dataset$publication_date_unpaywall %>%
        format("%Y")

    if (absnum) {
        
        plot_data <- tribble(
            ~x_label, ~gold,    ~green,    ~hybrid,    ~na,    ~closed,    ~bronze
        )

        upperlimit <- 0

        for (year in unique(dataset$oa_year)) {
            
            gold_num <- dataset %>%
                filter(
                    oa_year == year,
                    color == "gold"
                ) %>%
                nrow()

            green_num <- dataset %>%
                filter(
                    oa_year == year,
                    color == "green"
                ) %>%
                nrow()

            hybrid_num <- dataset %>%
                filter(
                    oa_year == year,
                    color == "hybrid"
                ) %>%
                nrow()

            na_num <- dataset %>%
                filter(
                    oa_year == year,
                    is.na(color)
                ) %>%
                nrow()
            
            closed_num <- dataset %>%
                filter(
                    oa_year == year,
                    color == "closed"
                ) %>%
                nrow()

            bronze_num <- dataset %>%
                filter(
                    oa_year == year,
                    color == "bronze"
                ) %>%
                nrow()
            
            year_denom <- dataset %>%
                filter(
                    oa_year == year
                ) %>%
                nrow()

            if (year_denom > 20) {
                plot_data <- plot_data %>%
                    bind_rows(
                        tribble(
                            ~x_label, ~gold,    ~green,    ~hybrid,    ~na,    ~closed,    ~bronze,
                            year, gold_num, green_num, hybrid_num, na_num, closed_num, bronze_num
                        )
                    )
            }

            year_upperlimit <- 1.1*year_denom
            upperlimit <- max(year_upperlimit, upperlimit)

        }
        
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
            
        # add_trace(
        #     y = ~na,
        #     name = "No data",
        #     marker = list(
        #         color = color_palette[6],
        #         line = list(
        #             color = 'rgb(0,0,0)',
        #             width = 1.5
        #         )
        #     )
        # ) %>%
        layout(
            barmode = 'stack',
            xaxis = list(
                title = '<b>Year of publication</b>'
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
            ~x_label, ~gold, ~green, ~hybrid
        )

        for (year in unique(dataset$oa_year)) {

            gold_num <- dataset %>%
                filter(
                    oa_year == year,
                    color == "gold"
                ) %>%
                nrow()

            green_num <- dataset %>%
                filter(
                    oa_year == year,
                    color == "green"
                ) %>%
                nrow()

            hybrid_num <- dataset %>%
                filter(
                    oa_year == year,
                    color == "hybrid"
                ) %>%
                nrow()
            
            year_denom <- dataset %>%
                filter(
                    oa_year == year
                ) %>%
                nrow()

            if (year_denom > 20) {                
                plot_data <- plot_data %>%
                    bind_rows(
                        tribble(
                            ~x_label, ~gold,                         ~green,                         ~hybrid,
                            year, round(100*gold_num/year_denom), round(100*green_num/year_denom), round(100*hybrid_num/year_denom)
                        )
                    )
            }
        }

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
                title = '<b>Year of publication</b>'
            ),
            yaxis = list(
                title = paste('<b>', ylabel, '</b>'),
                range = c(0, 105)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )


    }

        
}

plot_opensci_green_oa <- function (dataset, absnum, color_palette) {

    umc <- "All"
    
    # Denom for percentage plot
    oa_set <- dataset %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            !is.na(doi),
            is_closed_archivable == TRUE | color_green_only == "green",
            ! is.na (publication_date_unpaywall)
        )

    oa_set$oa_year <- oa_set$publication_date_unpaywall %>%
        format("%Y")
        
    # Denom for absolute number plot
    oa_set_abs <- dataset %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            !is.na(doi),
            ! is.na (publication_date_unpaywall)
        )
    
    oa_set_abs$oa_year <- oa_set_abs$publication_date_unpaywall %>%
        format("%Y")
    
             
    if (absnum) {

        plot_data <- tribble(
            ~year, ~percentage, ~can_archive,   ~cant_archive,    ~no_data
        )

        upperlimit <- 0

        for (year in unique(oa_set_abs$oa_year)) {

            all_archived <- oa_set_abs %>%
                filter(
                    color_green_only == "green",
                    oa_year == year
                ) %>%
                nrow()
            
            all_can_archive <- oa_set_abs %>%
                filter(
                    is_closed_archivable == TRUE,
                    oa_year == year
                ) %>%
                nrow()
            
            all_cant_archive <- oa_set_abs %>%
                filter(
                    is_closed_archivable == FALSE,
                    oa_year == year
                ) %>%
                nrow()
            
            all_no_data <- oa_set_abs %>%
                filter(
                    color == "bronze" | color == "closed",
                    is.na(is_closed_archivable),
                    oa_year == year
                ) %>%
                nrow()

            year_denom <- oa_set_abs %>%
                filter(oa_year == year) %>%
                nrow()

            if (year_denom > 20) {
                
                plot_data <- plot_data %>%
                    bind_rows(
                        tribble(
                            ~year, ~percentage, ~can_archive,   ~cant_archive,    ~no_data,
                            year, all_archived, all_can_archive, all_cant_archive, all_no_data
                        )
                    )

            }

            
            year_upperlimit <- 1.1 * sum(all_archived, all_can_archive, all_cant_archive, all_no_data)
            upperlimit <- max(year_upperlimit, upperlimit)
        }
        
        ylabel <- "Number of publications"
        
        plot_ly(
            plot_data,
            x = ~year,
            y = ~percentage,
            name = "Archived",
            type = 'bar',
            marker = list(
                color = color_palette[8],
                line = list(
                    color = 'rgb(0,0,0)',
                    width = 1.5
                )
            )
        ) %>%
            add_trace(
                y = ~can_archive,
                name = "Could archive",
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
                    color = color_palette[13],
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

        plot_data <- tribble(
            ~year, ~percentage
        )

        for (year in unique(oa_set$oa_year)) {
            
            year_numer <- oa_set %>%
                filter(
                    color_green_only == "green",
                    oa_year == year
                ) %>%
                nrow()

            year_denom <- oa_set %>%
                filter(oa_year == year) %>%
                nrow()

            if (year_denom > 20) {
                plot_data <- plot_data %>%
                    bind_rows(
                        tribble(
                            ~year, ~percentage,
                            year, 100*year_numer/year_denom
                        )
                    )
            }
        }
        
        upperlimit <- 105
        ylabel <- "Percentage of publications (%)"
        
        plot_ly(
            plot_data,
            x = ~year,
            y = ~percentage,
            type = 'bar',
            marker = list(
                color = color_palette[8],
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
