methods_page <- tabPanel(
    "Methods", value = "tabMethods",
    h1("Methods"),
    
    h4(HTML('This is a dashboard of clinical research transparency at
                       University Medical Centers (UMCs) in Germany. It displays
                       data relating to clinical trials conducted at UMCs
                       in Germany and completed between 2009 - 2017. Metrics
                       included refer to the registration and reporting of these
                       trials. With the exception of summary results reporting in
                       EUCTR, we focused on trials registered in ClinicalTrials.gov
                       and/or the German Clinical Trials Registry (DRKS). The
                       dashboard was developed as part of a scientific research
                       project with the overall aim to support the adoption of
            responsible research practices at German UMCs.')),
                       
    h4(HTML('You can find more information on our methods for individual metrics
    by extending the panels below. You can also find a list of tools used for data
            collection at the bottom of this page. The \"FAQ\" and \"Why these
            metrics?\" pages provide more general information about this dashboard
            and our selection of metrics."')),
    
    h4(style = "margin-left:0cm; color: purple",
       HTML("More information on the overall aim and methodology can be
                       found in the publication asssociated with this dashboard
            [enter DOI]. ")),
    
    h3("Identification of clinical trials"),
    bsCollapse(id = "methodsPanels_IdentificationTrials",
               bsCollapsePanel(strong("Identification of clinical trials"),
                               p(HTML("With the exception of summary results
                               reporting in EUCTR, the data presented in this
                               dashboard is based on a previously developed dataset,
                               IntoValue. This dataset contains data on clinical
                               trials conducted at one of 35 German UMCs and registered
                               on ClinicalTrials.gov and/or the German Clinical Trials
                               Registry (DRKS). Trials were associated with a German UMC
                               by searching these registries for trials with a UMC listed as responsible
                               party or lead sponsor, or with a principle investigator (PI)
                               from a UMC. Trials include all interventional
                               studies and are not limited to investigational medical
                               product trials, as regulated by the EU's Clinical Trials
                               Directive or Germany's Arzneimittelgesetz (AMG) or Novelle
                               des Medizinproduktegesetzes (MPG). All trials were
                               reported as complete between 2009 and 2017 on the
                               trial registry at the time of data collection. The
                               dataset includes the results of both automated extractions
                               from registries (e.g., prospective registration) and
                               manual searches (e.g., timely reporting). The full IntoValue
                               dataset is openly accessible at
                               <a href=https://zenodo.org/record/5141343#.YRJuSS0RrfY>Zenodo</a>.
                               More information on how this dataset was developed can
                               be found in the associated (<a href=https://doi.org/10.1016/j.jclinepi.2019.06.002>IntoValue 1
                               publication</a> and <a href=https://www.medrxiv.org/content/10.1101/2021.08.05.21261624v2
                               >the follow-up IntoValue 2 study</a> now available as a preprint).
                               <br>
                               <br>The IntoValue dataset was adapted in the following ways
                               for the development of this dashboard: (1) we extracted updated
                               registry data from ClinicalTrials.gov and DRKS in
                               May 2021; (2) summary results reporting for trials
                               registered in DRKS was extracted manually from the
                               registry using the registry's change history; (3)
                               we included additional information on the reporting
                               of trial registration numbers in trial results
                               publications, publication linkage in the registry,
                               and Open Access; (4) while the original IntoValue
                               dataset considered both journal publications and
                               dissertations as results publications, we focused
                               on journal publications in this dashboard. More
                               information on how the IntoValue dataset was adapted
                               for use in this dashboard can be found in the
                               <a href=https://github.com/maia-sh/intovalue-data>
                               associated code repository in GitHub</a>.<br>
                               
                               <br>The following German UMCs are not currently included
                               in this dashboard: Augsburg, Bielefeld, and Oldenburg. These
                               UMCs were founded after the start of data collection.")),
                               value = "methodsPanels_IdentificationTrials",
                               style = "default")),
    
    h3("Trial Registration"),
    bsCollapse(id = "methodsPanels_TrialRegistration",
               methods_panel("Prospective registration",
                             
                             "This metric reflects whether a clinical trial was registered before the
                        start date of the study, according to the information given on ClinicalTrials.gov
                        and/or DRKS. Prospective registration makes trial specifications,
                        including primary and secondary outcomes, publicly available before study start,
                        adds transparency and accountability, and helps protect against outcome switching.",
                             
                             "This analysis was limited to trials registered in ClinicalTrials.gov and/or
                             DRKS with a start date given in the registry. To assess whether a
                             study was prospectively registered, we compared the date the study was
                             first submitted to the registry with the start date given in the registry.
                             We defined a trial to be prospectively registered if the trial was registered in the
                             same or a previous month to the trial start date, as some registrations provide
                             only a start month rather than an exact date.",
                             
                             "Trial registration was assessed for clinical trials registered in
                             ClinicalTrials.gov and/or DRKS. We did not evaluate trials in further
                             registries. The data presented relies on the information in registry
                             entries being accurate and complete. Finally, trials without
                             a start date in the registry were excluded from this analysis."),
               
               methods_panel("Reporting of Trial Registration Number (TRN)",
                             
                             HTML("This metric measures how many clinical trials with a journal publication
                             report a trial registration number (TRN) in the abstract and in the
                             full text of the publication. Reporting of TRNs in trial results publications
                             facilitates transparent linking between registration and publication. The <a 
                             href=https://www.sciencedirect.com/science/article/pii/S0140673607618352?via%3Dihub>
                             Consolidated Standards of Reporting Trials (CONSORT)</a>
                             as well as the <a href=http://www.icmje.org/recommendations/>ICMJE Recommendations
                             for the Conduct, Reporting, Editing, and Publication of Scholarly Work in Medical
                             Journals</a> call for reporting <i>&#39trial registration number and name of the
                             trial register&#39</i> in both the full-text and abstract."),
                             
                             HTML('We developed <a href="https://github.com/maia-sh/ctregistries">
                             open source R sripts</a> to detect TRNs. Our regular-expression-based
                             approach searches text strings for matches to TRN patterns for all PubMed-indexed
                             and ICTRP-network registries. More information on this package and its
                             application can be found in this preprint [enter DOI to TRN paper]. This
                             analysis was limited to trials registered in ClinicalTrials.gov and/or DRKS
                             for which a journal publication was found. The analysis was further restricted
                             to publications indexed in PubMed (detection of TRN in abstract) and
                             publications for which we could obtain the full text (detection of TRN in
                             full text).'),
                             
                             HTML("The regular expressions detect any and all TRNs in an abstract and publication and do not distinguish
                             between cases where a TRN is reported as a registration for the publication&#39s
                             study (i.e., clinical trial result) or is otherwise mentioned (i.e., in a review, reference to other clinical trials, etc.).
                             Finally, this analysis was limited to journal publications indexed in PubMed (TRN in abstract)
                             and for which we could obtain the full text (TRN in full text).")),
               
               methods_panel("Linkage of journal publications in the registry",
                             
                             HTML("This metric measures links to the published journal article in clinical trial
                             registry entries. Linking to the publication in the registration make results publication more findable and
                             aids in evidence synthesis."),
                             
                             HTML('This analysis was limited to trials registered in ClinicalTrials.gov and/or
                             DRKS for which a journal publication was found. The analysis was further
                             restricted to publications with a DOI or that are indexed in PubMed. We
                             queried the ClinicalTrials.gov and DRKS APIs (May 2021) to obtain
                             linked publications in these registries. We considered a publication “linked”
                             if the PMID or DOI was included in the trial registration.'),
                             
                             HTML("<i>Registry limitations:</i> ClinicalTrials.gov includes a often-used
                             PMID field for references. In addition, ClinicalTrials.gov automatically
                             indexes publications from PubMed using TRN in the secondary identifier field.
                             In contrast, DRKS includes references as a free-text field, leaving trialists
                             to decide whether to enter any publication identifiers. Finally, this analysis
                             was limited to trials with a journal publication which have a DOI or are
                             indexed in PubMed"))),
    
    h3("Trial Reporting"),
    bsCollapse(id = "methodsPanels_TrialReporting",
               methods_panel("Summary results reporting in EUCTR",
                             
                             HTML("This metric measures how many clinical trials registered in EudraCT and
                             that are due to report results in the EU Clinical Trials Register (EUCTR) have
                             already done so. Interventional clinical trials using investigational medicinal
                             products conducted in the EU/EEA are required to be registered in EudraCT.
                             According to the <a href=https://eur-lex.europa.eu/legal-content/EN/TXT/PDF/?uri=CELEX:52012XC1006(01)&from=EN>
                             Commission guideline 2012/C 302/03</a>, sponsors of these trials are required
                             to provide summary results within 12 months of trial completion. Clinical trials
                             are expensive and have often many contributing patients. Timely dissemination
                             of the trial results is crucial to make the evidence gained in those trials
                             available. Beyond EU-level requirements, the
                             <a href=https://www.who.int/news/item/18-05-2017-joint-statement-on-registration>
                             World Health Organization</a> recommends publishing summary results in the
                             registry within 12 months of trial completion."),
                             
                             HTML('This analysis is limited to trials listed in the
                             <a href="https://eu.trialstracker.net">EU Trials Tracker</a> (and therefore
                             registered in EudraCT) with a sponsor name corresponding to one of the UMCs
                             included in this dashboard. Summary results reporting rates in EUCTR were
                             retrieved from the EU Trials Tracker&#39s (EBM DataLab) 
                             <a href=https://github.com/ebmdatalab/euctr-tracker-data>code repository</a>.
                             For each UMC in our dataset, we searched the corresponding sponsor name in the
                             EU Trials Tracker. With the exception of one UMC (Mannheim), we found at least
                             one sponsor name for each UMC in the EU Trials Tracker. If more than one 
                             corresponding sponsor name was found for a given UMC, we only selected the 
                             sponsor name with the most trials. The list of selected sponsor names can be 
                             found <a href=https://github.com/quest-bih/clinical-dashboard/blob/main/prep/eutt-sponsors-of-interest.csv
                             >here</a>. While the EU Trials Tracker is usually updated on a monthly basis,
                             in some cases there was more than one update within the same month. In these
                             cases, only the latest data point within that month is displayed. Note that
                             some trials registered in EudraCT and captured in this analysis may be
                             cross-registered in ClinicalTrials.gov and/or DRKS. However, this plot
                             displays summary results reporting only in EUCTR as listed in the EU Trials
                                  Tracker.'),
                             
                             "The EU Trials Tracker does not measure for how long trials have been due to
                             report results. For UMCs with more than one corresponding sponsor name in the
                             EU Trials Tracker, some trials may have been missed since we only selected
                             maximum one sponsor name per UMC."),
               
               methods_panel("Results reporting (2-year and 5-year reporting)",
                             
                             HTML("This metric measures how many clinical trials in our dataset that
                             are registered in ClinicalTrials.gov and/or DRKS reported results within
                             2 and 5 years of trial completion as (a) a journal publication and 
                             (b) summary results in the registry. A fast dissemination of trial
                             results is crucial to make the evidence gained in those trials available.
                             The <a href=https://www.who.int/news/item/18-05-2017-joint-statement-on-registration>
                        World Health Organization</a> recommends publishing registry summary results within
                        12 months and a publication within 24 months of trial completion."),
                             
                             HTML('This data is the result of automated and manual searches and was
                             previously published as part of the 
                             <a href=https://www.sciencedirect.com/science/article/abs/pii/S0895435618310631?via%3Dihub>
                             IntoValue 1 study</a> and the follow-up 
                             <a href=https://www.medrxiv.org/content/10.1101/2021.08.05.21261624v2>
                             IntoValue 2 study</a> (available as a preprint). This analysis was limited
                             to trials registered in ClinicalTrials.gov and/or DRKS. Both registries were
                             searched for studies with one of the UMCs as
                             the responsible party/sponsor or with a principal investigator from one of
                             the UMCs. A manual search for published results was done, searching the
                             registry, PubMed, and Google. If multiple results publications were found,
                             the earliest was included. Publication dates were manually entered during
                             publication searches. When calculating the 2-year and 5-year reporting
                             rates, we only considered trials for which we had 2 and 5 years follow-up
                             time since trial completion, respectively. The plot only displays data for
                             completion years with more than 5 trials.'),
                             
                             HTML("Only the earliest evidence of results reporting from trial completion
                             was considered for both reporting of summary results in the registry and
                             as a journal publication. The data presented in this dashboard therefore
                             does not reflect all result publications of a given trial. Moreover, some of
                             the publications may have been missed in the manual search procedure as the
                             search was restricted to a limited number of scientific databases and the 
                             responsible parties were not contacted. Observational clinical studies were
                             not included in this sample. <i>Further registry limitations</i>:
                             ClinicalTrials.gov includes a structured summary results field. In contrast,
                             DRKS includes summary results with other references, and summary results were
                             inferred based on keywords, such as \"Ergebnisbericht\" or \"Abschlussbericht\",
                             in the reference title. The data presented relies on the information in registry
                             entries being accurate and complete."))),
    
    hr(),
    h3("Open Access"),
    bsCollapse(id = "methodsPanels_OpenAccess",
               
               methods_panel("Open Access",
                             
                             "A lot of valuable research, much of which is publicly funded, is hidden
                             behind paywalls. Open Access (OA) makes research articles available online,
                             free of charge and most copyright barriers. The free, public availability of
                             research articles accelerates and broadens the dissemination of research discoveries.
                             OA also enables greater visibility of research and makes it easier to build
                             on existing knowledge. Research funders are increasingly encouraging OA
                             to maximise the value and impact of research discoveries. This metric measures
                             the OA status of publications in our sample.",
                             
                             HTML('This analysis was limited to trials with a journal publication and
                             a DOI. We queried the Unpaywall database via its
                             <a href="https://unpaywall.org/products/api">API</a> to obtain information
                             on the OA status of publications. Publications can have different OA
                             statuses which are color-coded. Gold OA denotes a publication in an
                             OA journal. Green OA denotes a freely available repository version.
                             Hybrid OA denotes an OA publication in a journal which offers
                             both a subscription based model as well as an OA option. Bronze OA denotes
                             publications which are freely available on the journal page, but
                             without a clear open license. These can be articles in a non-OA journal
                             which have been made available voluntarily by the journal,
                             but which might at some stage lose their OA status again. Therefore, we
                             only considered the OA categories Gold, Green, and Hybrid. As publications
                             can have several OA versions (e.g., a gold version
                             in an OA journal as well as a green version
                             in a repository), we defined a hierarchy for categories and
                             for each publication only assigned the category with the highest priority.
                             We used a hierarchy of gold - hybrid - green. A more detailed breakdown
                             of the absolute number of publications across all categories can be
                             visualised by clicking on the toggle next to the plot. \"No data\" refers
                             to publications which could not be resolved in Unpaywall. The plots for
                             this metric on the Start page only display data for years with more
                             than 20 publications.
                        <br>
                        <br>OA status is not fixed but rather changes over time, as repository versions
                        are often made available with a delay. Therefore, the OA percentage for a given
                        year typically rises retrospectively. Thus, the point in time
                        at which the OA status is retrieved is important for the OA percentage. The current
                        OA data was retrieved with <a href="https://github.com/NicoRiedel/unpaywallR">
                             UnpaywallR</a> on: 15/07/2021.'),
                             
                             "Unpaywall only stores information for publications which have a DOI assigned by
                        Crossref. Articles without a Crossref DOI were therefore excluded from the OA analysis.
                             The plot only shows data for publication years with more than 20 publications."),
               
               methods_panel("Realized potential for Green Open Access",
                             
                             HTML("In many cases, journal or publisher self-archiving policies allow researchers
                             to make the accepted or published version of their publication openly
                             accessible in an institutional repository upon publication or after an
                             embargo period (Green OA). This helps broaden the dissemination of research discoveries.
                             However, several factors appear to limit the use of self-archiving: permissions
                             for self-archiving vary based on the <i>version</i> of the publication to be
                             deposited, <i>where</i> the publication is to be deposited, and <i>when</i>
                             it is to be deposited. Moreover, in many cases only the accepted version
                             of the publication can be archived after an embargo period of 6 or 12 months.
                             It can be difficult to retrieve the correct version of the publication after this
                             delay. This metric measures how many paywalled publications with the potential
                             for green OA have been made available via this route."),
                             
                             HTML('This analysis was limited to trials with a journal publication with a DOI.
                             In a first step, we identified publications which are
                             only accessible in a repository (Green OA only). To do so, we queried the
                             Unpaywall API (with <a href="https://github.com/NicoRiedel/unpaywallR">
                             UnpaywallR</a>) with the following hierarchy: gold - hybrid - bronze - green - 
                             closed. In a second step, we identified how many paywalled publications
                             could technically be made openly accessible based on self-archiving permissions.
                             To obtain this information, we queried the
                             <a href="https://openaccessbutton.org/api">Shareyourpaper.org permissions API</a>
                             (OA.Works) which combines publication metadata and policy information to provide
                             permissions. Publications were considered to have the potential for green OA
                             if: (1) a \"best permission\" was found; (2) this permission relates to either
                             the accepted or published version of the publication; (3) this permission
                             relates to archiving in an institutional repository; and (4) the embargo
                             linked to this permission had elapsed (if applicable). We did not consider
                             permissions relating to the submitted version. The Unpaywall database
                             was queried on 15/07/2021. The Shareyourpaper permissions API was queried on
                             23/07/2021. The plots for this metric on the Start page
                             only display data for years with more than 20 publications.'),
                             
                             "Not all queried publications resolved in Unpaywall and ShareYourPaper. We also
                             extracted permissions data only for publications which have a \"best permission\"
                             in the Shareyourpaper.org database. The date at which a publication can be made
                             openly accessible via self-archiving depends on the publication date and the
                             length of the embargo (if any). Therefore, the number of paywalled publications
                             with the potential for green OA will change over time.")),
    
    h3("Dashboard development"),
    bsCollapse(id = "methodsPanels_DashboardDevelopment",
               bsCollapsePanel(strong("Dashboard development"),
                               p(HTML("The dashboard was developed using the Shiny R package
                               (version 1.6.0). The <a href=https://github.com/quest-bih/clinical-dashboard
                                      >underlying code</a> is openly available in GitHub under
                                      an AGPL license and may be adapted for further use."),
                               style = "default"))),
                   
    h3("Tools used for data collection"),
    helpText(HTML('<a href="https://github.com/NicoRiedel/unpaywallR"> UnpaywallR </a>')),
    helpText(HTML('<a href="https://shareyourpaper.org/permissions/about">
                  ShareYourPaper permissions checker API</a> from OA.Works')),
    helpText(HTML('<a href="https://github.com/maia-sh/ctregistries">ctregistries repository</a>')),
    helpText(HTML('<a href="https://eu.trialstracker.net/">EU Trials Tracker </a>'))
)


## Tooltips for Open Science metrics

openaccess_tooltip <- strwrap("This metric shows the percentage of
                              publications that are Open Access (OA). This analysis was
                              limited to trials with a journal publication and a DOI.
                              Publications can have different OA statuses which are color-coded.
                              Gold OA denotes a publication in an OA journal. Green
                              OA denotes a freely available repository version.
                              Hybrid OA denotes an OA publication in a journal
                              which offers both a subscription based model as well
                              as an OA option. As publications can have several
                              OA versions, we defined a hierarchy for categories
                              and for each publication only assigned the category 
                              with the highest priority. Here, we used a hierarchy
                              of gold - hybrid - green. The absolute number of
                              publications and their OA status can be visualised
                              by clicking on the toggle next to the plot. Here,
                              further categories not considered as Open Access
                              in this dashboard are also included. More information
                              can be found in the Methods page.") %>%
    paste(collapse = " ")

lim_openaccess_tooltip <- strwrap("Unpaywall only stores information for publications
                                  which have a DOI assigned by Crossref. Publications
                                  without a Crossref DOI had to be excluded from
                                  the OA analysis. The OA percentage is not a fixed
                                  number, but changes over time as some publications
                                  become accessible with a delay. The current data
                                  was retrieved on: 15/07/2021.")

greenopenaccess_tooltip <- strwrap('This metric measures how many paywalled publications
                            with the potential for green OA have been made available
                            via this route. This analysis was limited to trials
                            with a journal publication and a DOI.
                            In a first step, we identified publications which are
                             only accessible in a repository (Green OA only). To do
                             so, we queried the Unpaywall API  with the following
                             hierarchy: gold - hybrid - bronze - green - 
                             closed. Next, we identified how many paywalled publications
                             could technically be made openly accessible based on
                             self-archiving permissions. We obtained this information
                             by querying the Shareyourpaper.org permissions API (OA.Works).
                             Publications were considered to have the potential
                             for green OA if a \"best permission\" was found for
                             archiving the accepted or published version in an
                             institutional repository, and if the embargo had elapsed
                             (if applicable). Click on the toggle on the left to
                             view the absolute number of paywalled publications and their
                             potential for self-archiving. More information can be
                             found in the Methods page.') %>%
    paste(collapse = " ")

lim_greenopenaccess_tooltip <- strwrap("Not all publications queried were resolved
                                in Unpaywall and ShareYourPaper. We also only extracted
                                permissions data for publications which have a
                                \"best permission\" in the Shareyourpaper.org database.
                                The date at which a publication can be made openly
                                accessible via self-archiving depends on the publication
                                date and the length of the embargo (if any). Therefore,
                                the number of paywalled publications with the potential
                                for green OA will change over time. The Shareyourpaper
                                permissions API was queried on 23/07/2021.")

opendata_tooltip <- strwrap("This metric measures the percentage of screened publications that state
                                that they shared their research data. We used the text-mining algorithm
                                ODDPub to identify publications which share research data.
                                Openly shared data makes research more transparent, as research findings can
                                be reproduced. Additionally, shared datasets can be reused and combined by other
                            scientists to answer new research questions.") %>%

paste(collapse = " ")

lim_opendata_tooltip <- strwrap("This analysis could only be performed on articles for which we could access the full text. ODDPub only finds ~75% of all Open Data publications and finds false positive cases (no manual check of the results). ODDPub also does not verify that the dataset is available and whether it fulfills our definition of Open Data. Finally, Open Data is not relevant for all publications.")

opencode_tooltip <- strwrap("The Open Code metric measures the percentage of screened publications
                             that state that they shared their analysis code. We used the text-mining
                             algorithm ODDPub to identify publications which share analysis code.
                            Like openly shared data, Open Code makes research more transparent, as research
                            findings can be reproduced.") %>%

paste(collapse = " ")

lim_opencode_tooltip <- strwrap("This analysis could only be performed on articles for which we could access the full text. ODDPub only finds ~75% of all publications with Open Code and finds false positive cases (no manual check of the results). ODDPub also does not verify that the code is available and whether it fulfills our definition of Open Code Finally, Open Code is not relevant for all publications.")

## Tooltips for Clinical Trials metrics

trn_tooltip <- strwrap("This metric measures how many clinical trials with a journal publication
                        report a trial registration number (TRN) in the abstract and in the
                        full text of the publication. Reporting of TRNs in related publications
                        facilitates transparent linkage between registration and publication.
                        We developed open source R sripts to detect TRNs using a regular-expression-based
                        approach. This analysis was limited to trials registered in
                        ClinicalTrials.gov and/or DRKS for which a journal publication was found.
                        The analysis was further restricted to publications indexed in PubMed
                        (detection of TRN in abstract) and publications for which we could obtain
                        the full text (detection of TRN in full text). More information can be
                        found in the Methods page.") %>%

paste(collapse = " ")

lim_trn_tooltip <- strwrap(HTML("The regular expressions detect any and all TRNs in an abstract and publication and do not distinguish
                             between cases where a TRN is reported as a registration for the publication&#39s
                             study (i.e., clinical trial result) or is otherwise mentioned (i.e., in a review, reference to other clinical trials, etc.).
                             Finally, this analysis was limited to journal publications indexed in PubMed (TRN in abstract)
                             and for which we could obtain the full text (TRN in full text)."))

linkage_tooltip <- strwrap("This metric measures links to the published journal article in clinical trial
                             registry entries. Linking to the publication in the registration make results
                             publication more findable and aids in evidence synthesis. This analysis was
                             limited to trials registered in ClinicalTrials.gov and/or DRKS for which a
                             journal publication was found. The analysis was further restricted to publications
                             with a DOI or that are indexed in PubMed. We queried the ClinicalTrials.gov and
                             DRKS APIs to obtain linked publications in these registries. We considered a
                             publication “linked” if the PMID or DOI was included in the trial registration.
                             More information can be found in the Methods page.")

lim_linkage_tooltip <- strwrap("ClinicalTrials.gov includes a often-used
                             PMID field for references. In addition, ClinicalTrials.gov automatically
                             indexes publications from PubMed using TRN in the secondary identifier field.
                             In contrast, DRKS includes references as a free-text field, leaving trialists
                             to decide whether to enter any publication identifiers. Finally, this analysis
                             was limited to trials with a journal publication which have a DOI or are
                             indexed in PubMed.")

sumres_tooltip <- strwrap("This metric measures how many clinical trials registered in EudraCT and
                             that are due to report results in the EU Clinical Trials Register (EUCTR) have
                             already done so. Interventional clinical trials using investigational medicinal
                             products conducted in the EU/EEA are required to be registered in EudraCT.
                             Sponsors of these trials are required to provide summary results within 12
                             months of trial completion. Summary results reporting rates in EUCTR were
                             retrieved from the EU Trials Tracker. Thus, the analysis was limited
                             to trials listed in the EU Trials Tracker with a sponsor name corresponding
                             to one of the UMCs presented here. Note that some trials
                             registered in EudraCT and captured in this analysis may be cross-registered
                             in ClinicalTrials.gov and/or DRKS. However, this plot displays summary results
                             reporting only in EUCTR as listed in the EU Trials Tracker. More information
                             can be found in the Methods page.") %>%
    
paste(collapse = " ")

lim_sumres_tooltip <- strwrap("The EU Trials Tracker does not measure for how long trials have been due to
                             report results. For UMCs with more than one corresponding sponsor name in the
                             EU Trials Tracker, some trials may have been missed since we only selected
                             maximum one sponsor name per UMC.")

prereg_tooltip <- strwrap("This metric reflects whether a clinical trial was registered before the
                        start date of the study. Prospective registration makes trial specifications,
                        including primary and secondary outcomes, publicly available before study start,
                        adds transparency and accountability, and helps protect against outcome switching.
                        This analysis was limited to trials registered in
                        ClinicalTrials.gov and/or DRKS with a start date given in the registry. To
                        assess whether a study was prospectively registered, we compared the date
                        the study was first submitted to the registry with the start date given in
                        the registry. We defined a trial to be prospectively registered if the trial
                        was registered in the same or a previous month to the trial start date, as
                          some registrations provide only a start month rather than an exact date.
                          More information can be found in the Methods page.") %>%
    
paste(collapse = " ")

lim_prereg_tooltip <- strwrap("Trial registration was assessed for clinical trials registered in
                             ClinicalTrials.gov and/or DRKS. We did not evaluate trials in further
                             registries. The data presented relies on the information in registry
                             entries being accurate and complete. Finally, trials without
                             a start date in the registry were excluded from this analysis.")

timpub_tooltip2 <- strwrap("This metric measures how many clinical trials in our dataset that
                             reported results within 2 years of trial completion as (a) a
                             journal publication and  (b) summary results in the registry.
                             A fast dissemination of trial results is crucial to make the
                             evidence gained in those trials available. This analysis was
                             limited to trials registered in ClinicalTrials.gov and/or DRKS.
                             Both registries were searched for studies with one of the UMCs as
                             the responsible party/sponsor or with a principal investigator from one of
                             the UMCs. A manual search for published results was done, searching the
                             registry, PubMed, and Google. If multiple results publications were found,
                             only the earliest was included. Publication dates were manually entered during
                             publication searches. When calculating the 2-year reporting
                             rates, we only considered trials for which we had 2 years follow-up
                             time since trial completion. More information can be found in the
                              Methods page.") %>%

paste(collapse = " ")

lim_timpub_tooltip2 <- strwrap("Only the earliest evidence of results reporting from trial completion
                             was considered for both reporting of summary results in the registry and
                             as a journal publication. Thus, the data presented
                             does not reflect all result publications of a given trial. Moreover, some of
                             the publications may have been missed in the manual search procedure as the
                             search was restricted to a limited number of scientific databases and the 
                             responsible parties were not contacted. Observational clinical studies were
                             not included in this sample. The data presented relies on the information
                             in registry entries being accurate and complete.")

timpub_tooltip5 <- strwrap("This metric measures how many clinical trials in our dataset that
                             reported results within 5 years of trial completion as (a) a
                             journal publication and  (b) summary results in the registry.
                             A fast dissemination of trial results is crucial to make the
                             evidence gained in those trials available. This analysis was
                             limited to trials registered in ClinicalTrials.gov and/or DRKS.
                             Both registries were searched for studies with one of the UMCs as
                             the responsible party/sponsor or with a principal investigator from one of
                             the UMCs. A manual search for published results was done, searching the
                             registry, PubMed, and Google. If multiple results publications were found,
                             only the earliest was included. Publication dates were manually entered during
                             publication searches. When calculating the 5-year reporting
                             rates, we only considered trials for which we had 5 years follow-up
                             time since trial completion. The plot only displays data for
                             completion years with more than 5 trials. More information can be found in the
                              Methods page.") %>%

paste(collapse = " ")

lim_timpub_tooltip5 <- strwrap("Only the earliest evidence of results reporting from trial completion
                             was considered for both reporting of summary results in the registry and
                             as a journal publication. Thus, the data presented
                             does not reflect all result publications of a given trial. Moreover, some of
                             the publications may have been missed in the manual search procedure as the
                             search was restricted to a limited number of scientific databases and the 
                             responsible parties were not contacted. Observational clinical studies were
                             not included in this sample. The data presented relies on the information
                             in registry entries being accurate and complete.")

## Tooltips for Robustness metrics

randomization_tooltip <- strwrap("This metric measures how many animal studies report a statement on
                            randomization of subjects into groups. Animal studies were identified using a
                            previously published PubMed search filter. Reporting of randomization was evaluated
                            with SciScore, an automated tool which evaluates research articles based on their
                            adherence to rigour and reproducibility criteria. Only animal studies in English
                            and contained in the PubMed Central corpus (for which we have SciScore data) could
                            be analyzed.") %>%
    
paste(collapse = " ")


blinding_tooltip <- strwrap("This metric measures how many animal studies report a statement on whether
                            investigators were blinded to group assignment and/or outcome assessment. Animal
                            studies were identified using a previously published PubMed search filter. Reporting
                            of blinding was evaluated with SciScore, an automated tool which evaluates research
                            articles based on their adherence to rigour and reproducibility criteria. Only animal studies in English
                            and contained in the PubMed Central corpus (for which we have SciScore data) could
                            be analyzed.") %>%

paste(collapse = " ")


power_tooltip <- strwrap("This metric measures how many animal studies report a statement on sample size
                         calculation. Animal studies were identified using a previously published PubMed search
                         filter. Reporting of sample size calculation was evaluated with SciScore, an automated
                         tool which evaluates research articles based on their adherence to rigour and
                         reproducibility criteria. Only animal studies in English
                            and contained in the PubMed Central corpus (for which we have SciScore data) could
                            be analyzed.") %>%
    
paste(collapse = " ")


                                        # iacuc_tooltip <- strwrap("This metric measures how many animal studies report an Institutional animal care and
#                          use committee statement.") %>%
#     
# paste(collapse = " ")

lim_randomization_tooltip <- strwrap("We did not test the sensitivity and precision of the approach used to identify animal studies in our dataset, nor the data obtained from SciScore. Moreover, we do not have SciScore data for all studies in our publication set. Finally, randomization may not always apply, especially in early-stage exploratory research (hypothesis-generating experiments).")
lim_blinding_tooltip <- strwrap("We did not test the sensitivity and precision of the approach used to identify animal studies in our dataset, nor the data obtained from SciScore. Moreover, we do not have SciScore data for all studies in our publication set. Finally, blinding may not always apply, especially in early-stage exploratory research (hypothesis-generating experiments).")
lim_power_tooltip <- strwrap("We did not test the sensitivity and precision of the approach used to identify animal studies in our dataset, nor the data obtained from SciScore. Moreover, we do not have SciScore data for all studies in our publication set. Finally, sample size calculation may not always apply, especially in early-stage exploratory research (hypothesis-generating experiments).")
