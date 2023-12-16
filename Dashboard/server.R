function(input, output, session) {
  # Filters ---
  ## projects_reactive ----
  projects_reactive <- reactive({
    projects <- GenomicDataCommons::projects() %>%
      GenomicDataCommons::filter(program.name == "TCGA") %>%
      GenomicDataCommons::facet(c("name", "project_id"))

    if (input$project_id != "TODOS") {
      projects <- projects %>%
        GenomicDataCommons::filter(project_id == input$project_id)
    }

    if (input$disease_type != "TODOS") {
      projects <- projects %>%
        GenomicDataCommons::filter(disease_type == input$disease_type)
    }

    if (input$primary_site != "TODOS") {
      projects <- projects %>%
        GenomicDataCommons::filter(primary_site == input$primary_site)
    }

    projects <- projects %>%
      GenomicDataCommons::results_all()
  })

  ## disease_type filter ----
  diseases_types_reactive <- reactive({
    unique(
      rapply(projects_reactive()$disease_type, function(x) head(x, 100))
    )
  })

  diseases_types_list <- reactive({
    c("TODOS", diseases_types_reactive())
  })

  observe({
    updateSelectInput(
      session,
      "disease_type",
      choices = diseases_types_list(),
      selected = input$disease_type
    )
  })

  # primary_site filter ----
  primary_site_reactive <- reactive({
    unique(
      rapply(projects_reactive()$primary_site, function(x) head(x, 100))
    )
  })

  primary_site_list <- reactive({
    c("TODOS", primary_site_reactive())
  })

  observe({
    updateSelectInput(
      session,
      "primary_site",
      choices = primary_site_list(),
      selected = input$primary_site
    )
  })

  # Explorer data ----
  explorer_data_reactive <- reactive({
    cases_info <- GenomicDataCommons::cases()

    if (input$project_id == "TODOS") {
      cases_info <- cases_info %>%
        GenomicDataCommons::filter(
          ~ project.project_id %in% tcga_project_ids_list
        )
    } else {
      cases_info <- cases_info %>%
        GenomicDataCommons::filter(
          ~ project.project_id == input$project_id
        )
    }

    if (input$disease_type != "TODOS") {
      cases_info <- cases_info %>%
        GenomicDataCommons::filter(
          project.disease_type == input$disease_type
        )
    }

    if (input$primary_site != "TODOS") {
      cases_info <- cases_info %>%
        GenomicDataCommons::filter(
          project.primary_site == input$primary_site
        )
    }

    cases_info <- cases_info %>%
      GenomicDataCommons::facet(c(
        "project.project_id",
        "demographic.race",
        "demographic.gender",
        "demographic.ethnicity",
        "demographic.vital_status",
        "diagnoses.primary_diagnosis",
        "diagnoses.site_of_resection_or_biopsy",
        "primary_site"
      )) %>%
      aggregations()
  })

  ## project_id ----
  ### barplot ----
  output$project_id_barplot <- renderPlotly({
    project_id_barplot(explorer_data_reactive()$project.project_id)
  })

  ### datatable ----
  output$project_id_dt <- renderDataTable({
    project_id_dt(explorer_data_reactive()$project.project_id)
  })

  ## primary_site ----
  ### barplot ----
  output$primary_site_barplot <- renderPlotly({
    primary_site_barplot(
      head(explorer_data_reactive()$primary_site, 30),
      "Sitio primario"
    )
  })

  ### datatable ----
  output$primary_site_dt <- renderDataTable({
    aggregation_dt(
      explorer_data_reactive()$primary_site,
      "Sitio primario",
      "casos_por_sitio_primario"
    )
  })

  ## race ----
  ### barplot ----
  output$race_barplot <- renderPlotly({
    aggregation_barplot(
      explorer_data_reactive()$demographic.race,
      "Raza"
    )
  })

  ### datatable ----
  output$race_dt <- renderDataTable({
    aggregation_dt(
      explorer_data_reactive()$demographic.race,
      "Raza",
      "casos_por_raza"
    )
  })

  ## ethnicity ----
  ### barplot ----
  output$ethnicity_barplot <- renderPlotly({
    aggregation_barplot(
      explorer_data_reactive()$demographic.ethnicity,
      "Etnia"
    )
  })

  ### datatable ----
  output$ethnicity_dt <- renderDataTable({
    aggregation_dt(
      explorer_data_reactive()$demographic.ethnicity,
      "Etnia",
      "casos_por_etnia"
    )
  })

  ## gender ----
  ### barplot ----
  output$gender_pie <- renderPlotly({
    gender_pie(
      explorer_data_reactive()$demographic.gender
    )
  })

  ### datatable ----
  output$gender_dt <- renderDataTable({
    aggregation_dt(
      explorer_data_reactive()$demographic.gender,
      "Genero",
      "casos_por_genero"
    )
  })

  ## vital_status ----
  ### barplot ----
  output$vital_status_pie <- renderPlotly({
    vital_status_pie(
      explorer_data_reactive()$demographic.vital_status
    )
  })

  ### datatable ----
  output$vital_status_dt <- renderDataTable({
    aggregation_dt(
      explorer_data_reactive()$demographic.vital_status,
      "Estado vital",
      "casos_por_estado_vital"
    )
  })
}
