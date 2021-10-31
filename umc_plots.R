## Prospective registration
umc_plot_clinicaltrials_prereg <- function (dataset, dataset_all, dataset_iv_umc, dataset_iv_all, toggled_registry, umc, color_palette) {

    if (toggled_registry == "ClinicalTrials.gov") {
        
        dataset <- dataset %>%
            filter( ! is.na (start_date) ) %>%
            mutate(start_year = format(start_date, "%Y"))

        dataset_all <- dataset_all %>%
            filter( ! is.na (start_date) ) %>%
            mutate(start_year = format(start_date, "%Y"))

        years <- seq(from=min(dataset$start_year, na.rm=TRUE), to=max(dataset$start_year, na.rm=TRUE))

        plot_data <- tribble(
            ~year, ~all_percentage, ~umc_percentage, ~all_mouseover, ~umc_mouseover
        )

        for (current_year in years) {

            numer_for_year <- dataset %>%
                filter(
                    city == umc,
                    start_year == current_year,
                    is_prospective == TRUE
                ) %>%
                nrow()

            denom_for_year <- dataset %>%
                filter(
                    city == umc,
                    start_year == current_year
                ) %>%
                nrow()

            all_numer_for_year <-  dataset_all %>%
                filter(
                    start_year == current_year,
                    is_prospective == TRUE
                ) %>%
                nrow()

            all_denom_for_year <- dataset_all %>%
                filter(
                    start_year == current_year
                ) %>%
                nrow()

            if (denom_for_year > 0) {
                percentage_for_year <- round(100*numer_for_year/denom_for_year, digits=1)
            } else {
                percentage_for_year <- NA
            }

            all_percentage_for_year <- round(100*all_numer_for_year/all_denom_for_year, digits=1)
            
            plot_data <- plot_data %>%
                bind_rows(
                    tribble(
                        ~year, ~all_percentage, ~umc_percentage, ~all_mouseover, ~umc_mouseover,
                        current_year, all_percentage_for_year, percentage_for_year, paste0(all_numer_for_year, "/", all_denom_for_year), paste0(numer_for_year, "/", denom_for_year)
                    )
                )

        }
        
    }

    if (toggled_registry == "DRKS") {

        dataset <- dataset_iv_umc %>%
            filter( ! is.na (start_date) ) %>%
            filter(registry == toggled_registry) %>%
            mutate(start_year = format(start_date, "%Y"))

        dataset_all <- dataset_iv_all %>%
            filter( ! is.na (start_date) ) %>%
            filter(registry == toggled_registry) %>%
            mutate(start_year = format(start_date, "%Y"))

        years <- seq(from=min(dataset$start_year), to=max(dataset$start_year))

        plot_data <- tribble(
            ~year, ~all_percentage, ~umc_percentage, ~all_mouseover, ~umc_mouseover
        )

        for (current_year in years) {

            numer_for_year <- dataset %>%
                filter(
                    city == umc,
                    start_year == current_year,
                    is_prospective == TRUE
                ) %>%
                nrow()

            denom_for_year <- dataset %>%
                filter(
                    city == umc,
                    start_year == current_year
                ) %>%
                nrow()

            all_numer_for_year <-  dataset_all %>%
                filter(
                    start_year == current_year,
                    is_prospective == TRUE
                ) %>%
                nrow()

            all_denom_for_year <- dataset_all %>%
                filter(
                    start_year == current_year
                ) %>%
                nrow()

            if (denom_for_year > 0) {
                percentage_for_year <- round(100*numer_for_year/denom_for_year, digits=1)
            } else {
                percentage_for_year <- NA
            }

            all_percentage_for_year <- round(100*all_numer_for_year/all_denom_for_year, digits=1)
            
            plot_data <- plot_data %>%
                bind_rows(
                    tribble(
                        ~year, ~all_percentage, ~umc_percentage, ~all_mouseover, ~umc_mouseover,
                        current_year, all_percentage_for_year, percentage_for_year, paste0(all_numer_for_year, "/", all_denom_for_year), paste0(numer_for_year, "/", denom_for_year)
                    )
                )

        }
        
    }

    plot_ly(
        data=plot_data,
        x = ~year,
        y = ~all_percentage,
        name = "All",
        text = ~all_mouseover,
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
            data=plot_data %>% filter(!is.na(umc_percentage)),
            y=~umc_percentage,
            name=umc,
            text=~umc_mouseover,
            marker = list(color = color_palette[2])
        ) %>%
        layout(
            xaxis = list(
                title = '<b>Start year</b>',
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
            has_ft == TRUE
        )
    
    plot_data_ft_all <- dataset_all %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            has_ft == TRUE
        )
    
    all_numer_abs <- sum(plot_data_abs_all$has_iv_trn_abstract, na.rm=TRUE)
    abs_denom <- plot_data_abs_all %>%
        filter(! is.na(has_iv_trn_abstract)) %>%
        nrow()
    
    all_numer_ft <- sum(plot_data_ft_all$has_iv_trn_ft, na.rm=TRUE)
    ft_denom <- plot_data_ft_all %>%
        filter(! is.na(has_iv_trn_ft)) %>%
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
        select(has_iv_trn_ft) %>%
        filter(has_iv_trn_ft == TRUE) %>%
        nrow()

    umc_ft_denom <- plot_data_ft %>%
        filter(city == umc) %>%
        filter(! is.na(has_iv_trn_ft)) %>%
        nrow()

    plot_data <- tribble(
        ~x_label, ~colour, ~percentage, ~mouseover,
        "All", "In abstract", round(100*all_numer_abs/abs_denom, digits=1), paste0(all_numer_abs, "/", abs_denom),
        "All", "In full text", round(100*all_numer_ft/ft_denom, digits=1), paste0(all_numer_ft, "/", ft_denom),
        umc, "In abstract", round(100*umc_numer_abs/umc_abs_denom, digits=1), paste0(umc_numer_abs, "/", umc_abs_denom),
        umc, "In full text", round(100*umc_numer_ft/umc_ft_denom, digits=1), paste0(umc_numer_ft, "/", umc_ft_denom)
    )

    plot_data$x_label <- fct_relevel(plot_data$x_label, "All", after= Inf)

    plot_ly(
        plot_data,
        x = ~x_label,
        color = ~colour,
        y = ~percentage,
        text = ~mouseover,
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
    
    dataset_all <- dataset_all %>%
        filter(has_publication == TRUE) %>%
        filter(publication_type == "journal publication") %>%
        filter(has_pubmed == TRUE | ! is.na (doi))
    
    years <- seq(from=min(dataset_all$completion_year), to=max(dataset_all$completion_year))
    
    umcdata <- dataset %>%
        filter (city == umc)
    
    plot_data <- tribble(
        ~year, ~all_percentage, ~umc_percentage, ~all_mouseover, ~umc_mouseover
    )

    for (current_year in years) {

        umc_numer <- umcdata %>%
            filter(has_reg_pub_link == TRUE) %>%
            filter(completion_year == current_year) %>%
            nrow()

        umc_denom <- umcdata %>%
            filter(completion_year == current_year) %>%
            nrow()

        all_numer <- dataset_all %>%
            filter(has_reg_pub_link == TRUE) %>%
            filter(completion_year == current_year) %>%
            nrow()

        all_denom <- dataset_all %>%
            filter(completion_year == current_year) %>%
            nrow()

        if (umc_denom > 0) {
            percentage_for_year <- round(100*umc_numer/umc_denom, digits=1)
        } else {
            percentage_for_year <- NA
        }
        
        all_percentage_for_year <- round(100*all_numer/all_denom, digits=1)
        
        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~year, ~all_percentage, ~umc_percentage, ~all_mouseover, ~umc_mouseover,
                    current_year, all_percentage_for_year, percentage_for_year, paste0(all_numer, "/", all_denom), paste0(umc_numer, "/", umc_denom)
                )
            )
        
    }

     plot_ly(
        data = plot_data,
        name = "All",
        x = ~year,
        y = ~all_percentage,
        text = ~all_mouseover,
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
             data=plot_data %>% filter(!is.na(umc_percentage)),
             y=~umc_percentage,
             text=~umc_mouseover,
             name=umc,
             marker = list(color = color_palette[2])
         ) %>%
         layout(
             xaxis = list(
                 title = '<b>Completion year</b>',
                 dtick = 1
             ),
             yaxis = list(
                 title = '<b>Trials with publication (%)</b>',
                 range = c(0, 105)
             ),
             paper_bgcolor = color_palette[9],
             plot_bgcolor = color_palette[9],
             legend = list(xanchor= "left")
         )
}

