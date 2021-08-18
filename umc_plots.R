## Prospective registration
umc_plot_clinicaltrials_prereg <- function (dataset, dataset_all, umc, color_palette) {

    dataset <- dataset %>%
        filter( ! is.na (start_date) )

    dataset_all <- dataset %>%
        filter( ! is.na (start_date) )

    dataset$year <- dataset$completion_date %>%
        format("%Y")

    dataset_all$year <- dataset_all$completion_date %>%
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

        all_numer_for_year <-  dataset_all %>%
            filter(
                year == current_year,
                is_prospective == TRUE
            ) %>%
            nrow()

        all_denom_for_year <- dataset_all %>%
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
                title = '<b>Percentage of trials (%)</b>',
                range = c(0, 105)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9],
            legend = list(xanchor= "left")
        )
    
}

## TRN

umc_plot_clinicaltrials_trn <- function (dataset, dataset_all, umc, color_palette) {

    plot_data_abs <- dataset %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            has_pubmed == TRUE
        )
    
    plot_data_abs_all <- dataset_all %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            has_pubmed == TRUE
        )
    
    plot_data_ft <- dataset %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            has_ft_pdf == TRUE
        )
    
    plot_data_ft_all <- dataset_all %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            has_ft_pdf == TRUE
        )
    
    all_numer_abs <- sum(plot_data_abs_all$has_iv_trn_abstract, na.rm=TRUE)
    abs_denom <- plot_data_abs_all %>%
        filter(! is.na(has_iv_trn_abstract)) %>%
        nrow()
    
    all_numer_ft <- sum(plot_data_ft_all$has_iv_trn_ft_pdf, na.rm=TRUE)
    ft_denom <- plot_data_ft_all %>%
        filter(! is.na(has_iv_trn_ft_pdf)) %>%
        nrow()

    umc_abs_denom <- plot_data_abs %>%
        filter(city == umc) %>%
        filter(! is.na(has_iv_trn_abstract)) %>%
        nrow()

    umc_numer_abs <- plot_data_abs %>%
        filter(city == umc) %>%
        select(has_iv_trn_abstract) %>%
        filter(has_iv_trn_abstract == TRUE) %>%
        nrow()

    umc_numer_ft <- plot_data_ft %>%
        filter(city == umc) %>%
        select(has_iv_trn_ft_pdf) %>%
        filter(has_iv_trn_ft_pdf == TRUE) %>%
        nrow()

    umc_ft_denom <- plot_data_ft %>%
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
                title = '<b>Trials with publication (%)</b>',
                range = c(0, 105)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    
}

# Linkage

umc_plot_linkage <- function (dataset, dataset_all, umc, color_palette) {

    dataset <- dataset %>%
        filter(has_publication == TRUE) %>%
        filter(publication_type == "journal publication") %>%
        filter(has_pubmed == TRUE | ! is.na (doi))

    dataset$year <- dataset$completion_date %>%
        format("%Y")
    
    dataset_all <- dataset_all %>%
        filter(has_publication == TRUE) %>%
        filter(publication_type == "journal publication") %>%
        filter(has_pubmed == TRUE | ! is.na (doi))
    
    dataset_all$year <- dataset_all$completion_date %>%
        format("%Y")
    
    years <- seq(from=min(dataset_all$year), to=max(dataset_all$year))
    
    umcdata <- dataset %>%
        filter (city == umc)
    
    plot_data <- tribble(
        ~label, ~year, ~percentage
    )

    for (current_year in years) {

        umc_numer <- umcdata %>%
            filter(has_reg_pub_link == TRUE) %>%
            filter(year == current_year) %>%
            nrow()

        umc_denom <- umcdata %>%
            filter(year == current_year) %>%
            nrow()

        all_numer <- dataset_all %>%
            filter(has_reg_pub_link == TRUE) %>%
            filter(year == current_year) %>%
            nrow()

        all_denom <- dataset_all %>%
            filter(year == current_year) %>%
            nrow()

        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~label, ~year, ~percentage,
                    "All", current_year, 100*all_numer/all_denom,
                    umc, current_year, 100*umc_numer/umc_denom
                )
            )
        
    }

    ylabel <- "Trials with publication (%)"

     plot_ly(
        plot_data,
        name = ~label,
        x = ~year,
        y = ~percentage,
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
umc_plot_clinicaltrials_sumres <- function (dataset, umc, color_palette) {

    dataset <- dataset %>%
        filter (date > Sys.Date()-365*1.5) ## Only look at the last year and a half

    ## Only take the latest data point per month
    dataset$month <- dataset$date %>%
        format("%Y-%m")

    dataset <- dataset %>%
        group_by(city, month) %>%
        arrange(desc(date)) %>%
        slice_head() %>%
        ungroup()
    
    all_data <- dataset %>%
        group_by(date) %>%
        mutate(avg = 100*sum(total_reported)/sum(total_due)) %>%
        slice_head() %>%
        select(date, hash, avg, month, total_due, total_reported) %>%
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
                title = '<b>Percentage of trials (%)</b>',
                range = c(0, 105)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9],
            legend = list(xanchor= "left")
        )
    
}

