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

# cases_results ----
cases_results <- GenomicDataCommons::cases() %>% 
  GenomicDataCommons::filter(
    project.program.name == "TCGA"
  ) %>%
  GenomicDataCommons::select(
    c(
      "case_id",
      "project.project_id",
      "data_category",
      "data_type",
      "data_format",
      "experimental_strategy",
      "wgs_coverage"
    )
  ) %>% 
  GenomicDataCommons::results_all()


# Get diagnosis, demographic and project ----
expands = c("diagnoses", "demographic", "project")
clinResults = cases() %>%
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
  case_id = clinResults$case_id,
  project_id = clinResults$project$project_id,
  project_name = clinResults$project$name
) %>% 
  left_join(
    .,
    data.frame(
      case_id = clinResults$id,
      disease_type = clinResults$disease_type,
      primary_site = clinResults$primary_site
    ),
    join_by(case_id)
  )


# project_number_number ----
project_number_number <- nrow(unique(combined_cases$project_id))

# cases_number_number ----
cases_number_number <- nrow(unique(combined_cases$case_id))

# disease_type_number ----
disease_type_number <- nrow(unique(combined_cases$disease_type))

# project_site_disease_tree ----
# project_site_disease_tree_0 <- combined_cases %>% 
#   dplyr::mutate(
#     parent = "Proyectos por sitio primario y tipo de enfermedad"
#   ) %>% 
#   dplyr::group_by(
#     parent, project_id
#   ) %>% 
#   tally(name = "Casos") %>% 
#   rename(
#     "label" = 2
#   )
# 
# project_site_disease_tree_1 <- combined_cases %>% 
#   dplyr::group_by(
#     project_id, primary_site
#   ) %>% 
#   dplyr::tally(name = "Casos") %>% 
#   dplyr::rename(
#     "parent" = 1,
#     "label" = 2
#   )
# 
# project_site_disease_tree_2 <- combined_cases %>% 
#   dplyr::group_by(
#     project_id, primary_site, disease_type,
#   ) %>% 
#   tally(name = "Casos")
# 
# project_site_disease_tree_2 <- left_join(
#   project_site_disease_tree_1,
#   project_site_disease_tree_2,
#   join_by(
#     parent == project_id,
#     label == primary_site
#   )
# ) %>% 
#   dplyr::mutate(
#     label = paste(Casos.x, label),
#     disease_type = paste(Casos.y, disease_type)
#   ) %>% 
#   ungroup() %>% 
#   dplyr::select(
#     label, disease_type, Casos.y
#   ) %>% 
#   rename(
#     "parent" = 1,
#     "label" = 2,
#     "Casos" = 3
#   )
# 
# project_site_disease_tree_1 <- project_site_disease_tree_1 %>% 
#   mutate(
#     label = paste(Casos, label)
#   )
# 
# project_site_disease_tree <- rbind(
#   project_site_disease_tree_0,
#   project_site_disease_tree_1
# ) %>% 
#   rbind(., project_site_disease_tree_2) %>% 
#   ungroup() %>% 
#   mutate(
#     ids = paste0("id", as.character(row_number()))
#   )
# 
# # project_site_disease_treemap ----
# project_site_disease_treemap <- plot_ly(
#   data = project_site_disease_tree,
#   branchvalues = "total",
#   type = "treemap",
#   #ids = ~ids,
#   labels = ~label,
#   parents = ~parent,
#   values = ~Casos,
#   hoverinfo = 'label'
# )

# project_disease_type_tree ----
project_disease_type_tree <- combined_cases %>% 
  group_by(project_id, disease_type) %>% 
  tally(name = "Casos") %>% 
  mutate(
    disease_type = paste(
      Casos, disease_type
    )
  ) %>% 
  rename(
    "parent" = 1,
    "label" = 2
  )

project_disease_type_tree <- combined_cases %>% 
  dplyr::select(project_id) %>% 
  mutate(
    parent = "Proyectos por tipo de enfermedad"
  ) %>% 
  group_by(parent, project_id) %>% 
  tally(name = "Casos") %>% 
  rename(
    "parent" = 1,
    "label" = 2
  ) %>% 
  rbind(., project_disease_type_tree) %>% 
  replace(is.na(.), "Sin dato")

# project_disease_type_treemap ----
project_disease_type_treemap <- plot_ly(
  data = project_disease_type_tree,
  branchvalues = "total",
  type = "treemap",
  #ids = ~ids,
  labels = ~label,
  parents = ~parent,
  values = ~Casos,
  hoverinfo = 'label'
)

