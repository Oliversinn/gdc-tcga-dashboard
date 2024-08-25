# gdc-tcga-dashboard

## Descripción

gdc-tctga-dashboard es un proyecto creado para acceder y visualizar datos del The Cancer Genome Atlas (TCGA) sin lidear con el API o sitio web del Genomic Data Commons (GDC). Utilizando la librería GenomicDataCommons, este proyecto consume la API de GDC para extraer datos clínicos de los estudios de TCGA. El resultado es un tablero interactivo, desarrollado en RShiny, que permite a los usuarios explorar los datos de manera dinámica.

Puedes acceder al tablero publicado en Shinyapps a través del siguiente enlace:
https://oliversinn.shinyapps.io/gdc-tcga-dashboard/

Funcionalidades del tablero

El tablero está dividido en tres secciones principales:

1. Casos: Proporciona detalles sobre los proyectos, diagnósticos y datos demográficos de los casos estudiados.
2. Archivos: Explora la composición de los archivos disponibles en función de su tipo, formato y categoría.
3. Descargas: Permite a los usuarios descargar las tablas de datos utilizadas en el tablero. Además, se incluye un tutorial sobre cómo descargar archivos genómicos utilizando la librería GenomicDataCommons.

Estructura del Proyecto

* run.R: Script encargado de realizar el proceso de extracción, transformación y carga (ETL) de los datos desde la API de GDC. Los datos se almacenan en la carpeta Dashboard.
* Dashboard/tcga.RData: Contiene toda la lógica del tablero desarrollado en RShiny, dividido en los archivos global.R, server.R y ui.R.

## Instalación

Este proyecto utiliza renv para la gestión de dependencias, facilitando la configuración del entorno. Para instalar el proyecto localmente:

1. Clona este repositorio
```
git clone https://github.com/tuusuario/gdc-tctga-dashboard.git
cd gdc-tctga-dashboard
```

2. Restaura el entorno de R con renv:
```
renv::restore()
```

3. Ejecuta el script run.R para preparar los datos:
```
source('run.R')
```

4. Para inicial el tablero de Shiny
```
shiny::runApp('Dashboard')
```

## Uso del Tablero

El tablero permite realizar filtros y explorar los datos de manera interactiva. A traves de las secciones de Casos, Archivos y Descargas.

## Ejemplos

Ejemplos

Accede al tablero interactivo en:
https://oliversinn.shinyapps.io/gdc-tcga-dashboard/

1. Filtra los casos por tipo de cáncer y revisa la distribución de diagnósticos.
2. Explora los diferentes tipos de archivos genómicos asociados con los proyectos seleccionados.
3. Descarga los datos y usa el tutorial para aprender cómo obtener archivos genómicos desde la API de GDC.

## Licencia

Este proyecto está licenciado bajo la Licencia GPL-3.0.


## Agradecimientos

Este trabajo ha sido posible gracias al uso de datos proporcionados por GDC y TCGA, así como a las herramientas de código abierto como GenomicDataCommons y RShiny.