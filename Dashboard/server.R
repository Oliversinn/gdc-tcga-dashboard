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
  
  ## combined_cases_reactive ----
  combined_cases_reactive <- reactive({
    combined_cases_reactive <- combined_cases
    
    if(input$project_id != "TODOS") {
      combined_cases_reactive <- combined_cases_reactive %>% 
        dplyr::filter(project_id == input$project_id)
    }
    
    if (input$disease_type != "TODOS") {
      combined_cases_reactive <- combined_cases_reactive %>% 
        dplyr::filter(disease_type == input$disease_type)
    }
    
    if (input$primary_site != "TODOS") {
      combined_cases_reactive <- combined_cases_reactive %>% 
      dplyr::filter(primary_site == input$primary_site)
    }
    combined_cases_reactive
  })
  
  ## combined_demographics_reactive ----
  combined_demographics_reactive <- reactive({
    combined_demographics_reactive <- combined_demographics[
      combined_cases_reactive()$case_id,
    ]
    combined_demographics_reactive
  })
  
  ## combined_diagnosis_reactive ----
  combined_diagnoses_reactive <- reactive({
    combined_diagnoses_reactive <- combined_diagnoses[
      combined_diagnoses
    ]
    combined_diagnoses_reactive
  })

  ## disease_type filter ----
  diseases_types_reactive <- reactive({
    unique(combined_cases_reactive()$disease_type)
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
    unique(combined_cases_reactive()$primary_site)
    
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
  
  ## Explorer ----
  ### Value boxes ----
  box_data <- reactiveValues()
  box_data$proyectos <- 0
  box_data$casos <- 0
  box_data$disease_type <- 0
  
  #### Observe project_id ----
  observeEvent(input$project_id, {
    box_data$proyectos <- length(
      unique(combined_cases_reactive()$project_id)
    )
    box_data$casos <- length(
      unique(combined_cases_reactive()$case_id)
    )
    box_data$disease_type <- length(
      unique(combined_cases_reactive()$disease_type)
    )
  })
  
  #### Observe disease_type ----
  observeEvent(input$disease_type, {
    box_data$proyectos <- length(
      unique(combined_cases_reactive()$project_id)
    )
    box_data$casos <- length(
      unique(combined_cases_reactive()$case_id)
    )
    box_data$disease_type <- length(
      unique(combined_cases_reactive()$disease_type)
    )
  })
  
  #### Observe primary_site ----
  observeEvent(input$primary_site, {
    box_data$proyectos <- length(
      unique(combined_cases_reactive()$project_id)
    )
    box_data$casos <- length(
      unique(combined_cases_reactive()$case_id)
    )
    box_data$disease_type <- length(
      unique(combined_cases_reactive()$disease_type)
    )
  })
  
  #### Boxes ----
  ##### Proyectos ----
  output$box_proyectos <- renderValueBox({
    valueBox(
      vb_style(
        box_data$proyectos, "font-size: 90%;"
      ),
      vb_style(
        "Número de proyectos", "font-size: 95%;"
      ),
      icon = icon("wand-magic-sparkles"),
      color = "purple"
    )
  })
  
  ##### Casos ----
  output$box_casos <- renderValueBox({
    valueBox(
      vb_style(
        box_data$casos, "font-size: 90%;"
      ),
      vb_style(
        "Número de casos", "font-size: 95%;"
      ),
      icon = icon("user"),
      color = "purple"
    )
  })
  
  ##### disease_type ----
  output$box_disease_type <- renderValueBox({
    valueBox(
      vb_style(
        box_data$disease_type, "font-size: 90%;"
      ),
      vb_style(
        "Número de tipos de enfermedad", "font-size: 95%;"
      ),
      icon = icon("disease"),
      color = "purple"
    )
  })
  
  ### Project ----
  #### project_disease_type_treemap ----
  output$project_disease_type_treemap <- renderPlotly({
    project_disease_type_treemap(combined_cases_reactive())
  })
  
  #### project_disease_type_treedt ----
  output$project_disease_type_treedt <- DT::renderDataTable({
    project_disease_type_treedt(combined_cases_reactive())
  })
  
  #### project_bar ----
  output$project_bar <- renderPlotly({
    project_bar(combined_cases_reactive())
  })
  
  #### project_bardt ----
  output$project_bardt <- DT::renderDataTable({
    project_bardt(combined_cases_reactive())
  })
  
  #### disease_type ----
  output$disease_type_bar <- renderPlotly({
    disease_type_bar(combined_cases_reactive())
  })
  
  #### disease_typedt ----
  output$disease_type_bardt <- DT::renderDataTable({
    disease_type_bardt(combined_cases_reactive())
  })
  
  #### primary_site_bar ----
  output$primary_site_bar <- renderPlotly({
    primary_site_bar(combined_cases_reactive())
  })
  
  #### primary_site_bardt ----
  output$primary_site_bardt <- DT::renderDataTable({
    primary_site_bardt(combined_cases_reactive())
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
    aggregation_substr_barplot(
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

  ## primary_diagnosis ----
  ### barplot ----
  output$primary_diagnosis_barplot <- renderPlotly({
    aggregation_substr_barplot(
      head(explorer_data_reactive()$diagnoses.primary_diagnosis, 30),
      "Diagnóstico primario"
    )
  })

  ### datatable ----
  output$primary_diagnosis_dt <- renderDataTable({
    aggregation_dt(
      explorer_data_reactive()$diagnoses.primary_diagnosis,
      "Diagnóstico primario",
      "casos_por_diagnostico_primario"
    )
  })

  ## site_of_resection_or_biopsy ----
  ### barplot ----
  output$resection_site_barplot <- renderPlotly({
    aggregation_substr_barplot(
      head(explorer_data_reactive()$diagnoses.site_of_resection_or_biopsy, 30),
      "Sitio de Resección o Biopsia"
    )
  })

  ### datatable ----
  output$resection_site_dt <- renderDataTable({
    aggregation_dt(
      explorer_data_reactive()$diagnoses.site_of_resection_or_biopsy,
      "Sitio de Resección o Biopsia",
      "casos_por_sitio_de_reseccion_o_biopsia"
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
      "Género",
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