# project_bar ----
project_bar <- combined_cases %>% 
  group_by(project_id, project_name) %>% 
  tally(name = "Número de casos", sort = TRUE) %>% 
  rename("Projecto" = 1, "Nombre" = 2)

# project_barplot ----
project_barplot <- plot_ly(
  project_bar,
  x = ~Projecto,
  y = ~`Número de casos`,
  type = "bar"
) %>%
  layout(
    xaxis = list(
      title = "Proyecto",
      categoryorder = "total descending"
    ),
    yaxis = list(
      title = "Número de casos"
    )
  ) %>%
  config(
    displaylogo = FALSE,
    modeBarButtonsToRemove = c(
      "sendDataToCloud", "editInChartStudio", "pan2d", "select2d",
      "drawclosedpath", "drawline", "drawrect", "drawopenpath",
      "drawcircle", "eraseshape", "zoomIn2d", "zoomOut2d", "toggleSpikelines",
      "lasso2d"
    )
  )

# project_bardt ----
project_bardt <- datatable(
  project_bar,
  extensions = "Buttons",
  rownames = FALSE,
  options = list(
    language = list(
      url = "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json"
    ),
    dom = "Bfrtip",
    buttons = list(
      list(
        extend = "csv",
        filename = "casos_por_proyecto"
      ),
      list(
        extend = "excel",
        filename = "casos_por_proyecto"
      )
    ),
    paging = FALSE,
    scrollY = "400px",
    scrollX = TRUE
  )
)

# combined_diagnoses ----
combined_diagnoses <- lapply(
  clinResults$diagnoses, function(inner_list) inner_list
) %>%
  bind_rows(.id = "case_id") %>% 
  select(
    where(
      ~!all(is.na(.x))
    )
  )
# diagnosis_age_df ----
diagnosis_age_df <- combined_diagnoses %>% 
  mutate(
    age = round(age_at_diagnosis / 365, 0),
    `Edad al diagnostico` = age_categories(
      age,
      breakers = c(
        0, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90
      )
    )
  ) %>% 
  group_by(`Edad al diagnostico`) %>% 
  tally(name = "Casos")


# primary_diagnosis_tree_df ----
primary_diagnosis_tree_df <- combined_diagnoses %>% 
  group_by(tissue_or_organ_of_origin, `primary_diagnosis`) %>% 
  tally(name = "cases") %>% 
  replace(is.na(.), "Sin dato") %>% 
  ungroup() %>% 
  #group_by(tissue_or_organ_of_origin) %>% 
  mutate(
    primary_diagnosis = paste(
      as.character(cases),
      primary_diagnosis
    )
  )

primary_diagnosis_tree_df <- combined_diagnoses %>% 
  mutate(
    parent = "Tejido u órgano de origen y sus diagnosticos"
  ) %>% 
  group_by(parent, tissue_or_organ_of_origin) %>% 
  tally(name = "cases") %>% 
  rename(
    "tissue_or_organ_of_origin" = 1,
    "primary_diagnosis" = 2,
  ) %>% 
  rbind(., primary_diagnosis_tree_df) %>% 
  replace(is.na(.), "Sin dato") %>% 
  ungroup() %>% 
  mutate(
    ids = ifelse(
      tissue_or_organ_of_origin == "", 
      paste0("-", primary_diagnosis),
      paste0(tissue_or_organ_of_origin, "-", primary_diagnosis)
    )
  )

# primary_diagnosis_treemap ----
primary_diagnosis_treemap <- plot_ly(
  data = primary_diagnosis_tree_df,
  branchvalues = "total",
  type = "treemap",
  #ids = ~ids,
  labels = ~primary_diagnosis,
  parents = ~tissue_or_organ_of_origin,
  values = ~cases,
  hoverinfo = 'label'
)


# ajcc_pathologic_stage_tree_df ----
ajcc_pathologic_stage_tree_df <- combined_diagnoses %>% 
  group_by(tissue_or_organ_of_origin, ajcc_pathologic_stage) %>% 
  tally(name = "cases") %>% 
  replace(is.na(.), "Sin dato") %>% 
  ungroup() %>% 
  #group_by(tissue_or_organ_of_origin) %>% 
  mutate(
    ajcc_pathologic_stage = paste(
      as.character(cases),
      ajcc_pathologic_stage
    )
  )

