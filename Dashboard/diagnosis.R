# primary_diagnosis_treemap ----
primary_diagnosis_treemap <- function(data) {
  primary_diagnosis_tree_df <- data %>%
    group_by(tissue_or_organ_of_origin, `primary_diagnosis`) %>%
    tally(name = "cases") %>%
    replace(is.na(.), "Sin dato") %>%
    ungroup() %>%
    mutate(
      primary_diagnosis = paste(
        as.character(cases),
        primary_diagnosis
      )
    )

  primary_diagnosis_tree_df <- data %>%
    mutate(
      parent = "Tejido u órgano de origen y sus diagnósticos"
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

  primary_diagnosis_treemap <- plot_ly(
    data = primary_diagnosis_tree_df,
    branchvalues = "total",
    type = "treemap",
    labels = ~primary_diagnosis,
    parents = ~tissue_or_organ_of_origin,
    values = ~cases,
    hoverinfo = "label"
  )

  return(primary_diagnosis_treemap)
}

# primary_diagnosis_treedt ----
primary_diagnosis_treedt <- function(data) {
  data <- data %>%
    group_by(tissue_or_organ_of_origin, primary_diagnosis) %>%
    tally(name = "Número de casos") %>%
    rename(
      "Tejido u órgano de origen" = 1,
      "Diagnóstico primario" = 2
    ) %>%
    datatable(
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
            filename = "casos_por_tejido_diagnostico"
          ),
          list(
            extend = "excel",
            filename = "casos_por_tejido_diagnostico"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# primary_stage_treemap ----
pathologic_stage_treemap <- function(data) {
  ajcc_pathologic_stage_tree_df <- data %>%
    group_by(tissue_or_organ_of_origin, ajcc_pathologic_stage) %>%
    tally(name = "cases") %>%
    replace(is.na(.), "Sin dato") %>%
    ungroup() %>%
    mutate(
      ajcc_pathologic_stage = paste(
        as.character(cases),
        ajcc_pathologic_stage
      )
    )

  ajcc_pathologic_stage_tree_df <- data %>%
    mutate(
      parent = "Tejido u órgano de origen y sus etapa patológica"
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

  ajcc_pathologic_stage_treemap <- plot_ly(
    data = ajcc_pathologic_stage_tree_df,
    branchvalues = "total",
    type = "treemap",
    labels = ~ajcc_pathologic_stage,
    parents = ~tissue_or_organ_of_origin,
    values = ~cases,
    hoverinfo = "label"
  )

  return(ajcc_pathologic_stage_treemap)
}

# pathologic_stage_treedt ----
pathologic_stage_treedt <- function(data) {
  data <- data %>%
    group_by(tissue_or_organ_of_origin, ajcc_pathologic_stage) %>%
    tally(name = "Número de casos") %>%
    rename(
      "Tejido u órgano de origen" = 1,
      "Etapa patológica" = 2
    ) %>%
    replace(is.na(.), "Sin dato") %>%
    datatable(
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
            filename = "casos_por_tejido_diagnostico"
          ),
          list(
            extend = "excel",
            filename = "casos_por_tejido_diagnostico"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# tissue_origin_bar ----
tissue_origin_bar <- function(data) {
  data <- data %>%
    group_by(tissue_or_organ_of_origin) %>%
    tally(name = "Número de casos", sort = TRUE) %>%
    rename(
      "Tejido u órgano de origen" = 1
    ) %>%
    replace(is.na(.), "Sin dato")

  if (nrow(data) > 30) {
    data <- head(data, 30)
  }

  fig <- plot_ly(
    data,
    x = ~`Tejido u órgano de origen`, y = ~`Número de casos`, type = "bar"
  ) %>%
    layout(
      xaxis = list(
        title = "Tejido u órgano de origen",
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
  return(fig)
}

# tissue_origin_bardt ----
tissue_origin_bardt <- function(data) {
  data <- data %>%
    group_by(tissue_or_organ_of_origin) %>%
    tally(name = "Número de casos", sort = TRUE) %>%
    rename(
      "Tejido u órgano de origen" = 1
    ) %>%
    replace(is.na(.), "Sin dato") %>%
    datatable(
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
            filename = "casos_por_tejido_de_origen"
          ),
          list(
            extend = "excel",
            filename = "casos_por_tejido_de_origen"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# primary_diagnosis_bar ----
primary_diagnosis_bar <- function(data) {
  data <- data %>%
    group_by(primary_diagnosis) %>%
    tally(name = "Número de casos", sort = TRUE) %>%
    rename(
      "Diagnóstico primario" = 1
    ) %>%
    replace(is.na(.), "Sin dato")

  if (nrow(data) > 30) {
    data <- head(data, 30)
  }

  fig <- plot_ly(
    data,
    x = ~`Diagnóstico primario`, y = ~`Número de casos`, type = "bar"
  ) %>%
    layout(
      xaxis = list(
        title = "Diagnóstico primario",
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
  return(fig)
}

# primary_diagnosis_bardt ----
primary_diagnosis_bardt <- function(data) {
  data <- data %>%
    group_by(primary_diagnosis) %>%
    tally(name = "Número de casos", sort = TRUE) %>%
    rename(
      "Diagnóstico primario" = 1
    ) %>%
    replace(is.na(.), "Sin dato") %>%
    datatable(
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
            filename = "casos_por_diagnostico_primario"
          ),
          list(
            extend = "excel",
            filename = "casos_por_diagnostico_primario"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# pathologic_stage_bar ----
pathologic_stage_bar <- function(data) {
  data <- data %>%
    group_by(ajcc_pathologic_stage) %>%
    tally(name = "Número de casos", sort = TRUE) %>%
    rename(
      "Etapa patológica" = 1
    ) %>%
    replace(is.na(.), "Sin dato")

  fig <- plot_ly(
    data,
    x = ~`Etapa patológica`, y = ~`Número de casos`, type = "bar"
  ) %>%
    layout(
      xaxis = list(
        title = "Etapa patológica",
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
  return(fig)
}

# pathologic_stage_bardt ----
pathologic_stage_bardt <- function(data) {
  data <- data %>%
    group_by(ajcc_pathologic_stage) %>%
    tally(name = "Número de casos", sort = TRUE) %>%
    rename(
      "Etapa patológia" = 1
    ) %>%
    replace(is.na(.), "Sin dato") %>%
    datatable(
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
            filename = "casos_por_etapa_patologica"
          ),
          list(
            extend = "excel",
            filename = "casos_por_etapa_patologica"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# age_at_diagnosis_bar ----
age_at_diagnosis_bar <- function(data) {
  fig <- data %>%
    mutate(
      age = age_at_diagnosis_years,
      `Edad al diagnostico` = age_categories(
        age,
        breakers = c(
          0, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90
        )
      )
    ) %>%
    group_by(`Edad al diagnostico`) %>%
    tally(name = "Casos") %>%
    mutate(
      `Edad al diagnostico` = as.character(`Edad al diagnostico`)
    ) %>%
    replace(is.na(.), "Sin dato") %>%
    mutate(
      `Edad al diagnostico` = factor(`Edad al diagnostico`)
    ) %>%
    plot_ly(
      x = ~`Edad al diagnostico`, y = ~`Casos`, type = "bar"
    ) %>%
    layout(
      xaxis = list(
        title = "Edad al diagnóstico"
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
  return(fig)
}

# age_at_diagnosis_bardt ----
age_at_diagnosis_bardt <- function(data) {
  data <- data %>%
    mutate(
      age = age_at_diagnosis_years,
      `Edad al diagnostico` = age_categories(
        age,
        breakers = c(
          0, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90
        )
      )
    ) %>%
    group_by(`Edad al diagnostico`) %>%
    tally(name = "Casos") %>%
    mutate(
      `Edad al diagnostico` = as.character(`Edad al diagnostico`)
    ) %>%
    replace(is.na(.), "Sin dato") %>%
    mutate(
      `Edad al diagnostico` = factor(`Edad al diagnostico`)
    ) %>%
    datatable(
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
            filename = "casos_por_edad_al_diagnostico"
          ),
          list(
            extend = "excel",
            filename = "casos_por_edad_al_diagnostico"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}
