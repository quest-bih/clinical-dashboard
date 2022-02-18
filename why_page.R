why_page <- tabPanel(
    "Why these practices?",
    value = "tabWhy",
    h2("Why these practices?"),
    img(src="why-these-metrics-dashboard.png", width = "100%"),
    bsCollapsePanel(strong("Impressum"),
                    impressum_text,
                    style = "default"),
    bsCollapsePanel(strong("Datenschutz"),
                    datenschutz_text,
                    style = "default")
)