# Timely publication within 2 years
umc_plot_clinicaltrials_timpub_2a <- function (dataset, dataset_all, umc, rt, color_palette) {

    dataset <- dataset %>%
        filter(has_followup_2y == TRUE)
    
    dataset_all <- dataset_all %>%
        filter(has_followup_2y == TRUE)

    if (rt != "Summary results or publication") {

        if (rt == "Summary results only") {
            dataset$published_2a <- dataset$is_summary_results_2y
            dataset_all$published_2a <- dataset_all$is_summary_results_2y
        }
        
        if (rt == "Publication only") {
            dataset$published_2a <- dataset$is_publication_2y
            dataset_all$published_2a <- dataset_all$is_publication_2y
        }
        
    } else {
        dataset$published_2a <- dataset$is_summary_results_2y | dataset$is_publication_2y
        dataset_all$published_2a <- dataset_all$is_summary_results_2y | dataset_all$is_publication_2y
    }

    dataset$year <- dataset$completion_date %>%
        format("%Y")

    dataset_all$year <- dataset_all$completion_date %>%
        format("%Y")

    years <- seq(from=min(dataset$year), to=max(dataset$year))

    all_denom <- dataset_all %>%
        nrow()
    
    all_numer <- dataset_all %>%
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

        all_numer <-  dataset_all %>%
            filter(
                year == current_year,
                published_2a
            ) %>%
            nrow()

        all_denom <-  dataset_all %>%
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
                title = '<b>Percentage of trials (%)</b>',
                range = c(0, 105)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9],
            legend = list(xanchor= "left")
        )
    
}

# Timely publication within 5 years
umc_plot_clinicaltrials_timpub_5a <- function (dataset, dataset_all, umc, rt, color_palette) {

    dataset <- dataset %>%
        filter(has_followup_5y == TRUE)
    
    dataset_all <- dataset_all %>%
        filter(has_followup_5y == TRUE)

    if (rt != "Summary results or publication") {

        if (rt == "Summary results only") {
            dataset$published_5a <- dataset$is_summary_results_5y
            dataset_all$published_5a <- dataset_all$is_summary_results_5y
        }
        
        if (rt == "Publication only") {
            dataset$published_5a <- dataset$is_publication_5y
            dataset_all$published_5a <- dataset_all$is_publication_5y
        }
        
    } else {
        dataset$published_5a <- dataset$is_summary_results_5y | dataset$is_publication_5y
        dataset_all$published_5a <- dataset_all$is_summary_results_5y | dataset_all$is_publication_5y
    }

    dataset$year <- dataset$completion_date %>%
        format("%Y")

    dataset_all$year <- dataset_all$completion_date %>%
        format("%Y")

    years <- seq(from=min(dataset$year), to=max(dataset$year))

    all_denom <- dataset_all %>%
        nrow()
    
    all_numer <- dataset_all %>%
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

        all_numer <-  dataset_all %>%
            filter(
                year == current_year,
                published_5a
            ) %>%
            nrow()

        all_denom <-  dataset_all %>%
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
                title = '<b>Percentage of trials (%)</b>',
                range = c(0, 105)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9],
            legend = list(xanchor= "left")
        )
    
}

umc_plot_opensci_oa <- function (dataset, dataset_all, umc, absnum, color_palette) {

    ## Calculate the numerators and the denominator for the
    ## "all" bars

    plot_data <- dataset %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            city == umc,
            !is.na(doi)
        )

    plot_data_all <- dataset_all %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            !is.na(doi)
        )

    all_denom <- plot_data_all %>%
        nrow()

    all_gold <- plot_data_all %>%
        filter( color == "gold") %>%
        nrow()

    all_green <- plot_data_all %>%
        filter( color == "green") %>%
        nrow()

    all_hybrid <- plot_data_all %>%
        filter( color == "hybrid") %>%
        nrow()

    all_na <- plot_data_all %>%
        filter( is.na(color) ) %>%
        nrow()

    all_closed <- plot_data_all %>%
        filter( color == "closed") %>%
        nrow()

    all_bronze <- plot_data_all %>%
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

    umc_na <- plot_data %>%
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

        dataset <- dataset %>%
            filter(
                has_publication == TRUE,
                publication_type == "journal publication",
                !is.na(doi),
                ! is.na (publication_date_unpaywall),
                city == umc
            )

        dataset$oa_year <- dataset$publication_date_unpaywall %>%
            format("%Y")

        plot_data <- tribble(
            ~x_label, ~gold,    ~green,    ~hybrid,    ~na,    ~closed,    ~bronze
        )

        upperlimit <- 0

        for (year in unique(dataset$oa_year)) {
            
            gold_num <- dataset %>%
                filter(
                    oa_year == year,
                    city == umc,
                    color == "gold"
                ) %>%
                nrow()
            
            green_num <- dataset %>%
                filter(
                    oa_year == year,
                    city == umc,
                    color == "green"
                ) %>%
                nrow()

            hybrid_num <- dataset %>%
                filter(
                    oa_year == year,
                    city == umc,
                    color == "hybrid"
                ) %>%
                nrow()

            na_num <- dataset %>%
                filter(
                    oa_year == year,
                    city == umc,
                    is.na(color)
                ) %>%
                nrow()
            
            closed_num <- dataset %>%
                filter(
                    oa_year == year,
                    city == umc,
                    color == "closed"
                ) %>%
                nrow()

            bronze_num <- dataset %>%
                filter(
                    oa_year == year,
                    city == umc,
                    color == "bronze"
                ) %>%
                nrow()
            
            year_denom <- dataset %>%
                filter(
                    oa_year == year,
                    city == umc
                ) %>%
                nrow()

            if (year_denom > 0) {
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
        add_trace(
            y = ~na,
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
            ~x_label, ~gold,                         ~green,                         ~hybrid,                         ~na,                         ~closed,                         ~bronze,
            "All",    round(100*all_gold/all_denom), round(100*all_green/all_denom), round(100*all_hybrid/all_denom), round(100*all_na/all_denom), round(100*all_closed/all_denom), round(100*all_bronze/all_denom),
            umc,      round(100*umc_gold/umc_denom), round(100*umc_green/umc_denom), round(100*umc_hybrid/umc_denom), round(100*umc_na/umc_denom), round(100*umc_closed/umc_denom), round(100*umc_bronze/umc_denom)
        )

        plot_data$x_label <- fct_relevel(plot_data$x_label, "All", after= Inf)

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
                range = c(0, 105)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    

        
    }

}

