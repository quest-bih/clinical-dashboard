## Prospective registration
plot_allumc_clinicaltrials_prereg <- function (dataset, color_palette, color_palette_bars) {
    
    dataset <- dataset %>%
        filter( ! is.na (start_date) )

    plot_data <- tribble (
        ~x_label, ~percentage
    )

    for (umc in unique(dataset$city)) {

        umc_numer <- dataset %>%
            filter(
                city == umc,
                is_prospective
            ) %>%
            nrow()

        umc_denom <- dataset %>%
            filter(city == umc) %>%
            nrow()

        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~x_label, ~percentage,
                    umc, round(100*umc_numer/umc_denom),
                )
            )
    }

    plot_data$x_label <- factor(
        plot_data$x_label,
        levels = unique(plot_data$x_label)[order(plot_data$percentage, decreasing=TRUE)]
    )

     plot_ly(
        plot_data,
        x = ~x_label,
        y = ~percentage,
        type = 'bar',
        marker = list(
            color = color_palette_bars[1],
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
                title = '<b>Percentage of trials (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    
}

## TRN
plot_allumc_clinicaltrials_trn <- function (dataset, color_palette) {

    plot_data <- tribble (
        ~x_label, ~colour, ~percentage
    )

    for (umc in unique(dataset$city)) {

        umc_numer_abs <- dataset %>%
            filter(city == umc) %>%
            select(has_iv_trn_abstract) %>%
            filter(has_iv_trn_abstract == TRUE) %>%
            nrow()

        umc_numer_ft <- dataset %>%
            filter(city == umc) %>%
            select(has_iv_trn_ft_pdf) %>%
            filter(has_iv_trn_ft_pdf == TRUE) %>%
            nrow()

        umc_numer_either <- dataset %>%
            filter(
                city == umc,
                has_iv_trn_abstract == TRUE | has_iv_trn_ft_pdf == TRUE
            ) %>%
            nrow()

        umc_ft_denom <- dataset %>%
            filter(city == umc) %>%
            filter(! is.na(has_iv_trn_ft_pdf)) %>%
            nrow()
        
        umc_abs_denom <- dataset %>%
            filter(city == umc) %>%
            filter(! is.na(has_iv_trn_abstract)) %>%
            nrow()
        
        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~x_label, ~colour, ~percentage, ~either,
                    umc, "In abstract", round(100*umc_numer_abs/umc_abs_denom), 100-round(100*umc_numer_either/umc_abs_denom),
                    umc, "In full-text", round(100*umc_numer_ft/umc_ft_denom), 100-round(100*umc_numer_either/umc_ft_denom)
                )
            )
    }

     plot_ly(
        plot_data,
        x = ~reorder(x_label,either),
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

## Publication link in registry
plot_allumc_linkage <- function (dataset, color_palette, color_palette_bars) {

    dataset <- dataset %>%
        filter(publication_type == "journal publication") %>%
        filter (has_pubmed == TRUE | ! is.na (doi))

    plot_data <- tribble(
        ~x_label, ~percentage
    )

    for (umc in unique(dataset$city)) {

        umcdata <- dataset %>%
            filter(city == umc)

        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~x_label, ~percentage,
                    umc, 100*mean(umcdata$has_reg_pub_link, na.rm=TRUE)
                )
            )
        
    }

    plot_data$x_label <- factor(
        plot_data$x_label,
        levels = unique(plot_data$x_label)[order(plot_data$percentage, decreasing=TRUE)]
    )

     plot_ly(
        plot_data,
        x = ~x_label,
        y = ~percentage,
        type = 'bar',
        marker = list(
            color = "#634587",
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
                title = '<b>Linked publications in registry (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    
}

## Summary results

plot_allumc_clinicaltrials_sumres <- function (dataset, color_palette, color_palette_bars) {

    max_date <- max(dataset$date)

    dataset <- dataset %>%
        filter( date == max_date ) %>%
        distinct (city, .keep_all=TRUE)

    plot_data <- dataset %>%
        rename (x_label = city) %>%
        rename (percentage = percent_reported)

    plot_data$x_label <- factor(
        plot_data$x_label,
        levels = unique(plot_data$x_label)[order(plot_data$percentage, decreasing=TRUE)]
    )

    plot_ly(
        plot_data,
        x = ~x_label,
        y = ~percentage,
        type = 'bar',
        marker = list(
            color = color_palette_bars,
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
                title = '<b>Summary results reporting (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    
}

## Timely reporting (2 years)
plot_allumc_clinicaltrials_timpub <- function (dataset, color_palette, color_palette_bars) {
    
    dataset <- dataset %>%
        filter(has_followup_2y == TRUE)

    plot_data <- tribble (
        ~x_label, ~percentage
    )

    for (umc in unique(dataset$city)) {

        umc_numer <- dataset %>%
            filter(
                city == umc,
                is_summary_results_2y | is_publication_2y
            ) %>%
            nrow()

        umc_denom <- dataset %>%
            filter(city == umc) %>%
            nrow()

        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~x_label, ~percentage,
                    umc, round(100*umc_numer/umc_denom),
                )
            )
    }

    plot_data$x_label <- factor(
        plot_data$x_label,
        levels = unique(plot_data$x_label)[order(plot_data$percentage, decreasing=TRUE)]
    )

     plot_ly(
        plot_data,
        x = ~x_label,
        y = ~percentage,
        type = 'bar',
        marker = list(
            color = color_palette_bars[3],
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
                title = '<b>Published within 2 years (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    
}

## Timely reporting (5a)

plot_allumc_timpub_5a <- function (dataset, color_palette, color_palette_bars) {

    dataset <- dataset %>%
        filter(has_followup_5y == TRUE)

    plot_data <- tribble (
        ~x_label, ~percentage
    )

    for (umc in unique(dataset$city)) {

        umc_numer <- dataset %>%
            filter(
                city == umc,
                is_summary_results_5y | is_publication_5y
            ) %>%
            nrow()

        umc_denom <- dataset %>%
            filter(city == umc) %>%
            nrow()

        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~x_label, ~percentage,
                    umc, round(100*umc_numer/umc_denom),
                )
            )
    }

    plot_data$x_label <- factor(
        plot_data$x_label,
        levels = unique(plot_data$x_label)[order(plot_data$percentage, decreasing=TRUE)]
    )

     plot_ly(
        plot_data,
        x = ~x_label,
        y = ~percentage,
        type = 'bar',
        marker = list(
            color = color_palette_bars[4],
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
                title = '<b>Published within 5 years (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    
}

## Open Access
plot_allumc_openaccess <- function (dataset, color_palette) {

    dataset <- dataset %>%
        filter(
            has_publication,
            publication_type == "journal publication",
            !is.na(doi)
        )

    plot_data <- tribble (
        ~x_label, ~colour, ~percentage
    )

    for (umc in unique(dataset$city)) {

        umc_gold <- dataset %>%
            filter(
                color == "gold",
                city == umc
            ) %>%
            nrow()

        umc_green <- dataset %>%
            filter(
                color == "green",
                city == umc
            ) %>%
            nrow()

        umc_hybrid <- dataset %>%
            filter(
                color == "hybrid",
                city == umc
            ) %>%
            nrow()

        umc_sum <- umc_gold + umc_green + umc_hybrid

        umc_denom <- dataset %>%
            filter(city == umc) %>%
            nrow()

        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~x_label, ~colour, ~percentage, ~sum,
                    umc, "Gold", round(100*umc_gold/umc_denom), 100-round(100*umc_sum/umc_denom),
                    umc, "Green", round(100*umc_green/umc_denom), 100-round(100*umc_sum/umc_denom),
                    umc, "Hybrid", round(100*umc_hybrid/umc_denom), 100-round(100*umc_sum/umc_denom)
                )
            )
    
    }

    plot_data$x_label <- factor(
        plot_data$x_label,
        levels = unique(plot_data$x_label)[order(plot_data$percentage, decreasing=TRUE)]
    )

    plot_ly(
        plot_data,
        x = ~reorder(x_label, sum),
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
            barmode = 'stack',
            xaxis = list(
                title = '<b>UMC</b>'
            ),
            yaxis = list(
                title = '<b>Percentage of publications (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    
}

## Green OA
plot_allumc_greenoa <- function (dataset, color_palette, color_palette_bars) {

    dataset <- dataset %>%
        filter( ! is.na (color) )

    plot_data <- tribble(
        ~x_label, ~percentage
    )

    for (umc in unique(dataset$city)) {

        umc_closed_with_potential <- dataset %>%
            filter(
                city == umc,
                is_closed_archivable == TRUE
            ) %>%
            nrow()

        umc_numer <- dataset %>%
            filter(
                city == umc,
                color_green_only == "green"
            ) %>%
            nrow()

        umc_denom <- umc_numer + umc_closed_with_potential

        plot_data <- plot_data %>%
            bind_rows(
                tribble(
                    ~x_label, ~percentage,
                    umc, round(100*umc_numer/umc_denom)
                )
            )
    }

    plot_data$x_label <- factor(
        plot_data$x_label,
        levels = unique(plot_data$x_label)[order(plot_data$percentage, decreasing=TRUE)]
    )

    plot_ly(
        plot_data,
        x = ~x_label,
        y = ~percentage,
        type = 'bar',
        marker = list(
            color = "#007265",
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
                title = '<b>Potential Green OA (%)</b>',
                range = c(0, 100)
            ),
            paper_bgcolor = color_palette[9],
            plot_bgcolor = color_palette[9]
        )
    
}

