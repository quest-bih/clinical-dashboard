faq_page <- tabPanel(
    "FAQ",
    value = "tabFAQ",
    h2("Frequently Asked Questions"),
    bsCollapse(id = "faqPanels_Development",
               bsCollapsePanel(strong("How was this dashboard developed?"),
                               p(HTML("This dashboard for clinical research
                                      transparency was developed as part of a
                                      scientific research project conducted at
                                      the QUEST Center for Responsible Research
                                      (Berlin Institute of Health at Charité - 
                                      Universitätsmedizin Berlin) and funded by the
                                      Federal Ministry of Education and Research
                                      (BMBF 01PW18012). The dashboard builds on
                                      a previous <a href=https://doi.org/10.1016/j.jclinepi.2019.06.002>
                                      research project</a> that assessed results
                                      dissemination of clinical trials conducted
                                      at German University Medical Centers (UMCs).")),
                               value = "faqPanels_Development",
                               style = "default")),
    bsCollapse(id = "faqPanels_About",
               bsCollapsePanel(strong("What is this dashboard about?"),
                               p(HTML("This dashboard aims to support the adoption of
                                      responsible research practices at
                                      University Medical Centers (UMCs). It
                                      displays assessments of select
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
                               p(HTML("The EU Clinical Trials Register (EUCTR),
                               ClinicalTrials.gov, and the German Clinical Trials
                               Register (DRKS) are part of the ICTRP Registry Network
                               and are commonly used for Germany.<br>
                               <br>
                               The EUCTR provides
                               information on interventional clinical trials on
                               medicines conducted in the European Economic Area
                               (EEA) started after 1 May 2004. These trials are
                               required to be registered in the EU clinical trials
                               database and provide summary results in the EUCTR
                               within 12 months of trial completion
                               (see <a href=https://eur-lex.europa.eu/legal-content/EN/TXT/PDF/?uri=CELEX:52012XC1006(01)&from=EN>
                               Commission guideline 2012/C 302/03</a>). The
                               <a href=https://eu.trialstracker.net/>EU Trials Tracker</a>
                               (EBM DataLab) is an interactive website which tracks
                               reporting rates in the EUCTR. Only one metric in
                               the dashboard relates to the EUCTR (summary results
                               reporting in the EUCTR).<br>
                               <br>
                               All other metrics are based
                               on two previously generated cohorts of interventional
                               clinical trials completed at German UMCs and registered
                               in ClinicalTrials.gov or DRKS. These cohorts are
                               referred to as the <a href=https://zenodo.org/record/5141343#.YV2m-S0RqRs>
                               'IntoValue' dataset </a>. More information on how
                               these cohorts were generated can be found in the
                               <a href=https://doi.org/10.1016/j.jclinepi.2019.06.002>
                               IntoValue1 publication</a> and follow-up
                               <a href=https://www.medrxiv.org/content/10.1101/2021.08.05.21261624v2>
                               IntoValue2 preprint</a>. Trials registered in other
                               registries may be incorporated in the future.")),
                               value = "faqPanels_RegistryFocus",
                               style = "default")),
    bsCollapse(id = "faqPanels_TrialTypes",
               bsCollapsePanel(strong("What types of trials are included in this dashboard?"),
                               p(HTML("Interventional clinical trials registered in
                                    ClinicalTrials.gov or DRKS, conducted at
                                      a German UMC, completed between 2009 – 2017,
                                      and whose study status is considered \"complete.\".
                                      Trials may be cross-registered across registries. Trials
                                      include all interventional studies and are
                                      not limited to investigational medicinal
                                      products trials regulated by the EU's
                                      Clinical Trials Directive or Germany's
                                      Arzneimittelgesetz (AMG) or Novelle des
                                      Medizinproduktegesetzes (MPG). A combination
                                      of automated methods and a manual
                                      review was used to identify trials conducted
                                      at German UMCs. Trials with an industry sponsor
                                      were also included, providing a German UMC
                                      was listed under `sponsors`, `overall officials`, or
                                      `responsible parties` (ClinicalTrials.gov), or
                                      `any addresses` (DRKS). More details can be
                                      found in the
                                      <a href=https://doi.org/10.1016/j.jclinepi.2019.06.002>
                                      IntoValue1 publication</a> and follow-up
                                      <a href=https://www.medrxiv.org/content/10.1101/2021.08.05.21261624v2>
                                      IntoValue2 preprint</a>.
                                      <br>
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
    bsCollapse(id = "faqPanels_ApplicableAllTrials",
               bsCollapsePanel(strong("Do all metrics apply to all trials?"),
                               p(HTML("No. First, the data displayed in this dashboard
                                      is based on three different samples of trials:
                                      1) IntoValue 1 & 2 cohorts (all metrics except
                                      summary results reporting in EUCTR), 2) trials
                                      in the EU Trials Tracker (summary results reporting
                                      in the EUCTR), and 3) updated sample for prospective
                                      registration in ClinicalTrials.gov. Second, some
                                      metrics only apply to certain trials. For example,
                                      the prospective registration metric
                                      applies to all trials in our sample (all trials
                                      included in the dashboard are registered in a
                                      registry). In contrast, reporting of a trial
                                      registration number in the publication full-text
                                      only applies to trials with a publication and for
                                      which we could obtain the full-text. You can
                                      find the denominator used for each metric in
                                      the relevant section of the Methods page
                                      [TODO: ADD LINK].")),
                               value = "faqPanels_ApplicableAllTrials",
                               style = "default")),
    bsCollapse(id = "faqPanels_SelectionPractices",
               bsCollapsePanel(strong("Why were these practices selected?"),
                               p(HTML("This dashboard focuses on practices
                                      for clinical trial registration and
                                      reporting that are recommended or
                                      required by ethical or regulatory bodies.
                                      In the <b>“Why these metrics?”</b> page [TODO: ADD LINK],
                                      you can find an infographic which contextualizes
                                      included research practices to relevant
                                      regulations and ethical guidelines.")),
                               value = "faqPanels_SelectionPractices",
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
    bsCollapse(id = "faqPanels_UpToDate",
               bsCollapsePanel(strong("Does the dashboard show the most recent data from ClinicalTrials.gov, DRKS, and the EU Trials Tracker?"),
                               p(HTML("We extracted updated registry data from
                                      ClinicalTrials.gov and DRKS for trials in
                                      the ‘IntoValue’ cohort on <b>15 August 2021</b>.
                                      <br>
                                      <br>For the more recent cohort of trials
                                      included for prospective registration in
                                      ClinialTrials.gov, we extracted updated
                                      registry data from ClinicalTrials.gov
                                      on <b>6 October 2021</b>.<br>
                                      <br>For summary results reporting in the
                                      EUCTR, we extracted data from the EU Trials
                                      Tracker on <b>18 August 2021</b>.")),
                               value = "faqPanels_UpToDate",
                               style = "default")),
    bsCollapse(id = "faqPanels_MoreMethods",
               bsCollapsePanel(strong("Where can I find more about the underlying methods and limitations?"),
                               p(HTML("The data displayed in this dashboard
                               results from a combination of manual and automated
                               approaches. Where possible, we used or built on
                               existing methods that are linked below. All the data
                               and code are openly available. Assumptions and decisions
                               are noted in the documentation of the underlying
                               methods as well as in the dashboard, and should be
                               considered when interpreting the data. Each plot in
                               the dashboard contains two widgets that inform on 1)
                               methods used to obtain the data displayed, and
                               2) limitations. More details on this as well as
                               information on how the trials were identified can
                               be found in the Methods page [TODO: ADD LINK].
                               <br>
                               <br>More information on the development of trial
                               cohorts displayed in this dashboard can be found
                               in the <a href=https://doi.org/10.1016/j.jclinepi.2019.06.002>
                               IntoValue1 publication</a> and the follow-up
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
                                      procedures are subject to change. Moreover,
                                      the majority of trials included in the dashboard
                                      is not medicinal products trials regulated by
                                      the EU's Clinical Trials Regulation. Finally, the
                                      dashboard also provides baseline assessments
                                      that allow the impact of interventions or
                                      changes in policy to be evaluated.")),
                               value = "faqPanels_CTIS",
                               style = "default")),
    bsCollapse(id = "faqPanels_Contact",
               bsCollapsePanel(strong("How to contact us"),
                               p(HTML("Send us an e-mail at responsible-metrics[at]charite.de!")),
                               value = "faqPanels_Contact",
                               style = "default")),
)

