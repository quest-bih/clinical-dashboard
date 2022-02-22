methods_page <- tabPanel(
    "Methods", value = "tabMethods",
    h1("Methods"),
    
    h4(HTML('This dashboard displays the performance of University
                       Medical Centers (UMCs) in Germany on established registration
                       and reporting practices for clinical research transparency.
                       The dashboard displays data for interventional
                       clinical trials conducted at German UMCs, registered in
                       ClinicalTrials.gov or the German Clinical Trials Registry
                       (DRKS), and reported as complete between 2009 - 2017. For
                       summary results reporting, we additionally included trials
                       conducted at German UMCs and registered in the EU Clinical
                       Trials Register (EUCTR). The dashboard was developed as part
                       of a scientific research project with the overall aim to support
                       the adoption of responsible research practices at UMCs.')),
                       
    h4(HTML('You can find more information on our methods for individual metrics
    by extending the panels below. You can also find a list of tools used for data
            collection at the bottom of this page. The <i>Trial Characteristics</i>
            page provides an overview of the characteristics of trials included
            in the dashboard. The <i>FAQ</i> and <i>Why these practices?</i> pages provide
            more general information about this dashboard and our selection of practices.')),
    
    h4(style = "margin-left:0cm; color: purple",
       HTML("More information on the overall aim and methodology can be
                       found in the publication asssociated with this dashboard
            [enter DOI]. ")),
    
    h3("Identification of clinical trials"),
    bsCollapse(id = "methodsPanels_IdentificationTrials",
               bsCollapsePanel(strong("Identification of clinical trials"),
                               p(HTML("The data displayed in this dashboard are
                               based on 3 data sources with the following inclusion
                               and exclusion criteria:<br>
                               <br>1. The <b>\"IntoValue\"</b> cohort of registered
                               clinical trials and associated results. This cohort consists
                               of interventional clinical trials registered in
                               ClinicalTrials.gov or DRKS (German Clinical Trials
                               Register), conducted
                               at a German UMC (i.e., led either as sponsor,
                               responsible party, or as host of the principal
                               investigator), and considered as \"complete\" between 2009
                               and 2017 per the registry status. In line with WHO and ICMJE
                               definitions, trials include all interventional
                               studies and are not limited to Clinical Trials of
                               an Investigational Medicinal Product that are regulated by
                               the EU's Clinical Trials Directive or Germany's
                               drug or medical device laws. Results publications of
                               trials in this cohort were identified through a manual
                               search. More information on how this cohort was developed
                               can be found in the <a href=https://doi.org/10.1016/j.jclinepi.2019.06.002>
                               original</a> and <a href=https://doi.org/10.1016/j.jclinepi.2021.12.012>
                               follow-up</a> study.
                               
                               The IntoValue dataset was adapted in the following ways
                               for the development of this dashboard: (1) we extracted updated
                               registry data from ClinicalTrials.gov and DRKS on 15
                               August 2021; (2) the date of summary results posting in
                               DRKS was extracted manually from the registry
                               using the registry's change history; (3)
                               we included additional information on the reporting
                               of trial registration numbers in trial results
                               publications, publication links in the registry,
                               and Open Access; (4) while the original IntoValue
                               dataset considered both journal publications and
                               dissertations as results publications, we focused
                               on journal publications in this dashboard. More
                               information on how the IntoValue dataset was adapted
                               for use in this dashboard can be found in the
                               <a href=https://github.com/maia-sh/intovalue-data>
                               associated code repository in GitHub</a>. Three German UMCs
                               (Augsburg, Bielefeld, and Oldenburg) were founded after
                               the start of data collection. In this cohort,
                               Kiel and Lübeck are represented as a single UMC
                               (Schleswig-Holstein).<br>
                                
                            <br>2. <b>Prospective registration in ClinicalTrials.gov</b>: 
                                      this assessment was based on a more recent cohort of
                                      interventional trials registered in ClinicalTrials.gov,
                                      conducted at a German UMC, started between 2006 and 2018,
                                      and considered as \"complete\" per the study
                                      status in the registry. We downloaded updated
                                      registry data for the trials in this cohort on
                                      6 October 2021. In this cohort, Kiel and Lübeck are
                                      represented as a single UMC (Schleswig-Holstein)<br>
                                      
                            <br>3. <b>Summary results reporting in the EUCTR</b>: this
                            assessment was based on the
                            <a href=https://eu.trialstracker.net>EU Trials Tracker</a>.
                            We searched the EU Trials Tracker for sponsor names
                            corresponding to included UMCs (August 2021). If more than one
                            corresponding sponsor name was found for a given UMC, we
                            selected the sponsor with the most trials.")),
                               value = "methodsPanels_IdentificationTrials",
                               style = "default")),
    
    h3("Trial Registration"),
    bsCollapse(id = "methodsPanels_TrialRegistration",
               methods_panel("Prospective registration",
                             
                             "How many clinical trials were prospectively registered (i.e., registered
                             before the start date of the study). Prospective registration makes trial
                             specifications, including primary and
                             secondary outcomes, publicly available before study start, adds transparency
                             and accountability, and helps protect against outcome switching.",
                             
                             "This analysis was limited to trials registered in ClinicalTrials.gov or
                             DRKS with a start date given in the registry. We used 2 data sources: 
                             1) For prospective registration in DRKS, we included trials in the \"IntoValue\"
                             cohort registered in DRKS (interventional, conducted at a German UMC, considered
                             as complete per the study status in the registry, and with a completion date
                             between 2009 – 2017); 2) For prospective registration in ClinicalTrials.gov,
                             we used a recent cohort of interventional trials registered in ClinicalTrials.gov
                             (interventional, conducted at a German UMC, considered as complete per the study
                             status in the registry, and started between 2006 and 2018). To assess
                             whether a study was prospectively registered,
                             we compared the date the study was first submitted to the registry with the
                             start date given in the registry. We defined a trial to be prospectively
                             registered if the trial was registered in the same or a previous month to the
                             trial start date, as some registrations provide only a start month rather than
                             an exact date. Note for the One UMC page: in case there were no trials for a
                             given UMC and completion year (denominator = 0),
                             the data point for this completion year is omitted in the plot.",
                             
                             "This data depends on registry entries being accurate and complete. Trials
                             without a start date in the registry were excluded from this analysis."),
               
               methods_panel("Reporting of Trial Registration Number (TRN)",
                             
                             HTML("How many clinical trials with a results publication report the
                             trial registration number (TRN) in the abstract and in the
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
                             application can be found in this <a href=https://www.medrxiv.org/content/10.1101/2021.08.23.21262478v1>
                             preprint</a>. This analysis was limited to trials in the IntoValue dataset
                             (registered in ClinicalTrials.gov or DRKS) for which a journal publication
                             was found. The analysis was further restricted to publications indexed in
                             PubMed (detection of TRN in abstract) or publications for which we could
                             obtain the full text (detection of TRN in full text).'),
                             
                             HTML("This analysis was limited to trials with a journal publication indexed
                                in PubMed (detection of TRN in abstract) or for which we could obtain the
                                full text (detection of TRN in full text).")),
               
               methods_panel("Publication links in the registry",
                             
                             HTML("How many clinical trials with a results publication have a link to
                                this publication in the registry. Linking to the publication in
                                the registration make results publication more findable and
                             aids in evidence synthesis."),
                             
                             HTML('This analysis was limited to trials in the IntoValue dataset (registered
                                in ClinicalTrials.gov or DRKS) for which a journal publication was found. The analysis was further
                             restricted to publications with a DOI or that are indexed in PubMed. We
                             considered a publication “linked” if the PubMed IDentifier (PMID) or DOI was
                             included in the trial registration. We extracted the relevant fields from ClinicalTrials.gov
                             and DRKS using automated methods (ClinicalTrials.gov: via its API;
                             DRKS: custom-built web scraper; August 2021) and used regular expressions
                             to extract publication identifiers (DOIs and PMIDs) from these fields.
                             More information on this approach can be found in this
                             <a href=https://www.medrxiv.org/content/10.1101/2021.08.23.21262478v1>preprint</a>.
                             Note for the One UMC page: in case there were no trials (or associated publications)
                             for a given UMC and completion year (denominator = 0), the data point
                             for this completion year is omitted in the plot.'),
                             
                             HTML("This analysis was limited to trials with a journal publication which
                             have a DOI or PMID (i.e., are indexed in PubMed). Publications
                             included in the registration without a PMID or DOI (i.e., publication title
                             and/or URL only) may have been missed.
                             <i>Registry limitations:</i> ClinicalTrials.gov includes an often-used
                             PMID field for references. In addition, ClinicalTrials.gov automatically
                             indexes publications from PubMed using TRNs in the secondary identifier field.
                             In contrast, DRKS includes references as a free-text field, leaving it up to
                                  trialists to enter publication identifiers."))),
    
    h3("Trial Reporting"),
    bsCollapse(id = "methodsPanels_TrialReporting",
               methods_panel("Summary results reporting",
                             
                             HTML("How many due clinical trials reported summary results in the registry.
                                Clinical trials are expensive and often involve many contributing patients.
                                Timely dissemination of trial results is crucial to make the evidence gained
                                in those trials available. The
                             <a href=https://www.who.int/news/item/18-05-2017-joint-statement-on-registration>
                             World Health Organization</a> recommends publishing summary results in the
                             registry within 12 months of trial completion. <i>Summary results reporting
                             in the EUCTR</i>: Clinical Trials of
                               an Investigational Medicinal Product conducted in the EU/EEA are
                             required to be registered in EudraCT. According to the
                             <a href=https://eur-lex.europa.eu/legal-content/EN/TXT/PDF/?uri=CELEX:52012XC1006(01)&from=EN>
                             Commission guideline 2012/C 302/03</a>, sponsors of these trials are required
                             to provide summary results within 12 months of trial completion. Select to view
                             summary results reporting for trials registered in either the EUCTR,
                                  ClinicalTrials.gov, or DRKS by selecting the registry in the drop-down menu."),
                             
                             HTML('<i>Summary results reporting in ClinicalTrials.gov and DRKS (IntoValue dataset)</i>:
                                summary results posting was extracted from ClinicalTrials.gov and DRKS via
                                  automated methods. ClinicalTrials.gov includes a structured summary
                                  results field. In contrast, DRKS includes summary results with other
                                  references. In the absence of a structured summary results field in
                                  DRKS, we detected summary results in this registry based on the presence
                                  of keywords (e.g., Ergebnisbericht or Abschlussbericht) in the reference
                                  title. The summary results date in DRKS was extracted manually from the
                                  registry’s change history (which indicates when the summary result was
                                  uploaded). <i>Summary results reporting in the EUCTR</i>: this analysis was limited
                             to trials listed in the <a href="https://eu.trialstracker.net">EU Trials Tracker</a>
                             (and therefore registered in EudraCT) with a sponsor name corresponding to one of
                             the included UMCs and due to report summary results. For each UMC in our dataset,
                             we searched the corresponding sponsor name in the EU Trials Tracker (August 2021).
                             With the exception of one UMC (Mannheim), we found at least one sponsor name for
                             each UMC in the EU Trials Tracker. If more than one corresponding sponsor name
                             was found for a given UMC, we selected the sponsor with the most trials on the
                             EUCTR. Selected sponsor names can be found <a href=https://github.com/quest-bih/clinical-dashboard/blob/main/prep/eutt-sponsors-of-interest.csv
                             >here</a>. We retrieved the relevant data (percent reported, total number of due
                             trials, and total number of trials that reported results) from historical
                             versions of the EU Trials Tracker&#39s (EBM DataLab) 
                             <a href=https://github.com/ebmdatalab/euctr-tracker-data>code repository</a>
                             (latest data extracted on 18 February 2022). While the EU Trials Tracker is
                             usually updated monthly, in some cases there was more than one update within
                             the same month. In these cases, only the latest data point within that month
                             was displayed. Note that some trials registered in EudraCT and captured in
                             this analysis may be cross-registered in ClinicalTrials.gov and/or DRKS.'),
                             
                             HTML("<i>Summary results reporting in DRKS</i>: in contrast to
                                  ClinicalTrials.gov, DRKS does not include a structured summary
                                  results field but includes summary results with other references.
                                  We detected summary results in DRKS based on the presence of
                                  keywords (e.g., Ergebnisbericht or Abschlussbericht) in the reference
                                  title. We did not perform a manual review of these results.
                                  <i>Summary results reporting in the EUCTR</i>: we did not find a
                                  corresponding sponsor name in the EU Trials Tracker for all included
                                  UMCs. Several UMCs had more than one corresponding sponsor name in
                                  the EU Trials Tracker (Bochum, Giessen, Heidelberg, Kiel, Marburg,
                                  and Tübingen). Since we only selected the sponsor with the most
                                  trials on the EUCTR, some trials may have been missed for these
                                  UMCs.")),
               
               methods_panel("Results reporting (2-year and 5-year reporting)",
                             
                             HTML("How many clinical trials reported results within 2 and 5
                             years of trial completion as (a) a journal publication, and b) summary results
                             in the registry. A fast dissemination of trial
                             results is crucial to make the evidence gained in those trials available.
                             The <a href=https://www.who.int/news/item/18-05-2017-joint-statement-on-registration>
                        World Health Organization</a> recommends publishing registry summary results within
                        12 months and a publication within 24 months of trial completion. Here, we considered
                        2 years as timely reporting for both reporting routes."),
                             
                             HTML('This analysis was limited to trials in the IntoValue dataset
                                (registered in ClinicalTrials.gov or DRKS). <i>Results reporting as
                                summary results in the registry</i>: Summary results posting was extracted
                                from ClinicalTrials.gov and DRKS via automated methods. ClinicalTrials.gov
                                includes a structured summary results field. In contrast, DRKS includes
                                summary results with other references. In the absence of a structured summary
                                results field in DRKS, we detected summary results in this registry based on
                                the presence of keywords (e.g., Ergebnisbericht or Abschlussbericht) in the
                                reference title. The summary results date in DRKS was extracted manually from
                                the registry’s change history (which indicates when the summary result was
                                  uploaded). <i>Results reporting
                                as a journal publication</i>: this data was previously obtained as
                                part of the <a href=https://doi.org/10.1016/j.jclinepi.2019.06.002>
                             IntoValue 1 study</a> and the follow-up 
                             <a href=https://www.sciencedirect.com/science/article/pii/S0895435621004145>
                             IntoValue 2 study</a>. A manual search for published results was performed,
                             searching the registry, PubMed, and Google. If multiple results publications were found,
                             the earliest was included. The data presented in this dashboard therefore
                             does not reflect all result publications of a given trial. Publication dates
                             were manually entered during publication searches.<br>
                             <br><b>When calculating the 2-year and 5-year reporting
                             rates (summary results), we only included trials for which we had 2 and 5 years
                             follow-up time from trial completion to the registry download date, respectively. When
                             calculating the 2-year and 5-year reporting rates (journal publication), we only
                             included trials for which we had 2 and 5 years follow-up time from trial completion
                             to the manual search date, respectively</b>. The plot only displays data for completion
                             years with more than 5 trials. Note for the One UMC page: in case there were no trials
                             for a given UMC and completion year (denominator = 0), the data point for this
                             completion year is omitted in the plot.'),
                             
                             HTML("<i>Results reporting as summary results in the registry</i>:
                                ClinicalTrials.gov includes a structured summary results field. In contrast,
                             DRKS includes summary results with other references, and summary results were
                             inferred based on keywords, such as \"Ergebnisbericht\" or \"Abschlussbericht\",
                             in the reference title. The data presented relies on the information in registry
                             entries being accurate and complete. <i>Results reporting as a journal
                             publication</i>: The manual searches for trial results publications in the
                                  IntoValue 1 cohort (trials completed between 2009 – 2013) were performed
                                  between July 2017 and December 2017. The manual searches for trial results
                                  publications in the IntoValue 2 cohort (trials completed between 2014 – 2017)
                                  were performed between July 2020 and September 2020. Trial results
                                  publications published after these manual searches were conducted would
                                  have been missed. Furthermore, some publications may have been missed in the
                                  manual search procedure as the search was restricted to a limited number of
                                  scientific databases and the responsible parties were not contacted."))),
    
    hr(),
    h3("Open Access"),
    bsCollapse(id = "methodsPanels_OpenAccess",
               
               methods_panel("Open Access",
                             
                             "How many results publications of clinical trials are openly accessible.
                             A lot of valuable research, much of which is publicly funded, is hidden
                             behind paywalls. Open Access (OA) makes research articles available online,
                             free of charge and most copyright barriers. The free, public availability of
                             research articles accelerates and broadens the dissemination of research discoveries.
                             OA also enables greater visibility of research and makes it easier to build
                             on existing knowledge. Research funders are increasingly encouraging OA
                             to maximise the value and impact of research discoveries.",
                             
                             HTML('This analysis was limited to trials in the IntoValue dataset (registered
                                in ClinicalTrials.gov or DRKS) with a journal publication. Since a DOI is
                                needed to query Unpaywall, this analysis was further limited to publications
                                with a DOI. The publication date from Unpaywall was used to display the
                                data over time. Therefore, this analysis was also limited to publications
                                with a publication date in Unpaywall. Using the publication DOIs, we
                                queried the Unpaywall database via its
                             <a href="https://unpaywall.org/products/api">API</a> using the
                             <a href="https://github.com/NicoRiedel/unpaywallR">UnpaywallR R package</a> to
                             obtain information
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
                             visualised by clicking on the toggle above the plot. The plots for
                             this metric on the Start page only display data for years with more
                             than 20 publications.
                        <br>
                        <br>OA status is not fixed but rather changes over time, as repository versions
                        are often made available with a delay. Therefore, the OA percentage for a given
                        year typically rises retrospectively. Thus, the point in time
                        at which the OA status is retrieved is important for the OA percentage. The latest
                        OA data was retrieved with UnpaywallR on 20 February 2022.'),
                             
                             "The OA status could only be obtained for publications with a DOI and
                             which resolved in Unpaywall. We did not perform a manual check of the OA data."),
               
               methods_panel("Realized potential of green Open Access for paywalled publications",
                             
                             HTML("How many paywalled publications with the potential to be archived
                             in a repository have been made openly accessible via this route.
                             In many cases, journal or publisher self-archiving policies allow researchers
                             to make the accepted or published version of their publication openly
                             accessible in an institutional repository upon publication or after an
                             embargo period (green OA). This helps broaden the dissemination of research discoveries.
                             However, several factors appear to limit the use of self-archiving: permissions
                             for self-archiving vary based on the <i>version</i> of the publication to be
                             deposited, <i>where</i> the publication is to be deposited, and <i>when</i>
                             it is to be deposited. Moreover, in many cases only the accepted version
                             of the publication can be archived after an embargo period of 6 or 12 months.
                             It can be difficult to retrieve the correct version of the publication after this
                             delay. Click on the toggle to view absolute numbers (light green shows the number
                             of publications currently behind a paywall that have a permission for self-archiving
                             in an institutional repository)."),
                             
                             HTML('This analysis was limited to trials in the IntoValue dataset (registered
                                in ClinicalTrials.gov or DRKS) with a journal publication and a DOI. The
                                publication date from Unpaywall was used to display the data over
                             time. Therefore, this analysis was also limited to publications with a
                             publication date in Unpaywall. In the first step, we identified publications
                             which are
                             only accessible in a repository (Green OA only). To do so, we queried Unpaywall
                             via its API using the <a href="https://github.com/NicoRiedel/unpaywallR">
                             UnpaywallR R package</a>) with the following hierarchy: gold - hybrid - bronze - green - 
                             closed. In the second step, we identified how many paywalled publications
                             could technically be made openly accessible based on self-archiving permissions.
                             We obtained article-level self-archiving permissions by querying
                             Shareyourpaper.org (OA.Works) via its
                             <a href="https://openaccessbutton.org/api">API</a>.
                             Shareyourpaper combines publication metadata and policy information to provide
                             permissions. Publications were considered to have the potential for green OA
                             if: (1) a \"best permission\" was found; (2) this permission relates to either
                             the accepted or published version of the publication; (3) this permission
                             relates to archiving in an institutional repository; and (4) the embargo
                             linked to this permission had elapsed (if applicable). We did not consider
                             permissions relating to the submitted version. The date at which a
                             publication can be made openly accessible via self-archiving depends on
                             the publication date and the length of the embargo (if any). Therefore,
                             the number of paywalled publications with the potential for green OA will
                             change over time. The Unpaywall database and the Shareyourpaper permissions
                             API were queried on 20 February 2022. The plots for this metric on the Start page
                             only display data for years with more than 20 publications.'),
                             
                             "Not all queried publications resolved in Unpaywall and ShareYourPaper.
                             Self-archiving permissions data was only extracted for publications with
                             a known \"best permission\" in the Shareyourpaper.org database. We did
                             not perform a manual check of self-archiving permissions.")),
    
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
    helpText(HTML('<a href="https://eu.trialstracker.net/">EU Trials Tracker </a>')),
    bsCollapsePanel(strong("Impressum"),
                    impressum_text,
                    style = "default"),
    bsCollapsePanel(strong("Datenschutz"),
                    datenschutz_text,
                    style = "default")
)


## Tooltips for Open Science metrics

openaccess_tooltip <- strwrap("This metric shows the percentage of clinical trial
                              publications that are Open Access (OA). This analysis was
                              limited to trials registered in ClinicalTrials.gov
                              or DRKS with a journal publication and a DOI that
                              resolved in Unpaywall. Publications can have
                              different OA statuses which are color-coded.
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
                              by clicking on the toggle above the plot. Here,
                              further categories not considered as Open Access
                              in this dashboard are also included. Note that the
                              OA percentage is not fixed but typically rises
                              retrospectively, as some publications become accessible
                              with a delay. Query date: 20/02/2022. Start page: only
                              publication years with more than 20 publications are shown.
                              More information can be found in the Methods page.") %>%
    paste(collapse = " ")

lim_openaccess_tooltip <- strwrap("The OA status could only be obtained for publications
                                with a DOI and which resolved in Unpaywall. We did not
                                perform a manual check of the OA data.")

greenopenaccess_tooltip <- strwrap('This metric shows the percentage of paywalled trial publications
                            that have been made openly accessible in a repository (green OA).
                            Click on the toggle to view absolute
                            numbers (light green shows the number of publications currently behind a
                            paywall that have a permission for self-archiving in an institutional
                            repository). This analysis was
                              limited to trials registered in ClinicalTrials.gov
                              or DRKS with a journal publication and a DOI that
                              resolved in Unpaywall. In the first step, we queried the Unpaywall API to identify
                            publications that are only accessible in a repository (Green OA only).
                            Next, we queried Shareyourpaper.org (OA.Works) via its API to obtain
                            self-archiving permissions of paywalled publications. The date at
                            which a publication can be made openly accessible via self-archiving
                            depends on the publication date and the length of the embargo
                             (if any). Therefore, the number of paywalled publications
                             with the potential for green OA will change over time.
                             The Shareyourpaper permissions API was queried on
                             20/02/2022. Start page: only publication years with more than
                             20 publications are shown. More information can be
                             found in the Methods page.') %>%
    paste(collapse = " ")

lim_greenopenaccess_tooltip <- strwrap("The OA status and self-archiving permission could
                                only be obtained for publications with a DOI and which
                                resolved in Unpaywall and Shareyourpaper.org. We only
                                considered the \"best permission\" in Shareyourpaper.
                                We did not perform a manual check of self-archiving permissions.")

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
                        ClinicalTrials.gov or DRKS for which a journal publication was found.
                        The analysis was further restricted to publications indexed in PubMed
                        (detection of TRN in abstract) and publications for which we could obtain
                        the full text (detection of TRN in full text). More information can be
                        found in the Methods page.") %>%

paste(collapse = " ")

lim_trn_tooltip <- strwrap(HTML("This analysis was limited to journal publications indexed in PubMed
                            (TRN in abstract) and for which we could obtain the full text (TRN in full text)."))

linkage_tooltip <- strwrap("This metric shows the percentage of clinical trials with a results publication
                            that have a link to this publication in the registry entry. Linking to the
                            publication in the registration make results
                             publication more findable and aids in evidence synthesis. This analysis was
                             limited to trials registered in ClinicalTrials.gov or DRKS for which a
                             journal publication was found. The analysis was further restricted to publications
                             with a DOI or that are indexed in PubMed. We used automated methods to download
                             the relevant fields from ClinicalTrials.gov and DRKS. We considered a
                             publication “linked” if the PMID or DOI was included in the trial registration.
                             Select the registry of interest can be selected in the drop-down menu.
                             More information can be found in the Methods page.")

lim_linkage_tooltip <- strwrap("ClinicalTrials.gov includes an often-used
                             PMID field for references. In addition, ClinicalTrials.gov automatically
                             indexes publications from PubMed using TRN in the secondary identifier field.
                             In contrast, DRKS includes references as a free-text field, leaving it up to
                             trialists to enter publication identifiers. Finally, this analysis
                             was limited to trials with a journal publication which have a DOI or are
                             indexed in PubMed.")

sumres_tooltip <- strwrap("This metric displays the cumulative percentage of due trials that have
                             reported summary results in the registry. A timely dissemination of trial
                             results is crucial to make the evidence gained in those trials available.
                             Select to view summary results reporting for trials registered in either the
                             EUCTR, ClinicalTrials.gov, or DRKS by selecting the registry in the drop-down menu. The WHO recommends
                             publishing summary results in the registry within 12 months of trial completion. 
                             Interventional clinical trials using investigational medicinal products
                             conducted in the EU/EEA are required to be registered in EudraCT and 
                             provide summary results within 12 months of trial completion.
                             A semi-automated approach was used to detect summary results reporting
                             in ClinicalTrials.gov and DRKS. Summary results reporting in the EUCTR
                             were retrieved from the EU Trials Tracker. 
                             More information can be found in the Methods page.") %>%
    
paste(collapse = " ")

lim_sumres_tooltip <- strwrap("<i>Summary results reporting in the EUCTR</i>: this analysis was limited
                            to trials listed in the EU Trials Tracker with a sponsor name corresponding
                            to one of the UMCs included in this dashboard. If more than one corresponding
                            sponsor name was found for a given UMC, we only selected the sponsor name
                            with the most trials. Thus, some trials may have been missed for these UMCs.
                              <i>Summary results reporting in DRKS</i>: in the absence of structured field
                              in the registry, we detected summary results based on the presence on keywords
                              in the reference title. We did not perform a manual review of these results.")

prereg_tooltip <- strwrap("This metric reflects whether a clinical trial was prospectively registered
                        (i.e., registered before the start of the trial).
                            Prospective registration makes trial specifications,
                        including primary and secondary outcomes, publicly available before study start,
                        adds transparency and accountability, and helps protect against outcome switching.
                        This analysis was limited to trials registered in ClinicalTrials.gov or DRKS
                        with a start date given in the registry. The registry of interest can be selected
                        in the drop-down menu.
                        We defined a trial to be prospectively registered if the trial was registered
                        in the same or a previous month to the trial start date, as some registrations
                        provide only a start month rather than an exact date. More information can be
                          found in the Methods page.") %>%
    
paste(collapse = " ")

lim_prereg_tooltip <- strwrap("This data depends on registry entries being accurate and complete. Trials
                             without a start date in the registry were excluded from this analysis.")

timpub_tooltip2 <- strwrap("This metric shows the percentage of clinical trials that reported results within
                             2 years of trial completion as (a) a journal publication, and b) summary results
                             in the registry. Select the reporting route of interest in the drop-down menu.
                             A fast dissemination of trial results is crucial to make the evidence gained in
                             those trials available.
                             This analysis was limited to trials registered in ClinicalTrials.gov or DRKS. 
                             <i>Results reporting as summary results in the registry</i>: we extracted this
                             information from ClinicalTrials.gov and DRKS via automated methods.
                             <i>Results reporting as a journal publication</i>: a manual search for
                             published results was conducted, searching the registry, PubMed, and Google.
                             If multiple results publications were found, only the earliest was included.
                             Thus, the data presented does not reflect all submitted results or publications
                             of a given trial.
                             Publication dates were manually entered during publication searches.
                             When calculating the 2-year reporting rates, we only
                             considered trials for which we had 2 years follow-up time since trial completion. 
                             More information can be found in the Methods page.") %>%

paste(collapse = " ")

lim_timpub_tooltip2 <- strwrap("<i>Results reporting as summary results in the registry</i>: in the
                            absence of structured field in DRKS, we detected summary results in this
                            registry based on the presence on keywords in the
                             reference title. We did not perform a manual review of these results. The
                             data presented relies on the information in registry entries being accurate
                               and complete. <i>Results reporting as a journal publication</i>: some of
                               the publications may have
                             been missed in the manual search procedure as the search was restricted to
                             a limited number of scientific databases and the 
                             responsible parties were not contacted.")

timpub_tooltip5 <- strwrap("This metric shows the percentage of clinical trials that reported results within
                             5 years of trial completion as (a) a journal publication, and b) summary results
                             in the registry. Select the reporting route of interest in the drop-down menu.
                             A fast dissemination of trial
                             results is crucial to make the evidence gained in those trials available.
                             This analysis was limited to trials registered in ClinicalTrials.gov or DRKS.
                             <i>Results reporting as summary results in the registry</i>: we extracted this
                             information from ClinicalTrials.gov and DRKS via automated methods.
                             <i>Results reporting as a journal publication</i>: a manual search for published results
                             was conducted, searching the
                             registry, PubMed, and Google. If multiple results publications were found,
                             only the earliest was included. Thus, the data presented does not reflect
                             all submitted results or publications of a given trial. Publication dates
                             were manually entered during publication searches. When calculating the
                             5-year reporting rates, we only considered trials for which we had 5 years
                             follow-up time since trial completion. The plot only displays data for
                             completion years with more than 5 trials across all UMCs. More information
                           can be found in the Methods page.") %>%

paste(collapse = " ")

lim_timpub_tooltip5 <- strwrap("<i>Results reporting as summary results in the registry</i>: in the
                            absence of structured field in DRKS, we detected summary results in this
                            registry based on the presence on keywords in the
                             reference title. We did not perform a manual review of these results. The
                             data presented relies on the information in registry entries being accurate
                               and complete. <i>Results reporting as a journal publication</i>: some of
                               the publications may have
                             been missed in the manual search procedure as the search was restricted to
                             a limited number of scientific databases and the 
                             responsible parties were not contacted.")

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
