# race_pie ----
race_pie <- function(data) {
  fig <- data %>% 
    dplyr::select(race) %>% 
    replace(is.na(.), "Sin dato") %>% 
    group_by(race) %>% 
    tally() %>% 
    dplyr::mutate(
      key_color = case_when(
        race == "white" ~ "#ffa600",
        race == "black or african american" ~ "#ff7c43",
        race == "not reported" ~ "#A2AEBB",
        race == "asian" ~ "#f95d6a",
        race == "Sin dato" ~ "#010101",
        race == "american indian or alaska native" ~ "#d45087",
        race == "native hawaiian or other pacific islander" ~ "#665191",
        race == "Unknown" ~ "#2f4b7c"
      )
    ) %>% 
    plot_ly(
      labels = ~race,
      values = ~n,
      type = "pie",
      textposition = "inside",
      textinfo = "value+percent",
      texttemplate = "%{label}<br>%{value}<br>%{percent:.1%}",
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

# race_piedt ----
race_piedt <- function(data) {
  data <- data %>% 
    dplyr::select(race) %>% 
    replace(is.na(.), "Sin dato") %>% 
    group_by(race) %>% 
    tally(name = "Número de casos", sort = TRUE) %>% 
    rename(
      "Raza" = 1
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
            filename = "casos_por_raza"
          ),
          list(
            extend = "excel",
            filename = "casos_por_raza"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# ethnicity_pie ----
ethnicity_pie <- function(data) {
  fig <- data %>% 
    dplyr::select(ethnicity) %>% 
    replace(is.na(.), "Sin dato") %>% 
    group_by(ethnicity) %>% 
    tally() %>% 
    dplyr::mutate(
      key_color = case_when(
        ethnicity == "not hispanic or latino" ~ "#C3E2C2",
        ethnicity == "not reported" ~ "#A2AEBB",
        ethnicity == "hispanic or latino" ~ "#DBCC95",
        ethnicity == "Sin dato" ~ "#010101",
        ethnicity == "Unknown" ~ "#2f4b7c"
      )
    ) %>% 
    plot_ly(
      labels = ~ethnicity,
      values = ~n,
      type = "pie",
      textposition = "inside",
      textinfo = "value+percent",
      texttemplate = "%{label}<br>%{value}<br>%{percent:.1%}",
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

# ethnicity_piedt ----
ethnicity_piedt <- function(data) {
  data <- data %>% 
    dplyr::select(ethnicity) %>% 
    replace(is.na(.), "Sin dato") %>% 
    group_by(ethnicity) %>% 
    tally(name = "Número de casos", sort = TRUE) %>% 
    rename(
      "Etnicidad" = 1
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
            filename = "casos_por_etnicidad"
          ),
          list(
            extend = "excel",
            filename = "casos_por_etnicidad"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# gender_pie ----
gender_pie <- function(data) {
  fig <- data %>% 
    dplyr::select(gender) %>% 
    replace(is.na(.), "Sin dato") %>% 
    group_by(gender) %>% 
    tally() %>% 
    dplyr::mutate(
      key_color = case_when(
        gender == "female" ~ "#FF90C2",
        gender == "not reported" ~ "#A2AEBB",
        gender == "male" ~ "#1640D6",
        gender == "Sin dato" ~ "#010101",
      )
    ) %>% 
    plot_ly(
      labels = ~gender,
      values = ~n,
      type = "pie",
      textposition = "inside",
      textinfo = "value+percent",
      texttemplate = "%{label}<br>%{value}<br>%{percent:.1%}",
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

# gender_piedt ----
gender_piedt <- function(data) {
  data <- data %>% 
    dplyr::select(gender) %>% 
    replace(is.na(.), "Sin dato") %>% 
    group_by(gender) %>% 
    tally(name = "Número de casos", sort = TRUE) %>% 
    rename(
      "Género" = 1
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
            filename = "casos_por_genero"
          ),
          list(
            extend = "excel",
            filename = "casos_por_genero"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# gender_age_pyramid ----
gender_age_pyramid <- function(data) {
  age_pyramid_df <- data %>% 
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
    mutate(
      `Edad` = as.character(`Edad`)
    ) %>% 
    replace(is.na(.), "Sin dato") %>% 
    mutate(
      `Edad` = factor(`Edad`)
    ) %>% 
    dplyr::mutate(
      `n` = ifelse(gender == "male", -`n`, `n`),
      abs_pop = abs(`n`)
    ) %>% 
    rename(
      "Género" = "gender",
      "Casos" = "n",
      "Casos absolutos" = "abs_pop"
    )
  
  age_pyramid <- plot_ly(
    data = age_pyramid_df,
    x = ~Casos,
    y = ~Edad, 
    color = ~`Género`,
    colors = c(female = "#FF90C2", male = "#1640D6"),
    textposition = "inside"
  ) %>% 
    add_bars(orientation = 'h', hoverinfo = 'text', text = ~`Casos absolutos`) %>%
    layout(
      bargap = 0.1, barmode = 'overlay',
      xaxis = list(
        title = "Número de caos"
      )
    )
  return(age_pyramid)
}

# gender_age_pyramiddt ----
gender_age_pyramiddt <- function(data) {
  data <- data %>% 
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
    mutate(
      `Edad` = as.character(`Edad`)
    ) %>% 
    replace(is.na(.), "Sin dato") %>% 
    mutate(
      `Edad` = factor(`Edad`)
    ) %>% 
    dplyr::mutate(
      `n` = ifelse(gender == "male", -`n`, `n`),
      abs_pop = abs(`n`)
    ) %>% 
    rename(
      "Género" = "gender",
      "Casos" = "n",
      "Número de casos" = "abs_pop"
    ) %>% 
    dplyr::select(
      `Género`, Edad, `Número de casos`
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
            filename = "casos_por_edad_genero"
          ),
          list(
            extend = "excel",
            filename = "casos_por_edad_genero"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}

# vital_status_pie ----
vital_status_pie <- function(data) {
  fig <- data %>% 
    dplyr::select(vital_status) %>% 
    replace(is.na(.), "Sin dato") %>% 
    group_by(vital_status) %>% 
    tally() %>% 
    dplyr::mutate(
      key_color = case_when(
        vital_status == "Dead" ~ "#5F8670",
        vital_status == "not reported" ~ "#A2AEBB",
        vital_status == "Alive" ~ "#5D3587",
        vital_status == "Sin dato" ~ "#010101",
      )
    ) %>% 
    plot_ly(
      labels = ~vital_status,
      values = ~n,
      type = "pie",
      textposition = "inside",
      textinfo = "value+percent",
      texttemplate = "%{label}<br>%{value}<br>%{percent:.1%}",
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

# vital_status_piedt ----
vital_status_piedt <- function(data) {
  data <- data %>% 
    dplyr::select(vital_status) %>% 
    replace(is.na(.), "Sin dato") %>% 
    group_by(vital_status) %>% 
    tally(name = "Número de casos", sort = TRUE) %>% 
    rename(
      "Estado vital" = 1
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
            filename = "casos_por_estado_vital"
          ),
          list(
            extend = "excel",
            filename = "casos_por_estado_vital"
          )
        ),
        paging = FALSE,
        scrollY = "400px",
        scrollX = TRUE
      )
    )
  return(data)
}
