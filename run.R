Sys.setlocale(locale = "es_ES.UTF-8")
# SETUP                             -------------------------------
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
rm(list = ls())

source("setup.R")
runApp("Dashboard")
