## Prospective registration
umc_plot_clinicaltrials_prereg <- function (dataset, umc, color_palette) {

    dataset <- dataset %>%
        filter( ! is.na (start_date) )

    dataset$year <- dataset$completion_date %>%
        format("%Y")

    years <- seq(from=min(dataset$year), to=max(dataset$year))

    plot_data <- tribble(
        ~year, ~umc_percentage, ~all_percentage
    )

    for (current_year in years) {

        numer_for_year <- dataset %>%
            filter(
                city == umc,
                year == current_year,
                is_prospective == TRUE
            ) %>%
            nrow()

        denom_for_year <- dataset %>%
            filter(
                city == umc,
                year == current_year
            ) %>%
            nrow()

        all_numer_for_year <-  dataset %>%
            filter(
                year == current_year,
                is_prospective == TRUE
            ) %>%
            nrow()

        all_denom_for_year <- dataset %>%
            filter(
                year == current_year
            ) %>%
            nrow()

        percentage_for_year <- 100*numer_for_year/denom_for_year

        all_percentage_for_year <- 100*all_numer_for_year/all_denom_for_year
        
        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~year, ~umc_percentage, ~all_percentage,
                    current_year, percentage_for_year, all_percentage_for_year
                )
            )
        
    }

    plot_data %>%
        write_csv(paste0(umc, ".csv"))

    plot_ly(
        plot_data,
        x = ~year,
        y = ~umc_percentage,
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
        add_trace(
            y=~all_percentage,
            name='All',
            marker = list(color = color_palette[2])
        ) %>%
        layout(
            xaxis = list(
                title = '<b>Year</b>',
                dtick = 1
            ),
            yaxis = list(
                title = '<b>Prospective registration (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9],
            legend = list(xanchor= "right")
        )
    
}

## TRN

umc_plot_clinicaltrials_trn <- function (dataset, umc, color_palette) {

    plot_data <- dataset %>%
        filter(has_pubmed == TRUE)
    
    all_numer_abs <- sum(plot_data$has_iv_trn_abstract, na.rm=TRUE)
    abs_denom <- plot_data %>%
        filter(! is.na(has_iv_trn_abstract)) %>%
        nrow()
    all_numer_ft <- sum(plot_data$has_iv_trn_ft_pdf, na.rm=TRUE)
    ft_denom <- plot_data %>%
        filter(! is.na(has_iv_trn_ft_pdf)) %>%
        nrow()

    umc_abs_denom <- plot_data %>%
        filter(city == umc) %>%
        filter(! is.na(has_iv_trn_abstract)) %>%
        nrow()

    umc_numer_abs <- plot_data %>%
        filter(city == umc) %>%
        select(has_iv_trn_abstract) %>%
        filter(has_iv_trn_abstract == TRUE) %>%
        nrow()

    umc_numer_ft <- plot_data %>%
        filter(city == umc) %>%
        select(has_iv_trn_ft_pdf) %>%
        filter(has_iv_trn_ft_pdf == TRUE) %>%
        nrow()

    umc_ft_denom <- plot_data %>%
        filter(city == umc) %>%
        filter(! is.na(has_iv_trn_ft_pdf)) %>%
        nrow()

    plot_data <- tribble(
        ~x_label, ~colour, ~percentage,
        "All", "In abstract", round(100*all_numer_abs/abs_denom),
        "All", "In full text", round(100*all_numer_ft/ft_denom),
        umc, "In abstract", round(100*umc_numer_abs/umc_abs_denom),
        umc, "In full text", round(100*umc_numer_ft/umc_ft_denom)
    )

    plot_data$x_label <- fct_relevel(plot_data$x_label, "All", after= Inf)

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
                title = '<b>TRN reporting (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    
}

# Linkage

umc_plot_linkage <- function (dataset, umc, color_palette) {

    dataset <- dataset %>%
        filter(publication_type == "journal publication") %>%
        filter (has_pubmed == TRUE | ! is.na (doi))
    
    umcdata <- dataset %>%
        filter (city == umc)
    
    plot_data <- tribble(
        ~x_label, ~percentage,
        umc, round(100*mean(umcdata$has_reg_pub_link, na.rm = TRUE)),
        "All", round(100*mean(dataset$has_reg_pub_link, na.rm = TRUE))
    )

    upperlimit <- 100
    ylabel <- "Percentage of publications (%)"

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
umc_plot_clinicaltrials_sumres <- function (dataset, umc, color_palette) {

    dataset <- dataset %>%
        filter (date > Sys.Date()-365*1.5) ## Only look at the last year and a half
    
    if (umc != "All") {

        all_data <- dataset %>%
            group_by(date) %>%
            mutate(avg = mean(percent_reported)) %>%
            slice_head() %>%
            select(date, hash, avg) %>%
            rename(percent_reported = avg) %>%
            mutate(city = "All") %>%
            ungroup()
            
        city_data <- dataset %>%
            filter(city == umc)

        plot_data <- rbind(all_data, city_data)

        plot_ly(
            plot_data,
            x = ~date,
            y = ~percent_reported,
            name = ~city,
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
                    title = '<b>Reported within 1 year (%)</b>',
                    range = c(0, 100)
                ),
                paper_bgcolor = color_palette[9],
                plot_bgcolor = color_palette[9],
                legend = list(xanchor= "right")
            )
        
    } else {

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
                    title = '<b>Reported within 1 year (%)</b>',
                    range = c(0, 100)
                ),
                paper_bgcolor = color_palette[9],
                plot_bgcolor = color_palette[9],
                legend = list(xanchor= "right")
            )
        
    }
    
}