ajcc_pathologic_stage_tree_df <- combined_diagnoses %>% 
  mutate(
    parent = "Tejido u órgano de origen y sus diagnosticos"
  ) %>% 
  group_by(parent, tissue_or_organ_of_origin) %>% 
  tally(name = "cases") %>% 
  rename(
    "tissue_or_organ_of_origin" = 1,
    "ajcc_pathologic_stage" = 2,
  ) %>% 
  rbind(., ajcc_pathologic_stage_tree_df) %>% 
  replace(is.na(.), "Sin dato") %>% 
  ungroup() %>% 
  mutate(
    ids = ifelse(
      tissue_or_organ_of_origin == "", 
      paste0("-", ajcc_pathologic_stage),
      paste0(tissue_or_organ_of_origin, "-", ajcc_pathologic_stage)
    )
  )

# ajcc_pathologic_stage_treemap ----
ajcc_pathologic_stage_treemap <- plot_ly(
  data = ajcc_pathologic_stage_tree_df,
  branchvalues = "total",
  type = "treemap",
  labels = ~ajcc_pathologic_stage,
  parents = ~tissue_or_organ_of_origin,
  values = ~cases,
  hoverinfo = 'label'
)

# combined_demographics ----
combined_demographics <- as.data.frame(clinResults$demographic) %>% 
  select(
    where(
      ~!all(is.na(.x))
    )
  )

# age_pyramid_df ----
age_pyramid_df <- combined_demographics %>% 
  dplyr::filter(
    gender %in% c("female", "male")
  ) %>% 
  dplyr::mutate(
    `Edad` = age_categories(
      age_at_index,
      breakers = c(
        0, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90
      )
    )
  ) %>% 
  dplyr::group_by(gender, Edad) %>% 
  dplyr::tally() %>%
  dplyr::mutate(
    `n` = ifelse(gender == "male", -`n`, `n`),
    abs_pop = abs(`n`)
  ) %>% 
  rename(
    "Género" = "gender",
    "Casos" = "n",
    "Casos absolutos" = "abs_pop"
  )

# age_pyramid ----
age_pyramid <- plot_ly(
  data = age_pyramid_df,
    x = ~Casos,
    y = ~Edad, 
    color = ~`Género`,
    colors = c(female = "#FF90C2", male = "#1640D6"),
    textposition = "inside"
  ) %>% 
  add_bars(orientation = 'h', hoverinfo = 'text', text = ~`Casos absolutos`) %>%
  layout(bargap = 0.1, barmode = 'overlay')

