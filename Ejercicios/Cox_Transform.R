library(shiny)
library(datasets)

ui <- shinyUI(fluidPage(
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
                 #
                 abc
                 img(src = "DSlab_logo_1.png", height = 50, width = 50),
                 plotOutput('MyPlot'),
                 plotOutput('MyPlot2')
                 
               )
             )
    )
    
  )
)
)

server <- shinyServer(function(input, output, session) {
  # added "session" because updateSelectInput requires it
  
  
  data <- reactive({ 
    req(input$file1) ## ?req #  require that the input is available
    
    inFile <- input$file1 
    
    # tested with a following dataset: write.csv(mtcars, "mtcars.csv")
    # and                              write.csv(iris, "iris.csv")
    df <- read.csv(inFile$datapath, header = input$header, sep = input$sep,
                   quote = input$quote)
    
    
    # Update inputs (you could create an observer with both updateSel...)
    # You can also constraint your choices. If you wanted select only numeric
    # variables you could set "choices = sapply(df, is.numeric)"
    # It depends on what do you want to do later on.
    
    updateSelectInput(session, inputId = 'xcol', label = 'Variable',
                      choices = names(df), selected = names(df))
    return(df)
  })
  
  output$contents <- renderTable({
    data()
  })
  
  output$MyPlot <- renderPlot({
    # for a histogram: remove the second variable (it has to be numeric as well):
    # x    <- data()[, c(input$xcol, input$ycol)]
    # bins <- nrow(data())
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    # Correct way:
     x    <- data()[, input$xcol]
     z <- as.numeric(input$Lambda)
     if (z!=0)
       x=(x^z-1)/z
     if (z==0)
       x=log(x)
     bins <- nrow(data())
     hist(x,col = '#2171b5', border = 'white',main = "Histograma")
    
    
    # I Since you have two inputs I decided to make a scatterplot
    #x <- data()[, c(input$xcol, input$ycol)]
    #plot(x)
    
  })
  output$MyPlot2 <- renderPlot({
    
    # Correct way:
    x    <- data()[, input$xcol]
    z <- as.numeric(input$Lambda)
    if (z!=0)
      x=(x^z-1)/z
    if (z==0)
      x=log(x)
    bins <- nrow(data())
    boxplot(x
         ,col = '#2171b5', border = 'royalblue3',main = "BoxPlot",horizontal=TRUE)
    
    # I Since you have two inputs I decided to make a scatterplot
    #x <- data()[, c(input$xcol, input$ycol)]
    #plot(x)
    
  })
  
})

shinyApp(ui, server)
