library(shiny)
library(datasets)

fluidPage(
  titlePanel("Selector de transformaciones"),
  tabsetPanel(
    tabPanel("Datos",
             titlePanel("Carga de datos"),
             sidebarLayout(
               sidebarPanel(
                 fileInput('file1', 'Elegir Fichero CSV',
                           accept=c('text/csv', 
                                    'text/comma-separated-values,text/plain', 
                                    '.csv')),
                 
                 # added interface for uploading data from
                 # http://shiny.rstudio.com/gallery/file-upload.html
                 tags$br(),
                 checkboxInput('header', 'Header', TRUE),
                 radioButtons('sep', 'Separator',
                              c(Comma=',',
                                Semicolon=';',
                                Tab='\t'),
                              ','),
                 radioButtons('quote', 'Quote',
                              c(None='',
                                'Double Quote'='"',
                                'Single Quote'="'"),
                              '"')
                 
               ),
               mainPanel(
                 tableOutput('contents')
               )
             )
    ),
    tabPanel("Transformaciones",
             pageWithSidebar(
               headerPanel('Selector'),
               sidebarPanel(
                 
                 # "Empty inputs" - they will be updated after the data is uploaded
                 selectInput('xcol', 'X Variable', ""),
                 sliderInput("Lambda",
                             "Lambda",
                             value = 1,
                             min = 0.0,
                             max = 2.0,round=TRUE,step=.01)
               ),
               mainPanel(
                 #    img(src = "DSlab_logo_1.png", height = 50, width = 50),
                 plotOutput('MyPlot'),
                 plotOutput('MyPlot2')
                 
               )
             )
    )
    
  )
)