## Summary results
umc_plot_clinicaltrials_sumres <- function (eutt_dataset, iv_dataset, iv_all_dataset, toggled_registry, umc, color_palette) {

    
    if (toggled_registry == "EUCTR") {

        dataset <- eutt_dataset %>%
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
            mutate(avg = round(100*sum(total_reported)/sum(total_due), digits=1)) %>%
            mutate(mouseover = paste0(sum(total_reported), "/", sum(total_due))) %>%
            slice_head() %>%
            select(date, hash, avg, month, total_due, total_reported, mouseover) %>%
            rename(percent_reported = avg) %>%
            mutate(city = "All") %>%
            ungroup()
        
        city_data <- dataset %>%
            mutate(mouseover = paste0(sum(total_reported), "/", sum(total_due))) %>%
            filter(city == umc)
        
    } else { ## The registry is not EUCTR

        dataset <- iv_dataset %>%
            filter(
                registry == toggled_registry,
                city == umc
            )

        min_year <- dataset$completion_year %>%
            min()

        max_year <- dataset$completion_year %>%
            max()

        city_data <- tribble(
            ~date, ~percent_reported, ~city
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

            city_data <- city_data %>%
                bind_rows(
                    tribble(
                        ~date, ~percent_reported, ~city, ~mouseover,
                        currentyear, round(100*currentyear_numer/currentyear_denom, digits=1), umc, paste0(currentyear_numer, "/", currentyear_denom)
                    )
                )
            
        }

        dataset <- iv_all_dataset %>%
            filter(
                registry == toggled_registry
            )
        
        all_data <- tribble(
            ~date, ~percent_reported, ~city
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

            all_data <- all_data %>%
                bind_rows(
                    tribble(
                        ~date, ~percent_reported, ~city, ~mouseover,
                        currentyear, round(100*currentyear_numer/currentyear_denom, digits=1), "All", paste0(currentyear_numer, "/", currentyear_denom)
                    )
                )
            
        }
        
    }

    plot_data <- rbind(all_data, city_data)

    plot_ly(
        plot_data,
        x = ~date,
        y = ~percent_reported,
        name = ~city,
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

    years <- seq(from=min(dataset$completion_year), to=max(dataset$completion_year))

    all_denom <- dataset_all %>%
        nrow()
    
    all_numer <- dataset_all %>%
        filter(published_2a) %>%
        nrow()

    plot_data <- tribble(
        ~year, ~all_percentage, ~umc_percentage
    )

    for (current_year in years) {

        umc_numer <-  dataset %>%
            filter(
                city == umc,
                completion_year == current_year,
                published_2a
            ) %>%
            nrow()

        umc_denom <-  dataset %>%
            filter(
                city == umc,
                completion_year == current_year
            ) %>%
            nrow()

        all_numer <-  dataset_all %>%
            filter(
                completion_year == current_year,
                published_2a
            ) %>%
            nrow()

        all_denom <-  dataset_all %>%
            filter(
                completion_year == current_year
            ) %>%
            nrow()

        if (umc_denom > 0) {
            umc_percentage <- round(100*umc_numer/umc_denom, digits=1)
        } else {
            umc_percentage <- NA
        }
        
        all_percentage <- round(100*all_numer/all_denom, digits=1)

        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~year, ~all_percentage, ~umc_percentage, ~all_mouseover, ~umc_mouseover,
                    current_year, all_percentage, umc_percentage, paste0(all_numer, "/", all_denom), paste0(umc_numer, "/", umc_denom)
                )
            )
        
    }

    plot_ly(
        data=plot_data,
        x = ~year,
        y = ~all_percentage,
        text = ~all_mouseover,
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
        add_trace(
            data=plot_data %>% filter(!is.na(umc_percentage)),
            y=~umc_percentage,
            name=umc,
            text=~umc_mouseover,
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

    years <- seq(from=min(dataset$completion_year), to=max(dataset$completion_year))

    all_denom <- dataset_all %>%
        nrow()
    
    all_numer <- dataset_all %>%
        filter(published_5a) %>%
        nrow()
    
    plot_data <- tribble(
        ~year, ~all_percentage, ~umc_percentage, ~all_mouseover, ~umc_mouseover
    )

    for (current_year in years) {

        umc_numer <-  dataset %>%
            filter(
                city == umc,
                completion_year == current_year,
                published_5a
            ) %>%
            nrow()

        umc_denom <-  dataset %>%
            filter(
                city == umc,
                completion_year == current_year
            ) %>%
            nrow()

        all_numer <-  dataset_all %>%
            filter(
                completion_year == current_year,
                published_5a
            ) %>%
            nrow()

        all_denom <-  dataset_all %>%
            filter(
                completion_year == current_year
            ) %>%
            nrow()
        
        if (umc_denom > 0) {
            umc_percentage <- round(100*umc_numer/umc_denom, digits=1)
        } else {
            umc_percentage <- NA
        }
        
        all_percentage <- round(100*all_numer/all_denom, digits=1)

        if (all_denom > 5) { ## This is because we only have 1
            ## data point in 2013 with 5 years of
            ## follow-up

            plot_data <- plot_data %>%
                bind_rows(
                    tribble(
                        ~year, ~all_percentage, ~umc_percentage, ~all_mouseover, ~umc_mouseover,
                        current_year, all_percentage, umc_percentage, paste0(all_numer, "/", all_denom), paste0(umc_numer, "/", umc_denom)
                    )
                )
        }
        
    }

    plot_ly(
        data=plot_data,
        x = ~year,
        y = ~all_percentage,
        name = "All",
        text = ~all_mouseover,
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
            data=plot_data %>% filter(!is.na(umc_percentage)),
            y=~umc_percentage,
            text=~umc_mouseover,
            name=umc,
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

## Open access
umc_plot_opensci_oa <- function (dataset, dataset_all, umc, absnum, color_palette) {

    ## Calculate the numerators and the denominator for the
    ## "all" bars

    plot_data <- dataset %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            city == umc,
            !is.na(doi)
        ) %>%
        distinct(doi, .keep_all=TRUE)

    plot_data_all <- dataset_all %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            !is.na(doi)
        ) %>%
        distinct(doi, .keep_all=TRUE)

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
        
        years <- seq(from=min(dataset$oa_year, na.rm=TRUE), to=max(dataset$oa_year, na.rm=TRUE))

        for (year in years) {
            
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
        ## Not "absolute numbers"

        plot_data <- tribble(
            ~x_label, ~gold,                         ~green,                         ~hybrid,                         ~na,                         ~closed,                         ~bronze,     ~gold_numer, ~green_numer, ~hybrid_numer, ~sum,
            "All",    round(100*all_gold/all_denom, digits=1), round(100*all_green/all_denom, digits=1), round(100*all_hybrid/all_denom, digits=1), round(100*all_na/all_denom, digits=1), round(100*all_closed/all_denom, digits=1), round(100*all_bronze/all_denom, digits=1), all_gold, all_green, all_hybrid, all_denom,
            umc,      round(100*umc_gold/umc_denom, digits=1), round(100*umc_green/umc_denom, digits=1), round(100*umc_hybrid/umc_denom, digits=1), round(100*umc_na/umc_denom, digits=1), round(100*umc_closed/umc_denom, digits=1), round(100*umc_bronze/umc_denom, digits=1), umc_gold, umc_green, umc_hybrid, umc_denom
        )

        plot_data$x_label <- fct_relevel(plot_data$x_label, "All", after= Inf)

        ylabel <- "Percentage Open Access (%)"

        
    plot_ly(
        plot_data,
        x = ~x_label,
        y = ~gold,
        name = "Gold",
        text = ~paste0(gold_numer, "/", sum),
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
            text = ~paste0(green_numer, "/", sum),
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
            text = ~paste0(hybrid_numer, "/", sum),
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

    dataset$oa_year <- dataset$publication_date_unpaywall %>%
        format("%Y")
    
    #Denom for percentage plot
    oa_set <- dataset %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            !is.na(doi),
            is_closed_archivable == TRUE | color_green_only == "green",
            ! is.na(publication_date_unpaywall)
        )

    oa_set_all <- dataset_all %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            !is.na(doi),
            is_closed_archivable == TRUE | color_green_only == "green",
            ! is.na(publication_date_unpaywall)
        )
    
    all_denom <- oa_set_all %>%
        nrow()
    
    all_numer <- oa_set_all %>%
        filter(
            color_green_only == "green"
        ) %>%
        nrow()
    
    #Filter data for absolute number plot
    oa_set_abs <- dataset %>%
        filter(
            has_publication == TRUE,
            publication_type == "journal publication",
            !is.na(doi),
            ! is.na(publication_date_unpaywall)
        )
    
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
    
    if (absnum) {

        plot_data <- tribble(
            ~x_label, ~percentage, ~can_archive,   ~cant_archive,    ~no_data
        )

        upperlimit <- 0

        umc_oa_set_abs <- dataset %>%
            filter(city == umc)

        years <- seq(from=min(umc_oa_set_abs$oa_year, na.rm=TRUE), to=max(umc_oa_set_abs$oa_year, na.rm=TRUE))

        for (year in years) {

            umc_archived <- oa_set_abs %>%
                filter(
                    city == umc,
                    color_green_only == "green",
                    oa_year == year
                ) %>%
                nrow()
            
            umc_can_archive <- oa_set_abs %>%
                filter(
                    city == umc,
                    is_closed_archivable == TRUE,
                    oa_year == year
                ) %>%
                nrow()
            
            umc_cant_archive <- oa_set_abs %>%
                filter(
                    city == umc,
                    is_closed_archivable == FALSE,
                    oa_year == year
                ) %>%
                nrow()
            
            umc_no_data <- oa_set_abs %>%
                filter(
                    city == umc,
                    color == "closed",
                    is.na(is_closed_archivable),
                    oa_year == year
                ) %>%
                nrow()

            plot_data <- plot_data %>%
                bind_rows(
                    tribble(
                        ~x_label, ~percentage, ~can_archive,   ~cant_archive,    ~no_data,
                        year, umc_archived, umc_can_archive, umc_cant_archive, umc_no_data
                    )
                )
            
            year_upperlimit <- 1.1 * sum(umc_archived, umc_can_archive, umc_cant_archive, umc_no_data)
            upperlimit <- max(year_upperlimit, upperlimit)
            
        }
        
        ylabel <- "Paywalled publications"
        
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
            ~x_label, ~percentage, ~mouseover,
            "All", round(100*all_numer/all_denom, digits=1), paste0(all_numer, "/", all_denom),
            umc, round(100*umc_numer/umc_denom, digits=1), paste0(umc_numer, "/", umc_denom)
        )
        
        plot_data$x_label <- fct_relevel(plot_data$x_label, "All", after= Inf)
        
        upperlimit <- 105
        ylabel <- "Paywalled publications (%)"
        
        plot_ly(
            plot_data,
            x = ~x_label,
            y = ~percentage,
            text = ~mouseover,
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
