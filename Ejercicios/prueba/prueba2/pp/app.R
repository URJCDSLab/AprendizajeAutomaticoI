library(shiny)

# FAKE DATAFRAME
data <- reactive(  
  data.frame(
    group = sample(c("A", "B"), 100, replace = TRUE),
    var1 = round(runif(100, min = 0, max = 100), 0),
    var2 = sample(c("A", "B"), 100, replace = TRUE)
  )
)

# USER INTERFACE
ui <- fluidPage(
  verbatimTextOutput("text1")
)

# SERVER
server <- function(input, output) {
  output$text1 <- renderText({
    summary(data()$var1)
  })
}

# START APP
shinyApp(ui = ui, server = server)