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
          "<h2>Explorador de Datos de GDC - TCGA</h2> </center>"
        )
      )
    )
  ),
  dashboardPage(
    skin = "purple",
    title = "GDC - TCGA",
    # Dashboard header ----
    header = dashboardHeader(
      titleWidth = 300,
      title = "Control de Mando"
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
          label = "Proyecto",
          choices = tcga_project_ids_list,
          selected = tcga_project_ids_list[1]
        ),
        bsTooltip(
          "project_id",
          "Seleccionar un proyecto",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### primary_site ----
        selectInput(
          "primary_site",
          label = "Sitio primario",
          choices = c("TODOS"),
          selected = "TODOS"
        ),
        bsTooltip(
          "primary_site",
          "Seleccionar un primary site",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### disease_type ----
        selectInput(
          "disease_type",
          label = "Tipo de enfermedad",
          choices = c("TODOS"),
          selected = "TODOS"
        ),
        bsTooltip(
          "disease_type",
          "Seleccionar un tipo de enfermedad",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### age_at_diagnosis ----
        sliderInput(
          "age_at_diagnosis",
          label = "Edad al diagnostico",
          min = min_diagnosis_age,
          max = max_diagnosis_age,
          value = c(min_diagnosis_age,max_diagnosis_age)
        ),
        bsTooltip(
          "disease_type",
          "Seleccionar un rango de edad",
          placement = "right", trigger = "hover", options = NULL
        ),
        checkboxInput(
          "age_at_diagnosis_na",
          "Incluir NAs en Edad al diagnositico",
          value = TRUE
        ),
        ### tissue_or_organ_of_origin ----
        selectInput(
          "tissue_or_organ_of_origin",
          label = "Tejido u órgano de origen",
          choices = c("TODOS"),
          selected = "TODOS"
        ),
        bsTooltip(
          "tissue_or_organ_of_origin",
          "Seleccionar un tejido u órgano de origen",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### primary_diagnosis ----
        selectInput(
          "primary_diagnosis",
          label = "Diagnóstico primario",
          choices = c("TODOS"),
          selected = "TODOS"
        ),
        bsTooltip(
          "primary_diagnosis",
          "Seleccionar un tejido u diagnóstico primario",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### ajcc_pathologic_stage ----
        selectInput(
          "ajcc_pathologic_stage",
          label = "Etapa patológica",
          choices = c("TODOS"),
          selected = "TODOS"
        ),
        bsTooltip(
          "ajcc_pathologic_stage",
          "Seleccionar una etapa patológica",
          placement = "right", trigger = "hover", options = NULL
        ),
        ## Initial tab ----
        menuItem(
          text = "Explorador",
          tabName = "EXPLORADOR",
          icon = icon("square-check")
        ),
        menuItem(
          text = "Explorador_old",
          tabName = "EXPLORADOROLD",
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
          ## Tab EXPLORADOR ----
          tabItem(
            tabName = "EXPLORADOR",
            fluidRow(
              valueBoxOutput("box_proyectos", width = 4),
              valueBoxOutput("box_casos", width = 4),
              valueBoxOutput("box_disease_type", width = 4)
            ),
            fluidRow(
              width = 12,
              box(
                width = 12,
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Información sobre los proyectos",
                tabBox(
                  width = 12,
                  height = NULL,
                  ### project_disease_type_treemap ----
                  tabPanel(
                    title = "Mapa de arbol",
                    icon = icon("table-cells"),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "project_disease_type_treemap",
                        height = 500
                      ),
                      color = "#1c9ad6", type = "8", size = 0.5
                    ),
                    tags$caption(
                      class = "text-center",
                      style = "caption-side: bottom; text-align: center;",
                      em("Prueba hacer click para expandir la información")
                    )
                  ),
                  ### project_disease_type_treedt ----
                  tabPanel(
                    title = "Cuadro de datos del mapa de arbol",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("project_disease_type_treedt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  ### project_bar ----
                  tabPanel(
                    title = "Gráfico de barras por proyecto",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Proyecto"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("project_bar", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  ### project_bardt ----
                  tabPanel(
                    title = "Cuadro de datos por proyecto",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("project_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  ### disease_type_bar ----
                  tabPanel(
                    title = "Gráfico de barras por Tipo de Enfermedad",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Tipo de Enfermedad"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("disease_type_bar", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  ### disease_type_bardt ----
                  tabPanel(
                    title = "Cuadro de datos por tipo de enfermedad",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("disease_type_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  ### primary_site_bar ----
                  tabPanel(
                    title = "Gráfico de barras por sitio primario",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Sitio Primario"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("primary_site_bar", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  ### primary_site_bardt ----
                  tabPanel(
                    title = "Cuadro de datos por sitio primario",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("primary_site_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              )
            ),
            fluidRow(
              width = 12,
              box(
                width = 12,
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Información sobre los diagnósticos",
                tabBox(
                  width = 12,
                  height = NULL,
                  ### primary_diagnosis_treemap ----
                  tabPanel(
                    title = "Mapa de arbol de tejidos y diagnósticos",
                    icon = icon("table-cells"),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "primary_diagnosis_treemap",
                        height = 500
                      ),
                      color = "#1c9ad6", type = "8", size = 0.5
                    ),
                    tags$caption(
                      class = "text-center",
                      style = "caption-side: bottom; text-align: center;",
                      em("Prueba hacer click para expandir la información")
                    )
                  ),
                  ### primary_diagnosis_treedt ----
                  tabPanel(
                    title = paste0(
                      "Cuadro de datos del mapa de arbol de",
                      " tejido y diagnóstico"
                    ),
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("primary_diagnosis_treedt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  ### primary_stage_treemap ----
                  tabPanel(
                    title = "Mapa de arbol de tejidos y etapa patológica",
                    icon = icon("table-cells"),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "pathologic_stage_treemap",
                        height = 500
                      ),
                      color = "#1c9ad6", type = "8", size = 0.5
                    ),
                    tags$caption(
                      class = "text-center",
                      style = "caption-side: bottom; text-align: center;",
                      em("Prueba hacer click para expandir la información")
                    )
                  ),
                  ### primary_stage_treedt ----
                  tabPanel(
                    title = paste0(
                      "Cuadro de datos del mapa de arbol de",
                      "tejido y etapa patológica"
                    ),
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("pathologic_stage_treedt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  ### tissue_origin_bar ----
                  tabPanel(
                    title = "Gráfico de barras por tejido de origen",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Tejido u Organo de Origen"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("tissue_origin_bar", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    ),
                    tags$caption(
                      class = "text-center",
                      style = "caption-side: bottom; text-align: center;",
                      em("Se muestran como máximo los 30 con más casos.")
                    )
                  ),
                  ### tissue_origin_bardt ----
                  tabPanel(
                    title = "Cuadro de datos por tejido de origen",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("tissue_origin_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  ### primary_diagnosis_bar ----
                  tabPanel(
                    title = "Gráfico de barras por diagnóstico primario",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Diagnóstico Primario"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("primary_diagnosis_bar", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    ),
                    tags$caption(
                      class = "text-center",
                      style = "caption-side: bottom; text-align: center;",
                      em("Se muestran como máximo los 30 con más casos.")
                    )
                  ),
                  ### primary_diagnosis_bardt ----
                  tabPanel(
                    title = "Cuadro de datos por diagnóstico primario",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("primary_diagnosis_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  ### pathologic_stage_bar ----
                  tabPanel(
                    title = "Gráfico de barras por etapa patológica",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Etapa Patológica"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("pathologic_stage_bar", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  ### pathologic_stage_bardt ----
                  tabPanel(
                    title = "Cuadro de datos por etapa patológica",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("pathologic_stage_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              )
            )
          ),
          ## Tab EXPLORADOROLD ----
          tabItem(
            tabName = "EXPLORADOROLD",
            h2("Proyectos"),
            br(),
            fluidRow(
              width = 12,
              ### project_id ----
              box(
                width = 6,
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Número de casos por proyecto",
                tabBox(
                  width = 12,
                  height = NULL,
                  #### barplot ----
                  tabPanel(
                    title = "Gráfico de barras",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Proyecto"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("project_id_barplot", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### datatable ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      dataTableOutput("project_id_dt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              ),
              ### primary_site ----
              box(
                width = 6,
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Número de casos por Sitio Primario",
                tabBox(
                  width = 12,
                  height = NULL,
                  #### barplot ----
                  tabPanel(
                    title = "Gráfico de barras",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Sitio Primario (top 30)"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("primary_site_barplot", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### datatable ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      dataTableOutput("primary_site_dt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              )
            ),
            fluidRow(
              width = 12,
              ### primary_diagnosis ----
              box(
                width = 6,
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Número de casos por diagnóstico primario",
                tabBox(
                  width = 12,
                  height = NULL,
                  #### barplot ----
                  tabPanel(
                    title = "Gráfico de barras",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Diagnóstico Primario (top 30)"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("primary_diagnosis_barplot", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### datatable ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      dataTableOutput("primary_diagnosis_dt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              ),
              ### site_of_resection_or_biopsy ----
              box(
                width = 6,
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Número de casos por sitio de resección o biopsia",
                tabBox(
                  width = 12,
                  height = NULL,
                  #### barplot ----
                  tabPanel(
                    title = "Gráfico de barras",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      paste0(
                        "Número de Casos por ",
                        "Sitio de Resección o Biopsia (top 30)"
                      )
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("resection_site_barplot", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### datatable ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      dataTableOutput("resection_site_dt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              )
            ),
            h2("Demografía"),
            br(),
            fluidRow(
              ### race ----
              box(
                width = 6,
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Número de Casos por Raza",
                tabBox(
                  width = 12,
                  height = NULL,
                  #### barplot ----
                  tabPanel(
                    title = "Gráfico de barras",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Raza"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("race_barplot", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### datatable ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      dataTableOutput("race_dt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              ),
              ### ethnicity ----
              box(
                width = 6,
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Número de Casos por Etnia",
                tabBox(
                  width = 12,
                  height = NULL,
                  #### barplot ----
                  tabPanel(
                    title = "Gráfico de barras",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Etnia"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("ethnicity_barplot", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### datatable ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      dataTableOutput("ethnicity_dt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              )
            ),
            fluidRow(
              ### gender ----
              box(
                width = 6,
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Número de Casos por Género",
                tabBox(
                  width = 12,
                  height = NULL,
                  #### barplot ----
                  tabPanel(
                    title = "Gráfico de barras",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Género"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("gender_pie", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### datatable ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      dataTableOutput("gender_dt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              ),
              ### vital_status ----
              box(
                width = 6,
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Número de Casos por Estado Vital",
                tabBox(
                  width = 12,
                  height = NULL,
                  #### barplot ----
                  tabPanel(
                    title = "Gráfico de barras",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Estado Vital"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("vital_status_pie", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### datatable ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      dataTableOutput("vital_status_dt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              )
            )
          )
        )
      )
    )
  )
)
