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

projects <- GenomicDataCommons::projects() %>%
  GenomicDataCommons::filter(program.name == "TCGA") %>%
  GenomicDataCommons::facet(c("name", "project_id")) %>%
  results_all()

tcga_project_ids_list <- projects$project_id
tcga_project_ids_list <- c("TODOS", tcga_project_ids_list)


Sys.setenv(OPENSSL_CONF = "/dev/null")
options(shiny.fullstacktrace = TRUE)

source("explorer.R")
