library(GenomicDataCommons)
library(dplyr)

# setup ----
path_global = dirname(rstudioapi::getSourceEditorContext()$path)

# Get diagnosis, demographic and project ----
expands = c("diagnoses", "demographic", "project")
clin_results = cases() %>%
  GenomicDataCommons::select(
    c(
      "disease_type",
      "primary_site"
    )
  ) %>% 
  GenomicDataCommons::filter(project.program.name == "TCGA") %>%
  GenomicDataCommons::expand(expands) %>%
  GenomicDataCommons::results_all()

# combined_cases ----
combined_cases <- data.frame(
  case_id = clin_results$case_id,
  project_id = clin_results$project$project_id,
  project_name = clin_results$project$name
) %>% 
  left_join(
    .,
    data.frame(
      case_id = clin_results$id,
      disease_type = clin_results$disease_type,
      primary_site = clin_results$primary_site
    ),
    join_by(case_id)
  )


# combined_diagnoses ----
combined_diagnoses <- lapply(
  clin_results$diagnoses, function(inner_list) inner_list
) %>%
  bind_rows(.id = "case_id") %>% 
  select(
    where(
      ~!all(is.na(.x))
    )
  )
combined_diagnoses$age_at_diagnosis_years = floor(
  combined_diagnoses$age_at_diagnosis / 365
)

# combined_demographics ----
combined_demographics <- as.data.frame(clin_results$demographic) %>% 
  select(
    where(
      ~!all(is.na(.x))
    )
  )
combined_demographics$case_id <- rownames(combined_demographics)


# files_info ----
files_info <- GenomicDataCommons::files() %>%
  GenomicDataCommons::filter(
    cases.project.program.name == "TCGA"
  ) %>%
  GenomicDataCommons::filter(
    access == "open"
  ) %>% 
  GenomicDataCommons::facet(
    c(
      "data_category",
      "data_type",
      "data_format",
      "type",
      "file_id",
      "experimental_trategy",
      "wgs_coverage"
    )
  ) %>%
  aggregations()

# files_result ----
files_results <- GenomicDataCommons::files() %>% 
  GenomicDataCommons::filter(
    cases.project.program.name == "TCGA"
  ) %>%
  GenomicDataCommons::filter(
    access == "open"
  ) %>% 
  GenomicDataCommons::select(
    c(
      "file_id",
      "cases.project.project_id",
      "cases.case_id",
      "data_category",
      "data_type",
      "data_format",
      "experimental_strategy",
      "wgs_coverage"
    )
  ) %>% 
  GenomicDataCommons::results_all()

# files_cases ----
files_cases <- lapply(
  files_results$cases, function(inner_list) inner_list
) %>%
  bind_rows(.id = "file_id") %>% 
  select(
    where(
      ~!all(is.na(.x))
    )
  ) %>% 
  unnest(., project)

files_results <- as.data.frame(
  within(files_results, rm(cases))
)

tcga_project_ids_list <- unique(combined_cases$project_id)

case_id_list <- unique(combined_cases$case_id)

min_diagnosis_age <- floor(
  min(combined_diagnoses$age_at_diagnosis, na.rm = TRUE) / 365
)

max_diagnosis_age <- floor(
  max(combined_diagnoses$age_at_diagnosis, na.rm = TRUE) / 365
)

min_age <- floor(
  min(combined_demographics$age_at_index, na.rm = TRUE)
)

max_age <- floor(
  max(combined_demographics$age_at_index, na.rm = TRUE)
)

rm(clin_results)

save.image(file = paste0(path_global, "/Dashboard/tcga.RData"))
