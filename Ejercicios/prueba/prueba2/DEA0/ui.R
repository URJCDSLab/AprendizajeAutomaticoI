library(shiny)
library(datasets)
library(shinydashboard)
library(DT)

   sidebar <-  dashboardSidebar(
   sidebarMenu(id = "sidebar",
                HTML(paste0(
                  "<br>",
                  "<img style = 'display: block; margin-left: auto; margin-right: auto;' src='DEA2.png' width = '186'>",
                  "<br>"
                )),
                menuItem("Home", tabName = "home", icon = icon("home"), selected = TRUE),
                # menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"), selected = FALSE),
                menuItem("File", icon = icon("file"), tabName = "file", selected = FALSE),
                menuItem("Transform", icon = icon("wrench"),tabName = "transform", selected = FALSE),
               menuItem("Analysis", tabName = "analysis", icon = icon("chart-bar"), selected = FALSE),
               menuItem("Model", tabName = "model", icon = icon("chart-bar"), selected = FALSE),
                menuItem("About", tabName = "about", icon = icon("question"), selected = FALSE)
    )
)
  
  body <- dashboardBody(
   # conditionalPanel(
    tabItems(
      tabItem(tabName = "home",
              uiOutput("doc_to_display")
      ),
      tabItem(tabName = "file",
              h2("Reading the data set"),
              box(width = NULL, status = "primary", solidHeader = TRUE, title="Data",
                  fileInput('file1', 'CSV File',
                            accept=c('text/csv', 
                                     'text/comma-separated-values,text/plain', 
                                     '.csv')),
                  #csvFileInput("datafile", "User data (.csv format)"),
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
                         '"'),
              br(),
              tableOutput("table1"),
              )),
      tabItem(tabName = "transform",
              h2("Cox transformation"),
              pageWithSidebar(
                headerPanel(''),
                sidebarPanel(                            
                  selectInput('xcol', 'Variable:',""),
                  sliderInput("Lambda",
                              "Lambda",
                              value = 1,
                              min = 0.0,
                              max = 2.0,round=TRUE,step=.01)
                ),
              mainPanel(
                plotOutput('MyPlot'),
                plotOutput('MyPlot2')
              )
              )),
      tabItem(tabName = "analysis",
              h2("Correlation Analysis")
              ),         
      tabItem(tabName = "model",
              h2("Model"),
              box(
                selectInput(
                  "SelectX",
                  label = "Select variables:",
                  choices = names(longley),
                  multiple = TRUE,
                  selected = names(longley)
                ),
                solidHeader = TRUE,
                width = "3",
                status = "primary",
                title = "X variables"
              ),
              box(
                selectInput("SelectY", label = "Select variable to predict:", choices = names(longley)),
                solidHeader = TRUE,
                width = "3",
                status = "primary",
                title = "Y variable"
              )
              ),
         tabItem(tabName = "about",
             includeMarkdown("www/about.md")
     )
    )
  #)
  )
  
  dashboardPage(
    dashboardHeader(title = "DSLAB"),
    sidebar,
    body
  )



