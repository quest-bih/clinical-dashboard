allumc_openaccess_tooltip <- strwrap("This metric shows the percentage of
                              publications that are Open Access (OA). This analysis was
                              limited to trials with a journal publication and a DOI
                              that were resolved in Unpaywall.
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
                              can be found in the Methods page.")

lim_allumc_openaccess_tooltip <- strwrap("Unpaywall only stores information for publications
                                  which have a DOI assigned by Crossref. Publications
                                  without a Crossref DOI had to be excluded from
                                  the OA analysis. The OA percentage is not a fixed
                                  number, but changes over time as some publications
                                  become accessible with a delay. The current data
                                  was retrieved on: 15/07/2021.")

allumc_greenoa_tooltip <- strwrap("This metric measures how many paywalled publications
                            with the potential for green OA have been made available
                            via this route. This analysis was limited to trials
                            with a journal publication and a DOI that were resolved
                            in Unpaywall. In a first step, we identified publications which are
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
                             found in the Methods page.")

lim_allumc_greenoa_tooltip <- strwrap("Not all publications in our dataset were resolved
                                in Unpaywall and ShareYourPaper. We also only extracted
                                permissions data for publications which have a
                                \"best permission\" in the Shareyourpaper.org database.
                                The date at which a publication can be made openly
                                accessible via self-archiving depends on the publication
                                date and the length of the embargo (if any). Therefore,
                                the number of paywalled publications with the potential
                                for green OA will change over time. The Shareyourpaper
                                permissions API was queried on 23/07/2021.")

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

allumc_clinicaltrials_trn_tooltip <- strwrap("This metric measures how many clinical trials with a journal publication
                        report a trial registration number (TRN) in the abstract and in the
                        full text of the publication. Reporting of TRNs in related publications
                        facilitates transparent linkage between registration and publication.
                        We developed open source R sripts to detect TRNs using a regular-expression-based
                        approach. This analysis was limited to trials registered in
                        ClinicalTrials.gov and/or DRKS for which a journal publication was found.
                        The analysis was further restricted to publications indexed in PubMed
                        (detection of TRN in abstract) and publications for which we could obtain
                        the full text (detection of TRN in full text). More information can be found in the
                              Methods page.")

lim_allumc_clinicaltrials_trn_tooltip <- strwrap("The regular expressions detect any and all TRNs in an abstract and publication and do not distinguish
                             between cases where a TRN is reported as a registration for the publication&#39s
                             study (i.e., clinical trial result) or is otherwise mentioned (i.e., in a review, reference to other clinical trials, etc.).
                             Finally, this analysis was limited to journal publications indexed in PubMed (TRN in abstract)
                             and for which we could obtain the full text (TRN in full text).")

allumc_linkage_tooltip <- strwrap("This metric measures links to the published journal article in clinical trial
                             registry entries. Linking to the publication in the registration make results
                             publication more findable and aids in evidence synthesis. This analysis was
                             limited to trials registered in ClinicalTrials.gov and/or DRKS for which a
                             journal publication was found. The analysis was further restricted to publications
                             with a DOI or that are indexed in PubMed. We queried the ClinicalTrials.gov and
                             DRKS APIs to obtain linked publications in these registries. We considered a
                             publication “linked” if the PMID or DOI was included in the trial registration.
                                  More information can be found in the Methods page.")

lim_allumc_linkage_tooltip <- strwrap("ClinicalTrials.gov includes a often-used
                             PMID field for references. In addition, ClinicalTrials.gov automatically
                             indexes publications from PubMed using TRN in the secondary identifier field.
                             In contrast, DRKS includes references as a free-text field, leaving trialists
                             to decide whether to enter any publication identifiers. Finally, this analysis
                             was limited to trials with a journal publication which have a DOI or are
                             indexed in PubMed.")

allumc_clinicaltrials_sumres_tooltip <- strwrap("This metric measures how many clinical trials registered in EudraCT and
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
                             can be found in the Methods page.")

lim_allumc_clinicaltrials_sumres_tooltip <- strwrap("The EU Trials Tracker does not measure for how long trials have been due to
                             report results. For UMCs with more than one corresponding sponsor name in the
                             EU Trials Tracker, some trials may have been missed since we only selected
                             maximum one sponsor name per UMC.")

allumc_clinicaltrials_prereg_tooltip <- strwrap("This metric reflects whether a clinical trial was registered before the
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
                          More information can be found in the Methods page.")

lim_allumc_clinicaltrials_prereg_tooltip <- strwrap("Trial registration was assessed for clinical trials registered in
                             ClinicalTrials.gov and/or DRKS. We did not evaluate trials in further
                             registries. The data presented relies on the information in registry
                             entries being accurate and complete. Finally, trials without
                             a start date in the registry were excluded from this analysis.")

allumc_clinicaltrials_timpub_tooltip5a <- strwrap("This metric measures how many clinical trials in our dataset that
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
                              Methods page.")

lim_allumc_clinicaltrials_timpub_tooltip5a <- strwrap("Only the earliest evidence of results reporting from trial completion
                             was considered for both reporting of summary results in the registry and
                             as a journal publication. Thus, the data presented
                             does not reflect all result publications of a given trial. Moreover, some of
                             the publications may have been missed in the manual search procedure as the
                             search was restricted to a limited number of scientific databases and the 
                             responsible parties were not contacted. Observational clinical studies were
                             not included in this sample. The data presented relies on the information
                             in registry entries being accurate and complete.")

allumc_clinicaltrials_timpub_tooltip <- strwrap("This metric measures how many clinical trials in our dataset that
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
                              Methods page.")

lim_allumc_clinicaltrials_timpub_tooltip <- strwrap("Only the earliest evidence of results reporting from trial completion
                             was considered for both reporting of summary results in the registry and
                             as a journal publication. Thus, the data presented
                             does not reflect all result publications of a given trial. Moreover, some of
                             the publications may have been missed in the manual search procedure as the
                             search was restricted to a limited number of scientific databases and the 
                             responsible parties were not contacted. Observational clinical studies were
                             not included in this sample. The data presented relies on the information
                             in registry entries being accurate and complete.")

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
                    strong("Dashboard for clinical research transparency: All UMCs"),
                    align = "left"
                ),
                h4(
                    style = "margin-left: 0",
                    "This dashboard provides an overview of the performance of UMCs
                    in Germany on a set of practices relating to clinical research
                    transparency. On this page, you can view the data for all UMCs
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
    ## uiOutput("allumc_robustness")
)
