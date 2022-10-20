make_datatable <- function(dataset) {
    DT::datatable(
            data = dataset,
            extensions = 'Buttons',
            filter = 'top',
            options = list(
                dom = 'Blfrtip',
                buttons =
                    list(
                        list(
                            extend = "collection",
                            buttons = c("csv", "excel"),
                            text = "Download"
                        )
                    ),
                orderClasses = TRUE,
                pageLength = 20,
                lengthMenu = list(
                    c(10, 20, 50, 100, -1),
                    c(10, 20, 50, 100, "All")
                )
            )
        )
}

datasets_page <- tabPanel(
    "Datasets", value = "tabDatasets",
    h3("Datasets"),
    bsCollapsePanel(
      strong("Prospective registrations data set (ClinicalTrials.gov only)"),
      DT::dataTableOutput("data_table_pros_reg_data"),
      style="default"
      ),
    bsCollapsePanel(
      strong("EU Trials Tracker data set"),
      DT::dataTableOutput("data_table_eutt_data"),
      style="default"
      ),
    bsCollapsePanel(
      strong("IntoValue"),
      DT::dataTableOutput("data_table_iv_data"),
      style="default"
      ),
    bsCollapsePanel(strong("Impressum"),
                    impressum_text,
                    style = "default"),
    bsCollapsePanel(strong("Datenschutz"),
                    datenschutz_text,
                    style = "default")
)
