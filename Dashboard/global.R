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
options(repos = BiocManager::repositories())

Sys.setenv(OPENSSL_CONF = "/dev/null")
options(shiny.fullstacktrace = TRUE)

source("explorer.R")
