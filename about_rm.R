about_rm_page <- tabPanel(
    "Contributions",
    value = "tabAboutRM",
    h2("Contributions"),
    br(),
    helpText('We would like to thank all those who contributed to this dashboard. We would
             particularly like to thank Nico Riedel who created the prototype of this dashboard, which
             we adapted for clinical research transparency at the level of UMCs in Germany.'),
    # br(),
    # h4("UMC publication search"),
    # helpText('Franzen, Delwen (Conceptualization, Methodology, Technical Implementation, Validation); Saksone, Lana (Conceptualization, Methodology, Validation); Grabitz, Peter (Conceptualization, Methodology); Riedel, Nico (Conceptualization, Methodology, Technical Implementation); Carlisle, Benjamin Gregory (Methodology, Technical Implementation, Validation), Holst, Martin (Conceptualization, Validation); Salholz-Hillel, Maia (Conceptualization, Methodology); Strech, Daniel (Conceptualization, Methodology)'),
    # br(),
    # h4("ODDPub - Open Data & Code detection"),
    # helpText('Riedel, Nico (Conceptualization, Methodology, Technical Implementation, Validation);
    #                             Bobrov, Evgeny (Conceptualization, Methodology, Validation);
    #                             Kip, Miriam (Conceptualization, Methodology)'),
    
    br(),
    h3("Metrics"),
    h4("Prospective registration, Reporting of summary results in the registry, Reporting of results as a journal publication (2- and 5 years)"),
    helpText("Riedel, Nico (Conceptualization, Methodology, Data Curation, Technical Implementation);
                Salholz-Hillel, Maia (Conceptualization, Methodology, Data Curation, Technical Implementation);
                Wieschowski, Susanne (Conceptualization, Methodology);
                Carlisle, Benjamin Gregory (Technical Implementation);
                Strech, Daniel (Conceptualization, Methodology)"),
    h4("Reporting of Trial Registration Number in publications, Publication link in the registry"),
    helpText("Salholz-Hillel, Maia (Conceptualization, Methodology, Technical Implementation);
             Carlisle, Benjamin Gregory (Methodology);"),
    h4("Reporting of summary results in EUCTR"),
    helpText("EU TrialsTracker;
             Carlisle, Benjamin Gregory (Conceptualization, Methodology, Technical Implementation);
             Franzen, Delwen (Conceptualization, Methodology, Technical Implementation)"),
    h4("Open Access"),
    helpText("Delwen Franzen (Conceptualization, Methodology, Technical Implementation);
             Nico Riedel (Conceptualization, Methodology, Technical Implementation)"),
    ## h4("Realised potential of green Open Access"),
    ## helpText("Delwen Franzen (Conceptualization, Methodology, Technical Implementation)"),
    
    # br(),
    # h4("Robustness of animal studies"),
    # helpText('We thank Anita Bandrowski for sharing with us SciScore data from which we derived the robustness
    #          metrics in animal studies displayed in this proof-of-principle dashboard'),
    
    
    br(),
    h3("Shiny app"),
    helpText('Carlisle, Benjamin Gregory (Conceptualization, Technical Implementation);
                Franzen, Delwen (Conceptualization, Technical Implementation);
                Riedel, Nico (Conceptualization, Technical Implementation);
                Nachev, Vladislav (Conceptualization, Technical Implementation);
                Maia Salholz-Hillel (Conceptualization);
                Holst, Martin (Conceptualization);
                Haven, Tamarinde (Conceptualization);
                Haslberger, Martin (Conceptualization);
                Saksone, Lana (Conceptualization);
                Strech, Daniel (Conceptualization);
                Weissgerber, Tracey (Conceptualization);
                Dirnagl, Ulrich (Conceptualization);
             Bobrov, Evgeny (Conceptualization)'),
    
    br(),
    h2('Contact address'),
    helpText('QUEST Center for Responsible Research,'),
    helpText('Berlin Institute of Health (BIH), Berlin, Germany'),
    helpText('Anna-Louisa-Karsch-Str. 2'),
    helpText('10178 Berlin '),
    helpText('quest@bih-charite.de'),
    helpText(HTML('<a href="https://www.bihealth.org/de/translation/innovationstreiber/quest-center">
                                      https://www.bihealth.org/de/translation/innovationstreiber/quest-center </a>')),
    bsCollapsePanel(strong("Impressum"),
                    impressum_text,
                    style = "default"),
    bsCollapsePanel(strong("Datenschutz"),
                    datenschutz_text,
                    style = "default")
)

