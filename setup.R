library(GenomicDataCommons)


projects <- GenomicDataCommons::projects() %>%
  GenomicDataCommons::filter(program.name == "TCGA") %>%
  GenomicDataCommons::facet(c("name", "project_id")) %>%
  results(size = 100)

tcga_project_ids <- projects$project_id

projects_info <- projects() %>%
  GenomicDataCommons::filter(project_id %in% tcga_project_ids) %>%
  results_all()

diseases_types <- unique(rapply(projects$disease_type, function(x) head(x, 30)))

primary_sites <- unique(rapply(projects$primary_site, function(x) head(x, 30)))

cases_pre_info <- cases() %>%
  GenomicDataCommons::filter(project.project_id %in% tcga_project_ids) %>%
  results_all()

cases_info <- GenomicDataCommons::cases() %>%
  GenomicDataCommons::filter(project.project_id %in% tcga_project_ids) %>%
  GenomicDataCommons::facet(c(
    "project.project_id",
    "demographic.race",
    "demographic.gender",
    "demographic.ethnicity",
    "demographic.vital_status",
    "diagnoses.primary_diagnosis",
    "diagnoses.site_of_resection_or_biopsy",
    "primary_site"
  )) %>%
  aggregations()


files_info <- GenomicDataCommons::files() %>%
  GenomicDataCommons::filter(access == "open") %>%
  GenomicDataCommons::facet(c("type", "data_type")) %>%
  aggregations()
