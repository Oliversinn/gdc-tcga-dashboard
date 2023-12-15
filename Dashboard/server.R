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
}