# Timely publication within 2 years
umc_plot_clinicaltrials_timpub_2a <- function (dataset, umc, rt, color_palette) {

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

    dataset$year <- dataset$completion_date %>%
        format("%Y")

    years <- seq(from=min(dataset$year), to=max(dataset$year))

    all_denom <- dataset %>%
        nrow()
    
    all_numer <- dataset %>%
        filter(published_2a) %>%
        nrow()

    plot_data <- tribble(
        ~year, ~umc_percentage, ~all_percentage
    )

    for (current_year in years) {

        umc_numer <-  dataset %>%
            filter(
                city == umc,
                year == current_year,
                published_2a
            ) %>%
            nrow()

        umc_denom <-  dataset %>%
            filter(
                city == umc,
                year == current_year
            ) %>%
            nrow()

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

        umc_percentage <- 100*umc_numer/umc_denom
        all_percentage <- 100*all_numer/all_denom

        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~year, ~umc_percentage, ~all_percentage,
                    current_year, umc_percentage, all_percentage
                )
            )
        
    }

    plot_ly(
        plot_data,
        x = ~year,
        y = ~umc_percentage,
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
        add_trace(
            y=~all_percentage,
            name='All',
            marker = list(color = color_palette[2])
        ) %>%
        layout(
            xaxis = list(
                title = '<b>Completion year</b>',
                dtick = 1
            ),
            yaxis = list(
                title = '<b>Reported within 2 years (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9],
            legend = list(xanchor= "right")
        )
    
}

# Timely publication within 5 years
umc_plot_clinicaltrials_timpub_5a <- function (dataset, umc, rt, color_palette) {

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

    dataset$year <- dataset$completion_date %>%
        format("%Y")

    years <- seq(from=min(dataset$year), to=max(dataset$year))

    all_denom <- dataset %>%
        nrow()
    
    all_numer <- dataset %>%
        filter(published_5a) %>%
        nrow()


    
    plot_data <- tribble(
        ~year, ~umc_percentage, ~all_percentage
    )

    for (current_year in years) {

        umc_numer <-  dataset %>%
            filter(
                city == umc,
                year == current_year,
                published_5a
            ) %>%
            nrow()

        umc_denom <-  dataset %>%
            filter(
                city == umc,
                year == current_year
            ) %>%
            nrow()

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

        umc_percentage <- 100*umc_numer/umc_denom
        all_percentage <- 100*all_numer/all_denom

        if (all_denom > 5) { ## This is because we only have 1
            ## data point in 2013 with 5 years of
            ## follow-up

            plot_data <- plot_data %>%
                bind_rows(
                    tribble(
                        ~year, ~umc_percentage, ~all_percentage,
                        current_year, umc_percentage, all_percentage
                    )
                )
        }
        
    }

    plot_ly(
        plot_data,
        x = ~year,
        y = ~umc_percentage,
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
        add_trace(
            y=~all_percentage,
            name='All',
            marker = list(color = color_palette[2])
        ) %>%
        layout(
            xaxis = list(
                title = '<b>Completion year</b>',
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

umc_plot_opensci_oa <- function (dataset, umc, absnum, color_palette) {

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


    umc_denom <- plot_data %>%
        filter(city == umc) %>%
        nrow()

    umc_gold <- plot_data %>%
        filter(
            color == "gold",
            city == umc
        ) %>%
        nrow()

    umc_green <- plot_data %>%
        filter(
            color == "green",
            city == umc
        ) %>%
        nrow()

    umc_hybrid <- plot_data %>%
        filter(
            color == "hybrid",
            city == umc
        ) %>%
        nrow()

    umc_na <- dataset %>%
        filter(
            is.na(color),
            city == umc
        ) %>%
        nrow()

    umc_closed <- plot_data %>%
        filter(
            color == "closed",
            city == umc
        ) %>%
        nrow()

    umc_bronze <- plot_data %>%
        filter(
            color == "bronze",
            city == umc
        ) %>%
        nrow()

    if (absnum) {

        plot_data <- tribble(
            ~x_label, ~gold,    ~green,    ~hybrid,    ~na,    ~closed,    ~bronze,
            umc,      umc_gold, umc_green, umc_hybrid, umc_na, umc_closed, umc_bronze
        )

        upperlimit <- 1.1*sum(umc_gold, umc_green, umc_hybrid, umc_na, umc_closed, umc_bronze)
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
            "All",    round(100*all_gold/all_denom), round(100*all_green/all_denom), round(100*all_hybrid/all_denom), round(100*all_na/all_denom), round(100*all_closed/all_denom), round(100*all_bronze/all_denom),
            umc,      round(100*umc_gold/umc_denom), round(100*umc_green/umc_denom), round(100*umc_hybrid/umc_denom), round(100*umc_na/umc_denom), round(100*umc_closed/umc_denom), round(100*umc_bronze/umc_denom)
        )

        plot_data$x_label <- fct_relevel(plot_data$x_label, "All", after= Inf)

        upperlimit <- 100
        ylabel <- "Percentage of publications"

        
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

umc_plot_opensci_green_oa <- function (dataset, umc, absnum, color_palette) {

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

    umc_closed_with_potential <- dataset %>%
        filter(
            city == umc,
            is_closed_archivable == TRUE
        ) %>%
        nrow()
    
    umc_greenoa_only <- dataset %>%
        filter(
            city == umc,
            color_green_only == "green"
        ) %>%
        nrow()
    
    umc_denom <- umc_closed_with_potential + umc_greenoa_only
    
    umc_numer <- umc_greenoa_only
    
    umc_can_archive <- umc_closed_with_potential
    
    umc_cant_archive <- dataset %>%
        filter(
            city == umc,
            is_closed_archivable == FALSE
        ) %>%
        nrow()
    
    umc_no_data <- dataset %>%
        filter(
            city == umc,
            color == "bronze" | color == "closed",
            is.na(is_closed_archivable)
        ) %>%
        nrow()
    
    if (absnum) {
        
        plot_data <- tribble(
            ~x_label, ~percentage, ~can_archive,   ~cant_archive,    ~no_data,
            umc,      umc_numer,   umc_can_archive, umc_cant_archive, umc_no_data
        )
        
        upperlimit <- 1.1 * sum(umc_numer, umc_can_archive, umc_cant_archive, umc_no_data)
        ylabel <- "Number of publications"
        
    } else {
        
        plot_data <- tribble(
            ~x_label, ~percentage,
            "All", round(100*all_numer/all_denom),
            umc, round(100*umc_numer/umc_denom)
        )
        
        plot_data$x_label <- fct_relevel(plot_data$x_label, "All", after= Inf)
        
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
