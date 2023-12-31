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
    combined_demographics_reactive <- combined_demographics
    
    if (input$age_at_index_na) {
      combined_demographics_reactive <- combined_demographics_reactive %>% 
        dplyr::filter(
          (age_at_index >= input$age_at_index[1] &
             age_at_index <= input$age_at_index[2]) |
            is.na(age_at_index)
        )
    } else {
      combined_demographics_reactive <- combined_demographics_reactive %>% 
        dplyr::filter(
          !is.na(age_at_index),
          (age_at_index >= input$age_at_index[1] &
             age_at_index <= input$age_at_index[2])
        )
    }
    
    if (input$race != "TODOS") {
      combined_demographics_reactive <- combined_demographics_reactive %>% 
        dplyr::filter(
          race == input$race
        )
    }
    
    if (input$ethnicity != "TODOS") {
      combined_demographics_reactive <- combined_demographics_reactive %>% 
        dplyr::filter(
          ethnicity == input$ethnicity
        )
    }
    
    if (input$vital_status != "TODOS") {
      combined_demographics_reactive <- combined_demographics_reactive %>% 
        dplyr::filter(
          vital_status == input$vital_status
        )
    }
    
    if (input$gender != "TODOS") {
      combined_demographics_reactive <- combined_demographics_reactive %>% 
        dplyr::filter(
          gender == input$gender
        )
    }
    
    combined_demographics_reactive
  })
  
  ## combined_diagnosis_reactive ----
  combined_diagnoses_reactive <- reactive({
    combined_diagnoses_reactive <- combined_diagnoses
    
    if (input$age_at_diagnosis_na) {
      combined_diagnoses_reactive <- combined_diagnoses_reactive %>% 
        dplyr::filter(
          (age_at_diagnosis_years >= input$age_at_diagnosis[1] &
            age_at_diagnosis_years <= input$age_at_diagnosis[2]) |
            is.na(age_at_diagnosis_years)
        )
    } else {
      combined_diagnoses_reactive <- combined_diagnoses_reactive %>% 
        dplyr::filter(
          !is.na(age_at_diagnosis_years),
          (age_at_diagnosis_years >= input$age_at_diagnosis[1] &
             age_at_diagnosis_years <= input$age_at_diagnosis[2])
        )
    }
    
    if (input$tissue_or_organ_of_origin != "TODOS")
      combined_diagnoses_reactive <- combined_diagnoses_reactive %>% 
        dplyr::filter(
          tissue_or_organ_of_origin == input$tissue_or_organ_of_origin
        )
    
    if (input$primary_diagnosis != "TODOS") {
      combined_diagnoses_reactive <- combined_diagnoses_reactive %>% 
        dplyr::filter(
          primary_diagnosis == input$primary_diagnosis
        )
    }
    
    if (input$ajcc_pathologic_stage != "TODOS") {
      combined_diagnoses_reactive <- combined_diagnoses_reactive %>% 
        dplyr::filter(
          ajcc_pathologic_stage == input$ajcc_pathologic_stage
        )
    }
    
    combined_diagnoses_reactive
  })
  
  ## case_ids_list ----
  case_ids <- reactiveValues()
  case_ids$case_id <- case_id_list
  ### Observers ----
  

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
  
  # tissue_or_organ_of_origin filter ----
  tissue_or_organ_of_origin_reactive <- reactive({
    unique(combined_diagnoses_reactive()$tissue_or_organ_of_origin)
    
  })
  
  tissue_or_organ_of_origin_list <- reactive({
    c("TODOS", tissue_or_organ_of_origin_reactive())
  })
  
  observe({
    updateSelectInput(
      session,
      "tissue_or_organ_of_origin",
      choices = tissue_or_organ_of_origin_list(),
      selected = input$tissue_or_organ_of_origin
    )
  })
  
  # primary_diagnosis filter ----
  primary_diagnosis_reactive <- reactive({
    unique(combined_diagnoses_reactive()$primary_diagnosis)
    
  })
  
  primary_diagnosis_list <- reactive({
    c("TODOS", primary_diagnosis_reactive())
  })
  
  observe({
    updateSelectInput(
      session,
      "primary_diagnosis",
      choices = primary_diagnosis_list(),
      selected = input$primary_diagnosis
    )
  })
  
  # ajcc_pathologic_stage_reactive filter ----
  ajcc_pathologic_stage_reactive <- reactive({
    unique(combined_diagnoses_reactive()$ajcc_pathologic_stage)
    
  })
  
  ajcc_pathologic_stage_list <- reactive({
    c("TODOS", ajcc_pathologic_stage_reactive())
  })
  
  observe({
    updateSelectInput(
      session,
      "ajcc_pathologic_stage",
      choices = ajcc_pathologic_stage_list(),
      selected = input$ajcc_pathologic_stage
    )
  })
  
  # race_reactive filter ----
  race_reactive <- reactive({
    unique(combined_demographics_reactive()[
      !is.na(combined_demographics_reactive()$race),
      "race"
    ])
    
  })
  
  race_list <- reactive({
    c("TODOS", race_reactive())
  })
  
  observe({
    updateSelectInput(
      session,
      "race",
      choices = race_list(),
      selected = input$race
    )
  })
  
  # ethnicity_reactive filter ----
  ethnicity_reactive <- reactive({
    unique(combined_demographics_reactive()[
      !is.na(combined_demographics_reactive()$ethnicity),
      "ethnicity"
    ])
    
  })
  
  ethnicity_list <- reactive({
    c("TODOS", ethnicity_reactive())
  })
  
  observe({
    updateSelectInput(
      session,
      "ethnicity",
      choices = ethnicity_list(),
      selected = input$ethnicity
    )
  })
  
  # vital_status_reactive filter ----
  vital_status_reactive <- reactive({
    unique(combined_demographics_reactive()[
      !is.na(combined_demographics_reactive()$vital_status),
      "vital_status"
    ])
    
  })
  
  vital_status_list <- reactive({
    c("TODOS", vital_status_reactive())
  })
  
  observe({
    updateSelectInput(
      session,
      "vital_status",
      choices = vital_status_list(),
      selected = input$vital_status
    )
  })
  
  # gender_reactive filter ----
  gender_reactive <- reactive({
    unique(combined_demographics_reactive()[
      !is.na(combined_demographics_reactive()$gender),
      "gender"
    ])
    
  })
  
  gender_list <- reactive({
    c("TODOS", gender_reactive())
  })
  
  observe({
    updateSelectInput(
      session,
      "gender",
      choices = gender_list(),
      selected = input$gender
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
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id,
          "disease_type"
        ]
      )
    )
    
    
  })
  
  #### Observe disease_type ----
  observeEvent(input$disease_type, {
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "disease_type"
        ]
      )
    )
    
  })
  
  #### Observe primary_site ----
  observeEvent(input$primary_site, {
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id,
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "disease_type"
        ]
      )
    )
    
  })
  
  #### Observe age_at_diagnosis ----
  observeEvent(input$age_at_diagnosis, {
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id,
          "disease_type"
        ]
      )
    )
  })
  
  #### Observe age_at_diagnosis_na ----
  observeEvent(input$age_at_diagnosis_na, {
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id,
          "disease_type"
        ]
      )
    )
  })
  
  #### Observe tissue_or_organ_of_origin ----
  observeEvent(input$tissue_or_organ_of_origin, {
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id,
          "disease_type"
        ]
      )
    )
  })
  
  #### Observe primary_diagnosis ----
  observeEvent(input$primary_diagnosis, {
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id,
          "disease_type"
        ]
      )
    )
  })
  
  #### Observe ajcc_pathologic_stage ----
  observeEvent(input$ajcc_pathologic_stage, {
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id,
          "disease_type"
        ]
      )
    )
  })
  
  #### Observe race ----
  observeEvent(input$race, {
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id,
          "disease_type"
        ]
      )
    )
  })
  
  #### Observe ethnicity ----
  observeEvent(input$ethnicity, {
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id,
          "disease_type"
        ]
      )
    )
  })
  
  #### Observe vital_status ----
  observeEvent(input$vital_status, {
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id,
          "disease_type"
        ]
      )
    )
  })
  
  #### Observe gender ----
  observeEvent(input$gender, {
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id,
          "disease_type"
        ]
      )
    )
  })
  
  #### Observe age_at_index ----
  observeEvent(input$age_at_index, {
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id,
          "disease_type"
        ]
      )
    )
  })
  
  #### Observe age_at_index_na ----
  observeEvent(input$age_at_index_na, {
    case_ids$case_id <- unique(
      intersect(
        intersect(
          combined_diagnoses_reactive()$case_id,
          combined_demographics_reactive()$case_id 
        ),
        combined_cases_reactive()$case_id
      )
    )
    box_data$proyectos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "project_id"
        ]
      )
    )
    box_data$casos <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id, 
          "case_id"
        ]
      )
    )
    box_data$disease_type <- length(
      unique(
        combined_cases_reactive()[
          combined_cases_reactive()$case_id %in% case_ids$case_id,
          "disease_type"
        ]
      )
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
    project_disease_type_treemap(
      combined_cases_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### project_disease_type_treedt ----
  output$project_disease_type_treedt <- DT::renderDataTable({
    project_disease_type_treedt(
      combined_cases_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### project_bar ----
  output$project_bar <- renderPlotly({
    project_bar(
      combined_cases_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### project_bardt ----
  output$project_bardt <- DT::renderDataTable({
    project_bardt(
      combined_cases_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### disease_type ----
  output$disease_type_bar <- renderPlotly({
    disease_type_bar(
      combined_cases_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### disease_typedt ----
  output$disease_type_bardt <- DT::renderDataTable({
    disease_type_bardt(
      combined_cases_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### primary_site_bar ----
  output$primary_site_bar <- renderPlotly({
    primary_site_bar(
      combined_cases_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### primary_site_bardt ----
  output$primary_site_bardt <- DT::renderDataTable({
    primary_site_bardt(
      combined_cases_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  ### Diagnosis ----
  #### primary_diagnosis_treemap ----
  output$primary_diagnosis_treemap <- renderPlotly({
    primary_diagnosis_treemap(
      combined_diagnoses_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### primary_diagnosis_treedt ----
  output$primary_diagnosis_treedt <- DT::renderDataTable({
    primary_diagnosis_treedt(
      combined_diagnoses_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### pathologic_stage_treemap ----
  output$pathologic_stage_treemap <- renderPlotly({
    pathologic_stage_treemap(
      combined_diagnoses_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### pathologic_stage_treedt ----
  output$pathologic_stage_treedt <- DT::renderDataTable({
    pathologic_stage_treedt(
      combined_diagnoses_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### tissue_origin_bar ----
  output$tissue_origin_bar <- renderPlotly({
    tissue_origin_bar(
      combined_diagnoses_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### tissue_origin_bardt ----
  output$tissue_origin_bardt <- DT::renderDataTable({
    tissue_origin_bardt(
      combined_diagnoses_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### primary_diagnosis_bar ----
  output$primary_diagnosis_bar <- renderPlotly({
    primary_diagnosis_bar(
      combined_diagnoses_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### primary_diagnosis_bardt ----
  output$primary_diagnosis_bardt <- DT::renderDataTable({
    primary_diagnosis_bardt(
      combined_diagnoses_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### pathologic_stage_bar ----
  output$pathologic_stage_bar <- renderPlotly({
    pathologic_stage_bar(
      combined_diagnoses_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### pathologic_stage_bardt ----
  output$pathologic_stage_bardt <- DT::renderDataTable({
    pathologic_stage_bardt(
      combined_diagnoses_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### age_at_diagnosis_bar ----
  output$age_at_diagnosis_bar <- renderPlotly({
    age_at_diagnosis_bar(
      combined_diagnoses_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### age_at_diagnosis_bardt ----
  output$age_at_diagnosis_bardt <- DT::renderDataTable({
    age_at_diagnosis_bardt(
      combined_diagnoses_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  ## Demographics ----
  #### race_pie ----
  output$race_pie <- renderPlotly({
    race_pie(
      combined_demographics_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### race_piedt ----
  output$race_piedt <- DT::renderDataTable({
    race_piedt(
      combined_demographics_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### ethnicity_pie ----
  output$ethnicity_pie <- renderPlotly({
    ethnicity_pie(
      combined_demographics_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### ethnicity_piedt ----
  output$ethnicity_piedt <- DT::renderDataTable({
    ethnicity_piedt(
      combined_demographics_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### vital_status_pie ----
  output$vital_status_pie <- renderPlotly({
    vital_status_pie(
      combined_demographics_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### vital_status_piedt ----
  output$vital_status_piedt <- DT::renderDataTable({
    vital_status_piedt(
      combined_demographics_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### gender_age_pyramid ----
  output$gender_age_pyramid <- renderPlotly({
    gender_age_pyramid(
      combined_demographics_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  
  #### gender_age_pyramiddt ----
  output$gender_age_pyramiddt <- DT::renderDataTable({
    gender_age_pyramiddt(
      combined_demographics_reactive() %>% 
        dplyr::filter(
          case_id %in% case_ids$case_id
        )
    )
  })
  

  
}
