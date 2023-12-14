library(GenomicDataCommons)
library(dplyr)

filter_all_na <- function(df) {
  notallna <- vapply(df, function(x) !all(is.na(x)), logical(1L))
  df[, notallna]
}

bindrowname <- function(result_list) {
  if (is.data.frame(result_list)) {
    stop("Only run this on the list type of outputs")
  }
  datadf <- dplyr::bind_rows(result_list)
  rownames(datadf) <- names(result_list)
  filter_all_na(datadf)
}

ge_manifest <- files() %>%
  filter(cases.project.project_id == "TCGA-OV") %>%
  filter(type == "gene_expression") %>%
  filter(analysis.workflow_type == "STAR - Counts") %>%
  filter(analysis.workflow_type == "STAR - Counts") %>%
  filter(access == "open") %>%
  manifest(size = 5)

expands <- c(
  "diagnoses", "annotations",
  "demographic", "exposures"
)
clin_results <- cases() %>%
  GenomicDataCommons::select(NULL) %>%
  GenomicDataCommons::expand(expands) %>%
  results()
demo_df <- filter_all_na(clin_results$demographic)
exposures_df <- bindrowname(clin_results$exposures)


res <- files() %>%
  facet(c("type", "data_type", "state", "data_category")) %>%
  aggregations()


cases <- cases() %>%
  facet(c("disease_type", "primary_site")) %>%
  aggregations()


cases <- cases() %>%
  GenomicDataCommons::filter(project.project_id %in% tcga_project_ids) %>%
  GenomicDataCommons::expand(expands) %>%
  results_all()

ge_manifest <- GenomicDataCommons::files() %>%
  GenomicDataCommons::filter(cases.project.project_id == "TCGA-OV") %>%
  GenomicDataCommons::filter(type == "gene_expression") %>%
  GenomicDataCommons::filter(analysis.workflow_type == "STAR - Counts") %>%
  GenomicDataCommons::filter(access == "open") %>%
  GenomicDataCommons::manifest(size = 5)

library(BiocParallel)
register(MulticoreParam())
destdir <- tempdir()
fnames <- lapply(ge_manifest$id, gdcdata, use_cached = FALSE)
