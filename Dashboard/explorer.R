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
