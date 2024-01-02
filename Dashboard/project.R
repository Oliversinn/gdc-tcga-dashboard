# project_disease_type_treemap ----
project_disease_type_treemap <- function(data) {
  project_disease_type_tree <- data %>%
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

  project_disease_type_tree <- data %>%
    dplyr::select(project_id) %>%
    mutate(
      parent = "Número de casos por proyecto y por tipo de enfermedad"
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
    labels = ~label,
    parents = ~parent,
    values = ~Casos
  )

  return(project_disease_type_treemap)
}

project_disease_type_treedt <- function(data) {
  data <- data %>%
    group_by(project_id, disease_type) %>%
    tally(name = "Número de casos", sort = TRUE) %>%
    rename(
      "Proyecto" = 1,
      "Tipo de enfermedad" = 2
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
            filename = "casos_por_proyecto_tipo_enfermedad"
          ),
          list(
            extend = "excel",
            filename = "casos_por_proyecto_tipo_enfermedad"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# project_bar ----
project_bar <- function(data) {
  fig <- data %>%
    group_by(project_id) %>%
    tally(name = "Número de casos", sort = TRUE) %>%
    rename("Proyecto" = 1) %>%
    plot_ly(
      x = ~Proyecto, y = ~`Número de casos`, type = "bar"
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
  return(fig)
}

# project_bardt ----
project_bardt <- function(data) {
  data <- data %>%
    group_by(project_id, project_name) %>%
    tally(name = "Número de casos", sort = TRUE) %>%
    rename("Proyecto" = 1, "Nombre" = 2) %>%
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
  return(data)
}

# disease_type_bar ----
disease_type_bar <- function(data) {
  fig <- data %>%
    group_by(disease_type) %>%
    tally(name = "Número de casos", sort = TRUE) %>%
    rename("Tipo de enfermedad" = 1) %>%
    plot_ly(
      x = ~`Tipo de enfermedad`, y = ~`Número de casos`, type = "bar"
    ) %>%
    layout(
      xaxis = list(
        title = "Tipo de enfermedad",
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

# disease_type_bardt ----
disease_type_bardt <- function(data) {
  data <- data %>%
    group_by(disease_type) %>%
    tally(name = "Número de casos", sort = TRUE) %>%
    rename("Tipo de enfermedad" = 1) %>%
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
            filename = "casos_por_tipo_enfermedad"
          ),
          list(
            extend = "excel",
            filename = "casos_por_tipo_enfermedad"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# primary_site_bar ----
primary_site_bar <- function(data) {
  data <- data %>%
    group_by(primary_site) %>%
    tally(name = "Número de casos", sort = TRUE) %>%
    rename("Sitio primario" = 1)

  xticks_labels <- as.list(substr(data$`Sitio primario`, 1, 30))

  fig <- plot_ly(
    data,
    x = ~`Sitio primario`, y = ~`Número de casos`, type = "bar"
  ) %>%
    layout(
      xaxis = list(
        title = "Sitio primario",
        categoryorder = "total descending",
        ticktext = xticks_labels,
        tickvals = as.list(c(0:nrow(data))),
        tickmode = "array"
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

# primary_site_bardt ----
primary_site_bardt <- function(data) {
  data <- data %>%
    group_by(primary_site) %>%
    tally(name = "Número de casos", sort = TRUE) %>%
    rename("Sitio primario" = 1) %>%
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
            filename = "casos_por_sitio_primario"
          ),
          list(
            extend = "excel",
            filename = "casos_por_sitio_primario"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}
