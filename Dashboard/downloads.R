# combined_cases_dt ----
combined_cases_dt <- function(data) {
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
          filename = "base_de_datos_casos"
        ),
        list(
          extend = "excel",
          filename = "base_de_datos_casos"
        )
      ),
      scrollX = TRUE,
      scrollY = "600px",
      pageLength = 25
    )
  )
  return(data)
}

# combined_demographics_dt ----
combined_demographics_dt <- function(data) {
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
          filename = "base_de_datos_casos_demografia"
        ),
        list(
          extend = "excel",
          filename = "base_de_datos_casos_demografia"
        )
      ),
      scrollX = TRUE,
      scrollY = "600px",
      pageLength = 25
    )
  )
  return(data)
}

# combined_diagnosis_dt ----
combined_diagnosis_dt <- function(data) {
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
          filename = "base_de_datos_casos_diagnostico"
        ),
        list(
          extend = "excel",
          filename = "base_de_datos_casos_diagnostico"
        )
      ),
      scrollX = TRUE,
      scrollY = "600px",
      pageLength = 25
    )
  )
  return(data)
}

# files_results_dt ----
files_results_dt <- function(data) {
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
          filename = "base_de_datos_archivos"
        ),
        list(
          extend = "excel",
          filename = "base_de_datos_archivos"
        )
      ),
      scrollX = TRUE,
      scrollY = "600px",
      pageLength = 25
    )
  )
  return(data)
}

# files_cases_dt ----
files_cases_dt <- function(data) {
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
          filename = "mapeo_archivos_casos_proyecto"
        ),
        list(
          extend = "excel",
          filename = "mapeo_archivos_casos_proyecto"
        )
      ),
      scrollX = TRUE,
      scrollY = "600px",
      pageLength = 25
    )
  )
  return(data)
}
