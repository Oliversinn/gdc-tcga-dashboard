# Author: Oliver Mazariegos
# Last Update: 2023-12-14
# R 4.3.1

fluidPage(
  # Header ----
  fluidRow(
    box(
      width = 12, background = "maroon",
      HTML(
        paste0(
          "<center><div style = 'text-align: left; padding-left: 30px;
          padding-right: 30px; padding-top: 10px;'><img src='",
          "uoc_logo.jpg' height='50'>  <img id='oliver_logo'
          style = 'right: 30px !important; position: absolute; padding-top: 1px;
          padding-bottom: 1px; padding-right: 1px; padding-left: 1px;
          margin-bottom: 10px; background-color: transperent;'
          src='oliver_logo_blanco.png' height='50'></div>",
          "<h2>Explorador de GDC - TCGA</h2> </center>"
        )
      )
    )
  ),
  dashboardPage(
    skin = "purple",
    title = "Skin title",
    # Dashboard header ----
    header = dashboardHeader(
      titleWidth = 300,
      title = "Header title"
    ),
    # Dashboard sidebar ----
    sidebar = dashboardSidebar(
      width = 300,
      sidebarMenu(
        id = "sidebarid",
        ## Global filters ----
        ### project_id ----
        selectInput(
          "project_id",
          label = "Poject ID",
          choices = c("Project 1", "Project 2"),
          selected = "Project 1"
        ),
        bsTooltip(
          "project_id",
          "Seleccionar un proyecto",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### primary_diagnosis ----
        selectInput(
          "primary_diagnosis",
          label = "Primary diagnosis",
          choices = c("Diagnosis 1", "Diagnosis 2"),
          selected = "Diagnosis 1"
        ),
        bsTooltip(
          "primary_diagnosis",
          "Seleccionar un primary diagnosis",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### primary_site ----
        selectInput(
          "primary_site",
          label = "Primary site",
          choices = c("Site 1", "Site 2"),
          selected = "Site 1"
        ),
        bsTooltip(
          "primary_site",
          "Seleccionar un primary site",
          placement = "right", trigger = "hover", options = NULL
        ),
        ## Initial tab ----
        menuItem(
          text = "Explorador",
          tabName = "EXPLORADOR",
          icon = icon("square-check")
        )
      )
    ),
    # Dashboard body ----
    dashboardBody(
      fluidPage(
        tags$head(tags$script(src = "message-handler.js")),
        tags$head(
          tags$link(
            rel = "stylesheet", type = "text/css", href = "style.css"
          )
        ),
        tabItems(
          ## Tab EXPLORER ----
          tabItem(
            tabName = "EXPLORER",
            h2("Explorador de datos")
          )
        )
      )
    )
  )
)
