faq_page <- tabPanel(
    "FAQ",
    value = "tabFAQ",
    h2("Frequently Asked Questions"),
    bsCollapse(id = "faqPanels_About",
               bsCollapsePanel(strong("What is this dashboard about?"),
                               p(HTML("This dashboard for clinical research
                                      transparency was developed as part of a
                                      scientific research project [@DELWEN: I think this first sentence addresses a separate question, e.g., how was this dashboard developed? or some better wording. I would also include the grant number and maybe more details about the underlying/instigating projects]
                                      This dashboard aims to support the adoption of
                                      responsible research practices at
                                      University Medical Centers (UMCs). It
                                      displays baseline [@DELWEN: why baseline?] assessments of select
                                      practices for clinical research
                                      transparency at UMCs in Germany. The
                                      dashboard allows institutions to assess
                                      how they are performing in relation to 
                                      mandates or their institutional policy
                                      and identify key areas of improvement.
                                      The underlying data also informs interventions to
                                      increase the uptake of clinical
                                      transparency practices and evaluate their
                                      impact over time.")),
                               value = "faqPanels_About",
                               style = "default")),
    bsCollapse(id = "faqPanels_RegistryFocus",
               bsCollapsePanel(strong("Why does the dashboard focus on ClinicalTrials.gov, DRKS, and EUCTR?"),
                               p(HTML("The data displayed in this dashboard is
                                      based on two previously developed cohorts
                                      of clinical trials registered in
                                      ClinicalTrials.gov and the German Clinical
                                      Trials Register (DRKS) [@DELWEN: add citation? or link to another page of dashboard?]. The EU Clinical
                                      Trials Register (EUCTR) is a primary
                                      registry in the WHO Registry Network [@DELWEN: all 3 are part of the ICTRP Registry Network, with EUCTR and DRKS as primary registries and ct.gov as a data provider. I would start this section stating all 3 are ICTRP registries and commonly used for Germany. Then go into EUCTR as legally required one. Then explain our DRKS/CT.gov sample and explicitly acknowledge that most metrics just for these 2 because that's how our source data was done. And maybe this will change in a future version???]
                                      provides information on interventional
                                      clinical trials on medicines conducted in 
                                      the European Economic Area (EEA) started
                                      after 1 May 2004. These trials are
                                      required [@DELWEN: legally required? mandated? not sure what wording] to be registered in the EU
                                      clinical trials database and provide
                                      summary results in the EUCTR within 12
                                      months of trial completion (see <a href=https://eur-lex.europa.eu/legal-content/EN/TXT/PDF/?uri=CELEX:52012XC1006(01)&from=EN>
                                      Commission guideline 2012/C 302/03</a>).
                                      The <a href=https://eu.trialstracker.net/>EU Trials Tracker</a>
                                      (EBM DataLab) is an interactive website
                                      which tracks reporting rates in the EUCTR.")),
                               value = "faqPanels_RegistryFocus",
                               style = "default")),
    bsCollapse(id = "faqPanels_TrialTypes",
               bsCollapsePanel(strong("What types of trials are included in this dashboard?"),
                               p(HTML("Interventional trials registered in
                                    ClinicalTrials.gov or DRKS, conducted at
                                      a German UMC, completed between 2009 – 2017,
                                      and whose study status is considered \"complete.\" [@DELWEN: adding 'considered' since technically some other statuses are included in intovalue if i'm not remembering wrong] Trials
                                      may be cross-registered (these trials may
                                      be counted once for each registry). [@DELWEN: Nico says IV was deduplicated, but I know that at least some duplicate/cross-reg still in for both, so softened the verb.]
                                      <br> [@DELWEN: maybe clarify explicitly not just germany legal trials and that may be industry sponsored but included as long as UMC PI]
                                      <br><b>For prospective registration
                                      (ClinicalTrials.gov only)</b>, we used a more
                                      recent cohort of trials registered in
                                      ClinicalTrials.gov, conducted at a German
                                      UMC, started between 2006 and 2018, and
                                      whose study status is considered \"complete.\"
                                      <br>
                                      <br><b>For summary results reporting in EUCTR</b>,
                                      we extracted the data from the <a href=https://eu.trialstracker.net>
                                      EU Trials Tracker</a>. We searched the
                                      EU Trials Tracker for trials with a sponsor
                                      name corresponding to UMCs included in this
                                      dashboard.")),
                               value = "faqPanels_TrialTypes",
                               style = "default")),
    bsCollapse(id = "faqPanels_AllPublicationsOfTrial",
               bsCollapsePanel(strong("What results publications of a given clinical trial are reflected in the dashboard?"),
                               p(HTML("Publications associated with the trials
                                      included in this dashboard were
                                      identified through manual searches. If
                                      several results publications were found
                                      for a given trial, only the earliest, or the one reporting a primary outcome, was
                                      included. The manual searches are described
                                      in more detail <a href=https://doi.org/10.1016/j.jclinepi.2019.06.002>here</a>
                                      and <a href=https://www.medrxiv.org/content/10.1101/2021.08.05.21261624v2>here</a>.
                                      While the original dataset also
                                      considered dissertations as publications,
                                      only journal publications are
                                      included in this dashboard.")),
                               value = "faqPanels_AllPublicationsOfTrial",
                               style = "default")),
    bsCollapse(id = "faqPanels_SelectionPractices",
               bsCollapsePanel(strong("Why were these practices selected?"),
                               p(HTML("In a previous study, we conducted
                                      stakeholder interviews on an institutional
                                      dashboard with metrics for responsible
                                      research (see <a href=https://www.medrxiv.org/content/10.1101/2021.09.16.21263493v1.supplementary-material>
                                      preprint</a>). One of the lessons learned
                                      in this study was the importance of an
                                      overall narrative that justified the choice
                                      of metrics included. [@DELWEN: these first two sentences seem out of place, I would remove...unless we selected metrics based on the interviews... which isn't the case] This dashboard focuses
                                      on practices for clinical trial registration
                                      and reporting that are recommended or
                                      required by ethical or regulatory bodies.
                                      In the <b>“Why these metrics?”</b> page [@DELWEN: add link to page?], you can
                                      find an infographic which contextualizes
                                      included research practices to relevant
                                      regulations and ethical guidelines.")),
                               value = "faqPanels_SelectionPractices",
                               style = "default")),
    bsCollapse(id = "faqPanels_CTIS",
               bsCollapsePanel(strong("How is this dashboard relevant given the upcoming launch of EU Clinical Trials Information System?"),
                               p(HTML("The European Commission has confirmed the
                                      launch of the EU Clinical Trials Information
                                      System (CTIS) at the end of January 2022,
                                      when the <a href=https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=celex%3A32014R0536>
                                      EU Clinical Trials Regulation</a> comes
                                      into application. CTIS will serve as a
                                      single-entry point for clinical trial
                                      information in the EU. Sponsors will still
                                      be required to submit summary results of
                                      clinical trials to the EU database within
                                      one year of trial completion. The EU
                                      Clinical Trials Regulation will undoubtedly
                                      lead to changes in the way clinical trials
                                      are conducted in the EU. However, most of
                                      the practices in this dashboard are
                                      recommended by international bodies
                                      (e.g., World Health Organization) and
                                      ethical guidelines (e.g., Declaration of
                                      Helsinki). In our view, there is still
                                      value in raising awareness of practices
                                      that increase the transparency of clinical
                                      research, even if the underlying administrative
                                      procedures are subject to change. The
                                      dashboard also provides baseline assessments
                                      that allow the impact of interventions or
                                      changes in policy to be evaluated.[@DELWEN: would also not that the dashboard is mostly not EUCTR CTIMP trials and hence unaffected.]")),
                               value = "faqPanels_CTIS",
                               style = "default")),
    bsCollapse(id = "faqPanels_MoreMethods",
               bsCollapsePanel(strong("Where can I find more about the underlying methods and limitations?"),
                               p(HTML("The data displayed in this dashboard
                               results from a combination of manual and automated
                               approaches. Where possible, we used or built on
                               existing methods and are linked below. All the data and code are
                               openly available. 
                               Assumptions and decisions are noted in the documentation of the underlying methods as well as in the dashboard and should be considered when interpreting the data.
                               Each plot in the dashboard contains
                               two widgets that inform on 1)
                               methods used to obtain the data displayed, and
                               2) limitations. More details on
                               this as well as information on how the trials were
                               identified can be found in the Methods page [@DELWEN: link?].
                               <br>
                               <br>More information on the development of trial
                               cohorts displayed in this dashboard can be found
                               in the <a href=https://doi.org/10.1016/j.jclinepi.2019.06.002>
                               IntoValue1</a> publication and the follow-up
                               <a href=https://www.medrxiv.org/content/10.1101/2021.08.05.21261624v2>
                               IntoValue2 preprint</a>. We used the <a href=https://zenodo.org/record/5141343#.YV2m-S0RqRs>
                               original dataset</a> of these studies as basis
                               and included updated registry data as well as
                               additional information on associated results
                               publications. All data processing steps are
                               available and documented in <a href=https://github.com/maia-sh/intovalue-data>GitHub</a>.
                               More details on the methods to detect trial and
                               publication linkage can be found in this
                               <a href=https://www.medrxiv.org/content/10.1101/2021.08.23.21262478v1>preprint</a>
                               and in <a href=https://github.com/maia-sh/reg-pub-link>GitHub</a>.
                               The dashboard was developed with Shiny and the
                               underlying code is openly available in <a href=https://github.com/quest-bih/clinical-dashboard>
                               GitHub</a>.
                               <br>
                               <br>This dashboard was shaped by expert interviews
                               with different stakeholders on an institutional
                               dashboard with metrics for responsible research,
                               which you can find out more about in this
                               <a href=https://www.medrxiv.org/content/10.1101/2021.09.16.21263493v1.supplementary-material>
                               preprint</a>. We also conducted a review of
                               relevant UMC policies for mentions of indicators
                               of robust and transparent research and mentions
                               of more traditional metrics, which you can read
                               about in this <a href=https://www.researchsquare.com/article/rs-871675/v1>
                               preprint</a>.
")),
                               value = "faqPanels_MoreMethods",
                               style = "default")),
    bsCollapse(id = "faqPanels_Updates",
               bsCollapsePanel(strong("How will the dashboard be maintained and updated?"),
                               p(HTML("The data displayed in this dashboard is
                                      based on two previously developed cohorts
                                      of clinical trials and associated results
                                      publications. The development of these
                                      cohorts involved extensive manual searches
                                      and checks, making it difficult to update
                                      the dashboard on regular basis. However,
                                      a follow-up assessment of UMC’s progress
                                      is planned for the future.")),
                               value = "faqPanels_Updates",
                               style = "default")),
    bsCollapse(id = "faqPanels_Contact",
               bsCollapsePanel(strong("How to contact us"),
                               p(HTML("Send us an e-mail at responsible-metrics[at]charite.de!")),
                               value = "faqPanels_Contact",
                               style = "default")),
)