umc_plot_opensci_green_oa <- function (dataset, dataset_all, umc, absnum, color_palette) {

    #Denom for percentage plot
    oa_set <- dataset %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            !is.na(doi),
            is_closed_archivable == TRUE | color_green_only == "green"
        )
    
    oa_set_all <- dataset_all %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            !is.na(doi),
            is_closed_archivable == TRUE | color_green_only == "green"
        )
    
    all_denom <- oa_set_all %>%
        nrow()
    
    all_numer <- oa_set_all %>%
        filter(
            color_green_only == "green"
        ) %>%
        nrow()
    
    #Denom for absolute number plot
    oa_set_abs <- dataset %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            !is.na(doi)
        )
    
    oa_set_abs_all <- dataset_all %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            !is.na(doi)
        )
    
    all_archived <- oa_set_abs_all %>%
        filter(
            color_green_only == "green"
        ) %>%
        nrow()
    
    all_can_archive <- oa_set_abs_all %>%
        filter(
            is_closed_archivable == TRUE
        ) %>%
        nrow()
    
    all_cant_archive <- oa_set_abs_all %>%
        filter(
            is_closed_archivable == FALSE
        ) %>%
        nrow()
    
    all_no_data <- oa_set_abs_all %>%
        filter(
            color == "bronze" | color == "closed",
            is.na(is_closed_archivable)
        ) %>%
        nrow()

    #Again use the denominator for the percentage plot
    umc_denom <- oa_set %>%
        filter(
            city == umc
        ) %>%
        nrow()
    
    umc_numer <- oa_set %>%
        filter(
            city == umc,
            color_green_only == "green"
        ) %>%
        nrow()
    
    #Again use the denominator for the absolute number plot
    umc_archived <- oa_set_abs %>%
        filter(
            city == umc,
            color_green_only == "green"
        ) %>%
        nrow()
    
    umc_can_archive <- oa_set_abs %>%
        filter(
            city == umc,
            is_closed_archivable == TRUE
        ) %>%
        nrow()
    
    umc_cant_archive <- oa_set_abs %>%
        filter(
            city == umc,
            is_closed_archivable == FALSE
        ) %>%
        nrow()
    
    umc_no_data <- oa_set_abs %>%
        filter(
            city == umc,
            color == "bronze" | color == "closed",
            is.na(is_closed_archivable)
        ) %>%
        nrow()
    
    if (absnum) {
        
        plot_data <- tribble(
            ~x_label, ~percentage, ~can_archive,   ~cant_archive,    ~no_data,
            umc,      umc_archived,   umc_can_archive, umc_cant_archive, umc_no_data
        )
        
        upperlimit <- 1.1 * sum(umc_archived, umc_can_archive, umc_cant_archive, umc_no_data)
        ylabel <- "Number of publications"
        
    } else {
        
        plot_data <- tribble(
            ~x_label, ~percentage,
            "All", round(100*all_numer/all_denom),
            umc, round(100*umc_numer/umc_denom)
        )
        
        plot_data$x_label <- fct_relevel(plot_data$x_label, "All", after= Inf)
        
        upperlimit <- 105
        ylabel <- "Percentage of publications (%)"
        
    }
    
    if (absnum) {
        
        plot_ly(
            plot_data,
            x = ~x_label,
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
        
        plot_ly(
            plot_data,
            x = ~x_label,
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
