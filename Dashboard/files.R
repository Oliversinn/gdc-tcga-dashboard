# category_type_format_treemap ----
category_type_format_treemap <- function(data) {
  f_category_type_format_tree_0 <- data %>% 
    dplyr::mutate(
      parent = "Archivos por categoría de dato, tipo de dato y formato"
    ) %>% 
    dplyr::group_by(
      parent, data_category
    ) %>% 
    tally(name = "Casos") %>% 
    rename(
      "label" = "data_category"
    )
  
  f_category_type_format_tree_1 <- data %>% 
    dplyr::group_by(
      data_category, data_type
    ) %>% 
    dplyr::tally(name = "Casos") %>% 
    dplyr::rename(
      "parent" = "data_category",
      "label" = "data_type"
    )
  
  
  f_category_type_format_tree_2 <- data %>% 
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
  
  fig <- plot_ly(
    data = f_category_type_format_tree,
    branchvalues = "total",
    type = "treemap",
    #ids = ~ids,
    labels = ~label,
    parents = ~parent,
    values = ~Casos,
    hoverinfo = 'label'
  )
  return(fig)
}

# category_type_format_treedt ----
category_type_format_treedt <- function(data) {
  data <- data %>% 
    dplyr::group_by(
      data_category, data_type, data_format
    ) %>% 
    dplyr::tally(name = "Número de archivos")  %>% 
    rename(
      "Categoría de dato" = 1,
      "Tipo de dato" = 2,
      "Formato" = 3
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
            filename = "archivos_por_categoria_tipo_formato"
          ),
          list(
            extend = "excel",
            filename = "archivos_por_categoria_tipo_formato"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
    
}

# experimental_strategy_treemap ----
experimental_strategy_treemap <- function(data, cases) {

  tree_data <- left_join(
    data %>% 
      dplyr::select(file_id, experimental_strategy),
    cases %>% 
      dplyr::select(file_id, project_id),
    dplyr::join_by(file_id)
  ) %>% 
    dplyr::filter(
      !is.na(project_id)
    ) %>% 
    dplyr::mutate(
      project_id = case_when(
        is.na(project_id) ~ "Sin proyecto",
        TRUE ~ project_id
      ),
      experimental_strategy = case_when(
        is.na(experimental_strategy) ~ "Sin dato",
        TRUE ~ experimental_strategy
      )
    ) %>% 
    replace(is.na(.), "Sin dato") %>% 
    dplyr::group_by(project_id, experimental_strategy) %>% 
    dplyr::tally(name = "Casos") %>% 
    dplyr::mutate(
      experimental_strategy = paste(
        Casos, experimental_strategy
      )
    ) %>% 
    dplyr::rename(
      "parent" = 1,
      "label" = 2
    )
  
  tree_data <- cases %>% 
    dplyr::select(file_id, project_id) %>% 
    dplyr::mutate(
      project_id = case_when(
        is.na(project_id) ~ "Sin proyecto",
        TRUE ~ project_id
      ),
      parent = "Archivos por proyecto y estrategia experimental"
    ) %>% 
    dplyr::group_by(parent, project_id) %>% 
    dplyr::tally(name = "Casos") %>% 
    dplyr::rename(
      "parent" = 1,
      "label" = 2
    ) %>% 
    rbind(., tree_data)
  

  fig <- plot_ly(
    data = tree_data,
    branchvalues = "total",
    type = "treemap",
    labels = ~label,
    parents = ~parent,
    values = ~Casos,
    hoverinfo = 'label'
  )
  return(fig)
}

# experimental_strategy_treedt ----
experimental_strategy_treedt <- function(data, cases) {
  data <- left_join(
    data %>% 
      dplyr::select(file_id, experimental_strategy),
    cases %>% 
      dplyr::select(file_id, project_id),
    join_by(file_id)
  ) %>% 
    group_by(project_id, experimental_strategy) %>% 
    tally(name = "Número de archivos") %>% 
    replace(is.na(.), "Sin dato") %>% 
    rename(
      "Proyecto" = 1,
      "Estrategía experimental" = 2
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
            filename = "archivos_por_proyecto_estrategia"
          ),
          list(
            extend = "excel",
            filename = "archivos_por_proyecto_estrategia"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# file_project_bar ----
file_project_bar <- function(data) {
  fig <- data %>% 
    group_by(project_id) %>% 
    tally(name = "Número de archivos") %>% 
    rename(
      "Proyecto" = 1
    ) %>% plot_ly(
      x = ~`Proyecto`, y = ~`Número de archivos`, type = "bar"
    ) %>%
    layout(
      xaxis = list(
        title = "Proyecto",
        categoryorder = "total descending"
      ),
      yaxis = list(
        title = "Número de archivos"
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

# file_project_bardt ----
file_project_bardt <- function(data) {
  data <- data %>% 
    group_by(project_id) %>% 
    tally(name = "Número de archivos") %>% 
    rename(
      "Proyecto" = 1
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
            filename = "archivos_por_proyecto"
          ),
          list(
            extend = "excel",
            filename = "archivos_por_proyecto"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# experimental_strategy_bar ----
experimental_strategy_bar <- function(data) {
  fig <- data %>% 
    group_by(experimental_strategy) %>% 
    tally(name = "Número de archivos") %>% 
    replace(is.na(.), "Sin dato") %>% 
    rename(
      "Estrategía experimental" = 1
    ) %>% plot_ly(
      x = ~`Estrategía experimental`, y = ~`Número de archivos`, type = "bar"
    ) %>%
    layout(
      xaxis = list(
        title = "Estrategía experimental",
        categoryorder = "total descending"
      ),
      yaxis = list(
        title = "Número de archivos"
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

# experimental_strategy_bardt ----
experimental_strategy_bardt <- function(data) {
  data <- data %>% 
    group_by(experimental_strategy) %>% 
    tally(name = "Número de archivos") %>% 
    replace(is.na(.), "Sin dato") %>% 
    rename(
      "Estrategía experimental" = 1
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
            filename = "archivos_por_estrategia_experimental"
          ),
          list(
            extend = "excel",
            filename = "archivos_por_estrategia_experimental"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# data_category_bar -----
data_category_bar <- function(data) {
  fig <- data %>% 
    group_by(data_category) %>% 
    tally(name = "Número de archivos") %>% 
    rename(
      "Categoría de dato" = 1
    ) %>% plot_ly(
      x = ~`Categoría de dato`, y = ~`Número de archivos`, type = "bar"
    ) %>%
    layout(
      xaxis = list(
        title = "Categoría de dato",
        categoryorder = "total descending"
      ),
      yaxis = list(
        title = "Número de archivos"
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

# data_category_bardt -----
data_category_bardt <- function(data) {
  data <- data %>% 
    group_by(data_category) %>% 
    tally(name = "Número de archivos") %>% 
    replace(is.na(.), "Sin dato") %>% 
    rename(
      "Categoría de dato" = 1
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
            filename = "archivos_por_categoria"
          ),
          list(
            extend = "excel",
            filename = "archivos_por_categoria"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# data_type_format_bar ----
data_type_format_bar <- function(data) {
  fig <- data %>% 
    group_by(
      data_type,
      data_format
    ) %>% 
    tally(name = "Número de archivos") %>% 
    plot_ly(
    type = "bar",
    x = ~data_type,
    y = ~`Número de archivos`,
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
        title = "Número de archivos"
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
  return(fig)
}

# data_type_format_bardt ----
data_type_format_bardt <- function(data) {
  data <- data %>% 
    group_by(
      data_type,
      data_format
    ) %>% 
    tally(name = "Número de archivos") %>% 
    rename(
      "Tipo de dato" = 1,
      "Formato" = 2
    )  %>% 
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
            filename = "archivos_por_tipo_formato"
          ),
          list(
            extend = "excel",
            filename = "archivos_por_tipo_formato"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# data_type_bar ----
data_type_bar <- function(data) {
  fig <- data %>% 
    group_by(data_type) %>% 
    tally(name = "Número de archivos") %>% 
    rename(
      "tipo de dato" = 1
    ) %>% plot_ly(
      x = ~`tipo de dato`, y = ~`Número de archivos`, type = "bar"
    ) %>%
    layout(
      xaxis = list(
        title = "Tipo de dato",
        categoryorder = "total descending"
      ),
      yaxis = list(
        title = "Número de archivos"
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

# data_type_bardt ----
data_type_bardt <- function(data) {
  data <- data %>% 
    group_by(data_type) %>% 
    tally(name = "Número de archivos") %>% 
    replace(is.na(.), "Sin dato") %>% 
    rename(
      "Tipo de dato" = 1
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
            filename = "archivos_por_tipo"
          ),
          list(
            extend = "excel",
            filename = "archivos_por_tipo"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# data_format_bar ----
data_format_bar <- function(data) {
  fig <- data %>% 
    group_by(data_format) %>% 
    tally(name = "Número de archivos") %>% 
    rename(
      "Formato" = 1
    ) %>% plot_ly(
      x = ~`Formato`, y = ~`Número de archivos`, type = "bar"
    ) %>%
    layout(
      xaxis = list(
        title = "Formato",
        categoryorder = "total descending"
      ),
      yaxis = list(
        title = "Número de archivos"
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

# data_format_bardt ----
data_format_bardt <- function(data) {
  data <- data %>% 
    group_by(data_format) %>% 
    tally(name = "Número de archivos") %>% 
    replace(is.na(.), "Sin dato") %>% 
    rename(
      "Formato" = 1
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
            filename = "archivos_por_formato"
          ),
          list(
            extend = "excel",
            filename = "archivos_por_formato"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}
