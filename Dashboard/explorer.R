project_id_barplot <- function(data) {
  data <- as.data.frame(data) %>%
    dplyr::filter(.data$key %in% tcga_project_ids_list)

  fig <- plot_ly(
    data,
    x = ~key, y = ~doc_count, type = "bar"
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

project_id_dt <- function(data) {
  data <- data %>%
    dplyr::filter(.data$key %in% tcga_project_ids_list) %>%
    dplyr::select(
      Proyecto = .data$key,
      `Número de casos` = .data$doc_count
    )
  data <- datatable(
    data,
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

aggregation_substr_barplot <- function(data, variable_name) {
  data <- as.data.frame(data)

  xticks_labels <- as.list(substr(data$key, 1, 30))

  fig <- plot_ly(
    data,
    x = ~key, y = ~doc_count, type = "bar"
  ) %>%
    layout(
      xaxis = list(
        title = variable_name,
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

aggregation_barplot <- function(data, variable_name) {
  data <- as.data.frame(data)
  fig <- plot_ly(
    data,
    x = ~key, y = ~doc_count, type = "bar"
  ) %>%
    layout(
      xaxis = list(
        title = variable_name,
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

aggregation_dt <- function(data, variable_name, download_name) {
  data <- data %>%
    dplyr::select(
      .data$key,
      .data$doc_count
    )
  colnames(data) <- c(variable_name, "Número de casos")
  data <- datatable(
    data,
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
          filename = download_name
        ),
        list(
          extend = "excel",
          filename = download_name
        )
      ),
      paging = FALSE,
      scrollY = "400px",
      scrollX = TRUE
    )
  )
  return(data)
}

gender_pie <- function(data) {
  data <- as.data.frame(data) %>%
    dplyr::mutate(
      key_color = case_when(
        key == "female" ~ "#FF90C2",
        key == "male" ~ "#1640D6",
        key == "not reported" ~ "#A2AEBB",
        key == "_missing" ~ "#071013"
      )
    )
  fig <- plot_ly(
    data,
    labels = ~key,
    values = ~doc_count,
    type = "pie",
    textposition = "inside",
    textinfo = "value+percent",
    texttemplate = "%{value}<br>%{percent:.1%}",
    sort = FALSE,
    height = 500,
    marker = list(colors = ~key_color)
  ) %>%
    layout(
      xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      legend = list(
        orientation = "h", x = 0, y = 0.0,
        bgcolor = "rgba(0,0,0,0)", font = list(size = 15)
      )
    ) %>%
    config(displaylogo = FALSE) %>%
    layout(hovermode = "x")
  return(fig)
}


vital_status_pie <- function(data) {
  data <- as.data.frame(data) %>%
    dplyr::mutate(
      key_color = case_when(
        key == "alive" ~ "#F9DC5C",
        key == "dead" ~ "#ED254E",
        key == "not reported" ~ "#A2AEBB",
        key == "_missing" ~ "#071013"
      )
    )
  fig <- plot_ly(
    data,
    labels = ~key,
    values = ~doc_count,
    type = "pie",
    textposition = "inside",
    textinfo = "value+percent",
    texttemplate = "%{value}<br>%{percent:.1%}",
    sort = FALSE,
    height = 500,
    marker = list(colors = ~key_color)
  ) %>%
    layout(
      xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      legend = list(
        orientation = "h", x = 0, y = 0.0,
        bgcolor = "rgba(0,0,0,0)", font = list(size = 15)
      )
    ) %>%
    config(displaylogo = FALSE) %>%
    layout(hovermode = "x")
  return(fig)
}