# files_info ----
files_info <- GenomicDataCommons::files() %>%
  GenomicDataCommons::filter(
    cases.project.project_id %in% tcga_project_ids_list
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
    cases.project.project_id %in% tcga_project_ids_list
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

# f_type_format_df ----
f_type_format_df <- files_results %>% 
  group_by(
    data_type,
    data_format
  ) %>% 
  tally(name = "Casos")

# f_type_format_bar ----
f_type_format_bar <- plot_ly(
  f_type_format_df,
  type = "bar",
  x = ~data_type,
  y = ~Casos,
  color = ~data_format,
  colors = "Paired"
) %>% 
  layout(
    barmode = "stack",
    xaxis = list(
      title = "Tipo de dato",
      categoryorder = "total descending"
    ),
    yaxis = list(
      title = "Número de casos"
    ),
    legend = list(
      title = list(text = "Formato")
    )
  ) %>%
  config(
    displaylogo = FALSE,
    modeBarButtonsToRemove = c(
      "sendDataToCloud", "editInChartStudio", "pan2d", "select2d",
      "drawclosedpath", "drawline", "drawrect", "drawopenpath",
      "drawcircle", "eraseshape", "zoomIn2d", "zoomOut2d", "toggleSpikelines",
      "lasso2d"
    )
  )

# f_category_type_format ----
f_category_type_format <- files_results %>% 
  group_by(
    data_category, data_type, data_format
  ) %>% 
  tally(name = "Casos")

f_category_type_format_tree_0 <- files_results %>% 
  dplyr::mutate(
    parent = "Categoría de dato por tipo de dato y formato"
  ) %>% 
  dplyr::group_by(
    parent, data_category
  ) %>% 
  tally(name = "Casos") %>% 
  rename(
    "label" = "data_category"
  )

f_category_type_format_tree_1 <- files_results %>% 
  dplyr::group_by(
    data_category, data_type
  ) %>% 
  dplyr::tally(name = "Casos") %>% 
  dplyr::rename(
    "parent" = "data_category",
    "label" = "data_type"
  )


f_category_type_format_tree_2 <- files_results %>% 
  dplyr::group_by(
    data_category, data_type, data_format
  ) %>% 
  dplyr::tally(name = "Casos") 

f_category_type_format_tree_2 <- dplyr::left_join(
  f_category_type_format_tree_1,
  f_category_type_format_tree_2,
  by = join_by(
    parent == data_category, 
    label == data_type
  )
) %>% 
  mutate(
    label = paste(Casos.x, label),
    data_format = paste(Casos.y, data_format)
  ) %>% 
  ungroup() %>% 
  select(
    label, data_format, Casos.y
  ) %>% 
  rename(
    "parent" = "label",
    "label" = "data_format",
    "Casos" = "Casos.y"
  )

f_category_type_format_tree_1 <- f_category_type_format_tree_1 %>% 
  mutate(
    label = paste(Casos, label)
  )

f_category_type_format_tree <- rbind(
  f_category_type_format_tree_0,
  f_category_type_format_tree_1
) %>% 
  rbind(., f_category_type_format_tree_2)

# primary_diagnosis_treemap ----
f_category_type_format_treemap <- plot_ly(
  data = f_category_type_format_tree,
  branchvalues = "total",
  type = "treemap",
  #ids = ~ids,
  labels = ~label,
  parents = ~parent,
  values = ~Casos,
  hoverinfo = 'label'
)

# experimental_strategy_tree ----
experimental_strategy_tree <- left_join(
  files_results %>% 
    dplyr::select(file_id, experimental_strategy),
  files_cases %>% 
    dplyr::select(file_id, project_id),
  join_by(file_id)
) %>% 
  group_by(project_id, experimental_strategy) %>% 
  tally(name = "Casos") %>% 
  mutate(
    experimental_strategy = paste(
      Casos, experimental_strategy
    )
  ) %>% 
  rename(
    "parent" = 1,
    "label" = 2
  )

experimental_strategy_tree <- files_cases %>% 
  dplyr::select(file_id, project_id) %>% 
  mutate(
    parent = "Proyectos por estrategia experimental"
  ) %>% 
  group_by(parent, project_id) %>% 
  tally(name = "Casos") %>% 
  rename(
    "parent" = 1,
    "label" = 2
  ) %>% 
  rbind(., experimental_strategy_tree) %>% 
  replace(is.na(.), "Sin dato")

# f_experimental_strategy_treemap ----
f_experimental_strategy_treemap <- plot_ly(
  data = experimental_strategy_tree,
  branchvalues = "total",
  type = "treemap",
  #ids = ~ids,
  labels = ~label,
  parents = ~parent,
  values = ~Casos,
  hoverinfo = 'label'
)

# tests ----
primary_diagnosis_tree_0 <- combined_diagnoses %>% 
  dplyr::mutate(
    parent = 
      "Tejido u órgano de origen, diagnóstico primario y etapa patólogica"
  ) %>% 
  dplyr::group_by(
    parent, tissue_or_organ_of_origin
  ) %>% 
  tally(name = "Casos") %>% 
  rename(
    "label" = 2
  )

primary_diagnosis_tree_1 <- combined_diagnoses %>% 
  dplyr::group_by(
    tissue_or_organ_of_origin, primary_diagnosis
  ) %>% 
  dplyr::tally(name = "Casos") %>% 
  dplyr::rename(
    "parent" = 1,
    "label" = 2
  )

primary_diagnosis_tree_2 <- combined_diagnoses %>% 
  dplyr::group_by(
    tissue_or_organ_of_origin, primary_diagnosis, ajcc_pathologic_stage
  ) %>% 
  dplyr::tally(name = "Casos")

primary_diagnosis_tree_2 <- dplyr::left_join(
  primary_diagnosis_tree_1,
  primary_diagnosis_tree_2,
  by = join_by(
    parent == tissue_or_organ_of_origin,
    label == primary_diagnosis
  )
) %>% 
  mutate(
    label = paste(Casos.x, label),
    ajcc_pathologic_stage = paste(Casos.y, ajcc_pathologic_stage)
  ) %>% 
  ungroup() %>% 
  select(
    label, ajcc_pathologic_stage, Casos.y
  ) %>% 
  rename(
    "parent" = "label",
    "label" = "ajcc_pathologic_stage",
    "Casos" = "Casos.y"
  )

primary_diagnosis_tree_1 <- primary_diagnosis_tree_1 %>% 
  mutate(
    label = paste(Casos, label)
  )

primary_diagnosis_tree <- rbind(
  primary_diagnosis_tree_0,
  primary_diagnosis_tree_1
) %>% 
  rbind(., primary_diagnosis_tree_2)

fig <- plot_ly(
  data = primary_diagnosis_tree,
  branchvalues = "total",
  type = "treemap",
  labels = ~label,
  parents = ~parent,
  values = ~Casos
)