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
        ## Cases filters ----
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
        ### age_at_diagnosis ----
        sliderInput(
          "age_at_diagnosis",
          label = "Edad al diagnostico",
          min = min_diagnosis_age,
          max = max_diagnosis_age,
          value = c(min_diagnosis_age, max_diagnosis_age)
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
        ### race ----
        selectInput(
          "race",
          label = "Raza",
          choices = c("TODOS"),
          selected = "TODOS"
        ),
        bsTooltip(
          "race",
          "Seleccionar una raza",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### ethnicity ----
        selectInput(
          "ethnicity",
          label = "Etnicidad",
          choices = c("TODOS"),
          selected = "TODOS"
        ),
        bsTooltip(
          "ethnicity",
          "Seleccionar una etnicidad",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### vital_status ----
        selectInput(
          "vital_status",
          label = "Estado vital",
          choices = c("TODOS"),
          selected = "TODOS"
        ),
        bsTooltip(
          "vital_status",
          "Seleccionar un estado vital",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### gender ----
        selectInput(
          "gender",
          label = "Género",
          choices = c("TODOS"),
          selected = "TODOS"
        ),
        bsTooltip(
          "gender",
          "Seleccionar un género",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### age_at_index ----
        sliderInput(
          "age_at_index",
          label = "Edad",
          min = min_age,
          max = max_age,
          value = c(min_diagnosis_age, max_diagnosis_age)
        ),
        bsTooltip(
          "age_at_index",
          "Seleccionar una edad",
          placement = "right", trigger = "hover", options = NULL
        ),
        checkboxInput(
          "age_at_index_na",
          "Incluir NAs en Edad",
          value = TRUE
        ),
        ## Files filters ----
        ### experimental_strategy ----
        selectInput(
          "experimental_strategy",
          label = "Estrategía experimental",
          choices = c("TODOS"),
          selected = "TODOS"
        ),
        bsTooltip(
          "experimental_strategy",
          "Seleccionar una estrategía",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### data_category ----
        selectInput(
          "data_category",
          label = "Categoría de dato",
          choices = c("TODOS"),
          selected = "TODOS"
        ),
        bsTooltip(
          "data_category",
          "Seleccionar una categoría",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### data_type ----
        selectInput(
          "data_type",
          label = "Tipo de dato",
          choices = c("TODOS"),
          selected = "TODOS"
        ),
        bsTooltip(
          "data_type",
          "Seleccionar un tipo",
          placement = "right", trigger = "hover", options = NULL
        ),
        ### data_format ----
        selectInput(
          "data_format",
          label = "Formato de dato",
          choices = c("TODOS"),
          selected = "TODOS"
        ),
        bsTooltip(
          "data_format",
          "Seleccionar un formato",
          placement = "right", trigger = "hover", options = NULL
        ),
        ## EXPLORADOR tab ----
        menuItem(
          text = "Casos",
          tabName = "EXPLORADOR",
          icon = icon("hospital-user")
        ),
        ## ARCHIVOS tab ----
        menuItem(
          text = "Archivos",
          tabName = "ARCHIVOS",
          icon = icon("file", class = "fa-solid")
        ),
        ## DESCARGAS tab ----
        menuItem(
          text = "Descargas",
          tabName = "DESCARGAS",
          icon = icon("download", class = "fa-solid")
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
            ### Project ----
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
                  #### project_disease_type_treemap ----
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
                  #### project_disease_type_treedt ----
                  tabPanel(
                    title = "Cuadro de datos del mapa de arbol",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("project_disease_type_treedt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### project_bar ----
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
                  #### project_bardt ----
                  tabPanel(
                    title = "Cuadro de datos por proyecto",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("project_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### disease_type_bar ----
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
                  #### disease_type_bardt ----
                  tabPanel(
                    title = "Cuadro de datos por tipo de enfermedad",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("disease_type_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### primary_site_bar ----
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
                  #### primary_site_bardt ----
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
            ### Diagnosis ----
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
                  #### primary_diagnosis_treemap ----
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
                  #### primary_diagnosis_treedt ----
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
                  #### primary_stage_treemap ----
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
                  #### primary_stage_treedt ----
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
                  #### tissue_origin_bar ----
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
                  #### tissue_origin_bardt ----
                  tabPanel(
                    title = "Cuadro de datos por tejido de origen",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("tissue_origin_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### primary_diagnosis_bar ----
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
                  #### primary_diagnosis_bardt ----
                  tabPanel(
                    title = "Cuadro de datos por diagnóstico primario",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("primary_diagnosis_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### pathologic_stage_bar ----
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
                  #### pathologic_stage_bardt ----
                  tabPanel(
                    title = "Cuadro de datos por etapa patológica",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("pathologic_stage_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### pathologic_stage_bar ----
                  tabPanel(
                    title = "Gráfico de barras por edad al diagnóstico",
                    icon = icon("chart-bar"),
                    h4(
                      class = "text-center",
                      "Número de Casos por Etapa Patológica"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput("age_at_diagnosis_bar", height = 500),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### pathologic_stage_bardt ----
                  tabPanel(
                    title = "Cuadro de datos por edad al diagnóstico",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("age_at_diagnosis_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              )
            ),
            ### Demographics ----
            fluidRow(
              width = 12,
              box(
                width = 12,
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Información demográfica",
                tabBox(
                  width = 6,
                  height = NULL,
                  #### race_pie ----
                  tabPanel(
                    title = "Casos por Raza",
                    icon = icon("chart-pie"),
                    h4(
                      class = "text-center",
                      "Casos por Raza"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "race_pie",
                        height = 500
                      ),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### race_piedt ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("race_piedt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                ),
                tabBox(
                  width = 6,
                  height = NULL,
                  #### ethnicity_pie ----
                  tabPanel(
                    title = "Casos por Etnicidad",
                    icon = icon("chart-pie"),
                    h4(
                      class = "text-center",
                      "Casos por Etnicidad"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "ethnicity_pie",
                        height = 500
                      ),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### ethnicity_piedt ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("ethnicity_piedt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                ),
                tabBox(
                  width = 6,
                  height = NULL,
                  #### vital_status_pie ----
                  tabPanel(
                    title = "Casos por Esta Vital",
                    icon = icon("chart-pie"),
                    h4(
                      class = "text-center",
                      "Casos por Estado Vital"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "vital_status_pie",
                        height = 500
                      ),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### vital_status_piedt ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("vital_status_piedt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                ),
                tabBox(
                  width = 6,
                  height = NULL,
                  #### gender_age_pyramid ----
                  tabPanel(
                    title = "Casos por Género y Edad",
                    icon = icon("chart-pie"),
                    h4(
                      class = "text-center",
                      "Casos por Género"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "gender_age_pyramid",
                        height = 500
                      ),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### gender_age_pyramiddt ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("gender_age_pyramiddt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              )
            )
          ),
          ## ARCHIVOS ----
          tabItem(
            tabName = "ARCHIVOS",
            fluidRow(
              valueBoxOutput("box_f_proyectos", width = 4),
              valueBoxOutput("box_f_casos", width = 4),
              valueBoxOutput("box_f_archivos", width = 4)
            ),
            ### TREEMAPS ----
            fluidRow(
              width = 12,
              box(
                width = 12,
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Composición de los archivos",
                tabBox(
                  width = 12,
                  height = NULL,
                  #### experimental_strategy_treemap ----
                  tabPanel(
                    title = paste(
                      "Mapa de arbol de proyectos y estrategía experimental"
                    ),
                    icon = icon("table-cells"),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "experimental_strategy_treemap",
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
                  #### experimental_strategy_treedt ----
                  tabPanel(
                    title = paste(
                      "Cuadro de datos de proyectos y estrategía experimental"
                    ),
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("experimental_strategy_treedt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### category_type_format_treemap ----
                  tabPanel(
                    title = paste(
                      "Mapa de arbol de categoría, tipo y formato"
                    ),
                    icon = icon("table-cells"),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "category_type_format_treemap",
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
                  #### category_type_format_treedt ----
                  tabPanel(
                    title = paste(
                      "Cuadro de datos categoría, tipo y formato"
                    ),
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("category_type_format_treedt"),
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
                title = "Cantidad de archivos por variable",
                tabBox(
                  width = 6,
                  height = NULL,
                  #### file_project_bar ----
                  tabPanel(
                    title = "Archivos por proyecto",
                    icon = icon("chart-pie"),
                    h4(
                      class = "text-center",
                      "Archivos por proyecto"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "file_project_bar",
                        height = 500
                      ),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### file_project_bardt ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("file_project_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                ),
                tabBox(
                  width = 6,
                  height = NULL,
                  #### experimental_strategy_bar ----
                  tabPanel(
                    title = "Archivos por estrategi experimental",
                    icon = icon("chart-pie"),
                    h4(
                      class = "text-center",
                      "Archivos por Estrategia Experimental"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "experimental_strategy_bar",
                        height = 500
                      ),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### experimental_strategy_bardt ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("experimental_strategy_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                ),
                tabBox(
                  width = 6,
                  height = NULL,
                  #### data_category_bar ----
                  tabPanel(
                    title = "Archivos por categoría de dato",
                    icon = icon("chart-pie"),
                    h4(
                      class = "text-center",
                      "Archivos por Categoría de Dato"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "data_category_bar",
                        height = 500
                      ),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### data_category_bardt ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("data_category_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                ),
                tabBox(
                  width = 6,
                  height = NULL,
                  #### data_type_format_bar ----
                  tabPanel(
                    title = "Archivos por tipo y formato de dato",
                    icon = icon("chart-pie"),
                    h4(
                      class = "text-center",
                      "Archivos por Tipo y Formato de Dato"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "data_type_format_bar",
                        height = 500
                      ),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### data_type_format_bardt ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("data_type_format_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                ),
                tabBox(
                  width = 6,
                  height = NULL,
                  #### data_type_bar ----
                  tabPanel(
                    title = "Archivos por tipo de dato",
                    icon = icon("chart-pie"),
                    h4(
                      class = "text-center",
                      "Archivos por Tipo de Dato"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "data_type_bar",
                        height = 500
                      ),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### data_type_bardt ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("data_type_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                ),
                tabBox(
                  width = 6,
                  height = NULL,
                  #### data_format_bar ----
                  tabPanel(
                    title = "Archivos por formato de dato",
                    icon = icon("chart-pie"),
                    h4(
                      class = "text-center",
                      "Archivos por Formato de Dato"
                    ),
                    shinycssloaders::withSpinner(
                      plotlyOutput(
                        "data_format_bar",
                        height = 500
                      ),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### data_format_bardt ----
                  tabPanel(
                    title = "Cuadro de datos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("data_format_bardt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              )
            )
          ),
          ## DESCARGAS ----
          tabItem(
            tabName = "DESCARGAS",
            fluidRow(
              width = 12,
              ### Bases de datos ----
              box(
                width = 12,
                solidHeader = TRUE,
                collapsible = TRUE,
                title = "Bases de datos",
                tags$div(
                  style = "text-align: justify; padding: 10px;",
                  paste(
                    "Nuestro conjunto de datos se compone de cinco bases",
                    "fundamentales para el análisis y la comprensión detallada",
                    "del panorama clínico y genómico de nuestros casos.",
                    "Estas bases abarcan información crucial:"
                  ),
                  br(),
                  br(),
                  tags$ol(
                    tags$li(
                      tags$b("Casos por Proyecto:"),
                      paste(
                        "Una recopilación detallada de",
                        "casos clasificados por proyectos específicos,",
                        "permitiendo un enfoque más específico en áreas de",
                        "interés."
                      )
                    ),
                    tags$li(
                      tags$b("Casos y su Demografía:"),
                      paste(
                        "Ofrece una visión completa",
                        "de los casos junto con sus detalles demográficos",
                        "esenciales, incluyendo datos como edad, género, y",
                        "otros factores relevantes."
                      )
                    ),
                    tags$li(
                      tags$b("Casos y su Diagnóstico:"),
                      paste(
                        "Esta base de datos",
                        "contiene información detallada sobre los diagnósticos",
                        "asociados a cada caso, brindando una comprensión",
                        "más profunda de las condiciones y patologías",
                        "presentes."
                      )
                    ),
                    tags$li(
                      tags$b("Archivos:"),
                      paste(
                        "Proporciona información detallada sobre los",
                        "archivos asociados a cada caso, facilitando el acceso",
                        "a datos específicos."
                      )
                    ),
                    tags$li(
                      tags$b("Mapeo de Archivos con Casos:"),
                      paste(
                        "Proporciona una conexión crucial entre los archivos",
                        "específicos y los casos a los que pertenecen,",
                        "facilitando el acceso y la referencia cruzada de",
                        "información relevante."
                      )
                    )
                  ),
                  br(),
                  tags$b("Filtros y su Impacto:"),
                  paste(
                    "Es importante resaltar que",
                    "cada una de estas bases de datos se ve directamente",
                    "afectada por los filtros aplicados. Los filtros",
                    "aplicados en la plataforma modifican dinámicamente",
                    "la información disponible en estas bases,",
                    "permitiendo una exploración detallada y",
                    "personalizada según los criterios seleccionados."
                  ),
                  br(),
                  br(),
                  paste(
                    "Cada una de estas bases de datos puede descargarse",
                    "fácilmente en formatos CSV o Excel, garantizando la",
                    "accesibilidad y flexibilidad necesarias para el",
                    "análisis personalizado y la investigación."
                  ),
                  br(),
                  br()
                ),
                tabBox(
                  width = 12,
                  height = NULL,
                  #### combined_cases_dt ----
                  tabPanel(
                    title = "Casos por proyecto",
                    icon = icon("user-group", class = "fa-solid"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("combined_cases_dt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### combined_demographics_dt ----
                  tabPanel(
                    title = "Casos y su demografía",
                    icon = icon("id-card", class = "fa-solid"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("combined_demographics_dt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### combined_diagnosis_dt ----
                  tabPanel(
                    title = "Casos y sus diagnósticos",
                    icon = icon("comment-medical", class = "fa-solid"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("combined_diagnosis_dt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### files_results_dt ----
                  tabPanel(
                    title = "Archivos",
                    icon = icon("file", class = "fa-solid"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("files_results_dt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  ),
                  #### files_cases_dt ----
                  tabPanel(
                    title = "Mapeo de archivos, casos y proyectos",
                    icon = icon("table"),
                    shinycssloaders::withSpinner(
                      DT::dataTableOutput("files_cases_dt"),
                      color = "#1c9ad6", type = "8", size = 0.5
                    )
                  )
                )
              )
            ),
            ### Tutorial de descargas ----
            fluidRow(
              width = 12,
              box(
                width = 12,
                collapsible = TRUE,
                solidHeader = TRUE,
                title = "Descarga de archivos genómicos de GDC - TCGA",
                tags$div(
                  style = "text-align: justify; padding: 10px;",
                  paste(
                    "Para descargar archivos genómicos de GDC - TCGA, se",
                    "necesita un archivo al que le llaman un manifiesto. Este",
                    "manifiesto es un archivo de texto plano que contiene",
                    "información sobre los archivos que se desean descargar.",
                    "Como manifiesto se puede usar la base de datos de",
                    "Archivos de esta plataforma, la cual contiene los IDs",
                    "de los archivos que se desean descargar. Recomiendo",
                    "descargar los archivos en formato CSV ya que este será",
                    "el formato usado en esta demostración."
                  ),
                  br(),
                  br(),
                  paste(
                    "Una vez descargado el manifiesto, se deben utilizar",
                    "unas funciones de R para descargar los archivos. Estas",
                    "funciones se encuentran en el paquete",
                    "GenomicDataCommons. Este paquete se instala de la",
                    "siguiete manera:"
                  ),
                  br(),
                  br(),
                  verbatimTextOutput("install_gdc"),
                  br(),
                  paste(
                    "Una vez instalado el paquete de R, debemos cargar la",
                    "librería, cargar el manifiesto y descargar los archivos",
                    "utilizando las funcionalidades de GenomicDataCommons.",
                    "La primera vez que se descargan los datos, R solicitará",
                    "crear un directorio de caché (consulte ?gdc_cache para",
                    "obtener detalles sobre cómo configurar e interactuar con",
                    "el caché). Los archivos descargados resultantes se",
                    "almacenarán en el directorio de caché. El acceso futuro a",
                    "los mismos archivos será directamente desde la memoria",
                    "caché, lo que aliviará las descargas múltiples."
                  ),
                  br(),
                  br(),
                  verbatimTextOutput("download_gdc"),
                  tags$b("Nota:"),
                  paste(
                    "Es importante que cambien la ruta del archivo a la ruta",
                    "del archivo en su computadora. Si no saben como hacerlo",
                    "pueden visitar estos links para"
                  ),
                  tags$a(
                    href = paste0(
                      "https://es.wikihow.com/encontrar-la-ruta-de-un-archivo",
                      "-en-Windows"
                    ),
                    target = "_blank",
                    "Windows"
                  ),
                  ", ",
                  tags$a(
                    href = paste0(
                      "https://support.apple.com/es-lamr/guide/mac-help/mchlp",
                      "1774/mac"
                    ),
                    target = "_blank",
                    "Mac"
                  ),
                  " o ",
                  tags$a(
                    href = paste0(
                      "https://www.hostinger.es/tutoriales/como-usar-comando",
                      "-find-locate-en-linux/"
                    ),
                    target = "_blank",
                    "Linux"
                  ),
                  br(),
                  tags$b("Nota:"),
                  paste(
                    "Tambien es importante mencionar que los archivos suelen",
                    "ser muy pesados, por lo que se recomiendo que descarguen",
                    "los archivos por bloque y con una buena conexión a",
                    "internet. Como se menciona anteriormente, la primera vez",
                    "que se descargan los archivos, R nos preguntará sobre",
                    "la creación de la carpeta de cache, por lo que hay que",
                    "estar pendiente a este mensaje."
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
