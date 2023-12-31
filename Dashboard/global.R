Sys.setlocale(locale = "es_ES.UTF-8")

library(shiny)
library(shinydashboard)
library(shinyBS)
library(shinycssloaders)
library(fontawesome)
library(plotly)
library(dplyr)
library(htmltools)
library(GenomicDataCommons)
library(DT)
library(BiocManager)
# options(repos = BiocManager::repositories())
load(file = "tcga.RData")
tcga_project_ids_list <- c("TODOS", tcga_project_ids_list)

# Static data ----
projects <- GenomicDataCommons::projects() %>%
  GenomicDataCommons::filter(program.name == "TCGA") %>%
  GenomicDataCommons::facet(c("name", "project_id")) %>%
  results_all()

vb_style <- function(msg = '', style="font-size: 100%;") {
  tags$p( msg , style = style )
}


Sys.setenv(OPENSSL_CONF = "/dev/null")
options(shiny.fullstacktrace = TRUE)

source("explorer.R")
source("project.R")
source("diagnosis.R")
source("demographics.R")
