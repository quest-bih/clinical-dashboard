allumc_openaccess_tooltip <- strwrap("This metric shows the percentage of clinical trial
                              publications that are Open Access (OA). This analysis was
                              limited to trials registered in ClinicalTrials.gov
                              or DRKS with a journal publication and a DOI that
                              resolved in Unpaywall. Publications can have
                              different OA statuses which are color-coded.
                              Gold OA denotes a publication in an OA journal. 
                              Hybrid OA denotes an OA publication in a journal
                              which offers both a subscription based model as well
                              as an OA option. Green OA denotes a freely available
                              repository version. Bronze OA denotes publications
                              which are freely available on the journal page, but
                             without a clear open license. As publications can have several
                              OA versions, we defined a hierarchy for categories:
                              gold - hybrid - green - bronze - closed. The absolute
                              number of publications and their OA status can be visualised
                              by clicking on the toggle above the plot. Note that the
                              OA percentage is not fixed but typically rises
                              retrospectively, as some publications become accessible
                              with a delay. Query date: 01/11/2022.")

lim_allumc_openaccess_tooltip <- strwrap("The OA status could only be obtained for publications
                                with a DOI and which resolved in Unpaywall. We did not
                                perform a manual check of the OA data.")

allumc_greenoa_tooltip <- strwrap("This metric shows the percentage of paywalled trial publications
                            that have been made openly accessible in a repository (green OA). This
                            analysis was limited to trials registered in ClinicalTrials.gov
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
                             20/02/2022. More information can be
                             found in the Methods page.")

lim_allumc_greenoa_tooltip <- strwrap("The OA status and self-archiving permission could
                                only be obtained for publications with a DOI and which
                                resolved in Unpaywall and Shareyourpaper.org. We only
                                considered the \"best permission\" in Shareyourpaper.
                                We did not perform a manual check of self-archiving permissions.")

allumc_opendata_tooltip <- strwrap("The Open Data metric measures the percentage of publications in English and for
                            which the full text could be screened that mention sharing of data.
                            Openly shared data makes research more transparent, as research findings can be
                            reproduced. Additionally, shared datasets can be reused and combined by other
                            scientists to answer new research questions.")

lim_allumc_opendata_tooltip <- strwrap("This analysis could only be performed on articles for which we could access the full text. ODDPub only finds ~75% of all Open Data publications and finds false positive cases (no manual check of the results). ODDPub also does not verify that the dataset is available and whether it fulfills our definition of Open Data. Finally, Open Data is not relevant for all publications.")

allumc_opencode_tooltip <- strwrap("The Open Code metric measures the percentage of publications in English and for
                            which the full text could be screened that mention sharing of code.
                            Like openly shared data, Open Code makes research more transparent, as research
                            findings can be reproduced.")

lim_allumc_opencode_tooltip <- strwrap("This analysis could only be performed on articles for which we could access the full text. ODDPub only finds ~75% of all publications with Open Code and finds false positive cases (no manual check of the results). ODDPub also does not verify that the code is available and whether it fulfills our definition of Open Code Finally, Open Code is not relevant for all publications.")

allumc_clinicaltrials_trn_tooltip <- strwrap("This metric reflects how many clinical trials with a journal publication
                        report a trial registration number (TRN) in the abstract and in the
                        full text of the publication. Reporting of TRNs in related publications
                        facilitates transparent linkage between registration and publication.
                        We developed open source R sripts to detect TRNs using a regular-expression-based
                        approach. This analysis was limited to trials registered in
                        ClinicalTrials.gov or DRKS for which a journal publication was found.
                        The analysis was further restricted to publications indexed in PubMed
                        (detection of TRN in abstract) and publications for which we could obtain
                        the full text (detection of TRN in full text). Select whether to view TRN
                        reporting in the publication abstract and/or full text using the drop-down menu. 
                        More information can be found in the Methods page.")

lim_allumc_clinicaltrials_trn_tooltip <- strwrap("This analysis was limited to journal publications indexed in PubMed
                            (TRN in abstract) and for which we could obtain the full text (TRN in full text).")

allumc_linkage_tooltip <- strwrap("This metric shows the percentage of clinical trials with a results publication
                            that have a link to this publication in the registry entry. Linking to the publication
                            in the registration make results
                             publication more findable and aids in evidence synthesis. This analysis was
                             limited to trials registered in ClinicalTrials.gov or DRKS for which a
                             journal publication was found. The analysis was further restricted to publications
                             with a DOI or that are indexed in PubMed. We used automated methods to download
                             the relevant fields from ClinicalTrials.gov and DRKS. We considered a
                             publication “linked” if the PMID or DOI was included in the trial registration.
                             Select the registry of interest can be selected in the drop-down menu. More
                                  information can be found in the Methods page.")

lim_allumc_linkage_tooltip <- strwrap("ClinicalTrials.gov includes an often-used
                             PMID field for references. In addition, ClinicalTrials.gov automatically
                             indexes publications from PubMed using TRN in the secondary identifier field.
                             In contrast, DRKS includes references as a free-text field, leaving it up to
                             trialists to enter publication identifiers. Finally, this analysis
                             was limited to trials with a journal publication which have a DOI or are
                             indexed in PubMed.")

allumc_clinicaltrials_sumres_tooltip <- strwrap("This metric displays the percentage of due trials that have
                             reported summary results in the registry. A timely dissemination of trial
                             results is crucial to make the evidence gained in those trials available.
                             Select to view summary results reporting for trials registered in either the
                             EUCTR, ClinicalTrials.gov, or DRKS by selecting the registry in the drop-down menu. The WHO recommends publishing
                             summary results in the registry within 12 months of trial completion. 
                             Interventional clinical trials using investigational medicinal products
                             conducted in the EU/EEA are required to be registered in EudraCT and 
                             provide summary results within 12 months of trial completion.
                             A semi-automated approach was used to detect summary results reporting
                             in ClinicalTrials.gov and DRKS. Summary results reporting in the EUCTR
                             were retrieved from the EU Trials Tracker. 
                             More information can be found in the Methods page.")

lim_allumc_clinicaltrials_sumres_tooltip <- strwrap("<i>Summary results reporting in the EUCTR</i>: this analysis was limited
                            to trials listed in the EU Trials Tracker with a sponsor name corresponding
                            to one of the UMCs included in this dashboard. If more than one corresponding
                            sponsor name was found for a given UMC, we only selected the sponsor name
                            with the most trials. Thus, some trials may have been missed for these UMCs.
                              <i>Summary results reporting in DRKS</i>: in the absence of structured field
                              in the registry, we detected summary results based on the presence on keywords
                              in the reference title. We did not perform a manual review of these results.")

allumc_clinicaltrials_prereg_tooltip <- strwrap("This metric reflects whether a clinical trial was
                            prospectively registered (i.e., registered before the start of the trial).
                            Prospective registration
                            makes trial specifications, including primary and secondary outcomes,
                            publicly available before study start, adds transparency and accountability,
                            and helps protect against outcome switching. This analysis was limited to
                            trials registered in ClinicalTrials.gov or DRKS with a start date
                            given in the registry. The registry of interest can be selected in the 
                            drop-down menu. We defined a
                            trial to be prospectively registered if the trial was registered in the
                            same or a previous month to the trial start date, as some registrations
                            provide only a start month rather than an exact date. More information can
                                                be found in the Methods page.")

lim_allumc_clinicaltrials_prereg_tooltip <- strwrap("This data depends on registry entries being
                                accurate and complete. Trials
                             without a start date in the registry were excluded from this analysis.")

allumc_clinicaltrials_timpub_tooltip5a <- strwrap("This metric shows the percentage of clinical trials
                            that reported results within 5 years of trial completion as (a) a manuscript
                            publication, and b) summary results in the registry. Select the reporting
                            route of interest in the drop-down menu. A fast dissemination of trial
                             results is crucial to make the evidence gained in those trials available.
                             This analysis was limited to trials registered in ClinicalTrials.gov or DRKS. 
                             <i>Results reporting as summary results in the registry</i>: we extracted this
                             information from ClinicalTrials.gov and DRKS via automated methods.
                             <i>Results reporting as a manuscript publication</i>: a manual search for published results
                             was conducted, searching the registry, PubMed, and Google. If multiple results
                             publications were found, only the earliest was included. Thus, the data presented
                             does not reflect all submitted results or publications of a given trial. 
                             Publication dates were manually entered during publication searches.
                             When calculating the 5-year reporting rates, we only
                             considered trials for which we had 5 years follow-up time since trial completion. 
                            More information can be found in the Methods page.")

lim_allumc_clinicaltrials_timpub_tooltip5a <- strwrap("<i>Results reporting as summary results in the registry</i>: in the
                            absence of structured field in DRKS, we detected summary results in this
                            registry based on the presence on keywords in the
                             reference title. We did not perform a manual review of these results. The
                             data presented relies on the information in registry entries being accurate
                               and complete. <i>Results reporting as a manuscript publication</i>: some of
                               the publications may have
                             been missed in the manual search procedure as the search was restricted to
                             a limited number of scientific databases and the 
                             responsible parties were not contacted.")

allumc_clinicaltrials_timpub_tooltip <- strwrap("This metric shows the percentage of clinical trials that
                            reported results within 2 years of trial completion as (a) a manuscript publication,
                            and b) summary results in the registry. Select the reporting route of
                            interest in the drop-down menu. A fast dissemination of trial results
                            is crucial to make the evidence gained in those trials available. This analysis was
                             limited to trials registered in ClinicalTrials.gov or DRKS. <i>Results reporting
                             as summary results in the registry</i>: we extracted this
                             information from ClinicalTrials.gov and DRKS via automated methods.
                             <i>Results reporting as a manuscript publication</i>: a manual search for published results
                             was conducted, searching the registry, PubMed, and Google. If multiple
                             results publications were found, only the earliest was included. Thus, the data presented
                             does not reflect all submitted results or publications of a given trial. Publication
                             dates were manually entered during publication searches. When calculating the
                             2-year reporting rates, we only considered trials for which we had 2 years
                             follow-up time since trial completion. More information can be found in the Methods page.")

lim_allumc_clinicaltrials_timpub_tooltip <- strwrap("<i>Results reporting as summary results in the registry</i>: in the
                            absence of structured field in DRKS, we detected summary results in this
                            registry based on the presence on keywords in the
                             reference title. We did not perform a manual review of these results. The
                             data presented relies on the information in registry entries being accurate
                               and complete. <i>Results reporting as a manuscript publication</i>: some of
                               the publications may have
                             been missed in the manual search procedure as the search was restricted to
                             a limited number of scientific databases and the 
                             responsible parties were not contacted.")

allumc_animal_rando_tooltip <- strwrap("This metric measures how many animal studies report a statement on
                            randomization of subjects into groups. Animal studies were identified using a
                            previously published PubMed search filter. Reporting of randomization was evaluated
                            with SciScore, an automated tool which evaluates research articles based on their
                            adherence to rigour and reproducibility criteria. Only publications in the
                            PubMed Central corpus and which could be analyzed by SciScore are were included
                            in this analysis.")

lim_allumc_animal_rando_tooltip <- strwrap("We did not test the sensitivity and precision of the approach used to identify animal studies in our dataset, nor the data obtained from SciScore. Moreover, we do not have SciScore data for all studies in our publication set. Finally, randomization may not always apply, especially in early-stage exploratory research (hypothesis-generating experiments).")



allumc_animal_blind_tooltip <- strwrap("This metric measures how many animal studies report a statement on whether
                            investigators were blinded to group assignment and/or outcome assessment. Animal
                            studies were identified using a previously published PubMed search filter. Reporting
                            of blinding was evaluated with SciScore, an automated tool which evaluates research
                            articles based on their adherence to rigour and reproducibility criteria. Only
                            publications in the PubMed Central corpus and which could be analyzed by SciScore
                            are were included in this analysis.")

lim_allumc_animal_blind_tooltip <- strwrap("We did not test the sensitivity and precision of the approach used to identify animal studies in our dataset, nor the data obtained from SciScore. Moreover, we do not have SciScore data for all studies in our publication set. Finally, blinding may not always apply, especially in early-stage exploratory research (hypothesis-generating experiments).")

allumc_animal_power_tooltip <- strwrap("This metric measures how many animal studies report a statement on sample size
                         calculation. Animal studies were identified using a previously published PubMed search
                         filter. Reporting of sample size calculation was evaluated with SciScore, an automated
                         tool which evaluates research articles based on their adherence to rigour and
                         reproducibility criteria. Only publications in the PubMed Central corpus and which
                         could be analyzed by SciScore are were included in this analysis.")

lim_allumc_animal_power_tooltip <- strwrap("We did not test the sensitivity and precision of the approach used to identify animal studies in our dataset, nor the data obtained from SciScore. Moreover, we do not have SciScore data for all studies in our publication set. Finally, sample size calculation may not always apply, especially in early-stage exploratory research (hypothesis-generating experiments).")

#allumc_animal_iacuc_tooltip <- strwrap("This metric ...")

## Define the page layout
all_umcs_page <- tabPanel(
    "All UMCs", value = "tabAllUMCs",
    wellPanel(
        br(),
        fluidRow(
            column(
                12,
                h1(
                    style = "margin-left: 0",
                    strong("Dashboard for clinical trial transparency: All UMCs"),
                    align = "left"
                ),
                h4(
                    style = "margin-left: 0",
                    "This dashboard displays the performance of University Medical
                    Centers (UMCs) in Germany on established registration and
                    reporting practices for clinical trial transparency. On
                    this page, you can view the data for all UMCs
                    side-by-side. More detailed information on the underlying
                    methods can be found in the methods and limitations widgets
                    next to each plot, and in the Methods page."
                ),
                h4(style = "margin-left:0cm",
                   "The dashboard was developed as part of a scientific research
                   project with the overall aim to support the adoption of responsible
                   research practices at UMCs. The dashboard is a pilot and continues
                       to be updated. More metrics may be added in the future."),
                br()
            )
        )
    ),
    uiOutput("allumc_registration"),
    uiOutput("allumc_reporting"),
    uiOutput("allumc_openscience"),
    bsCollapsePanel(strong("Impressum"),
                    impressum_text,
                    style = "default"),
    bsCollapsePanel(strong("Datenschutz"),
                    datenschutz_text,
                    style = "default")
)
