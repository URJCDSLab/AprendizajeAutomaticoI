#library(ggpubr)
library(ggplot2)
library(shiny)
library(shinydashboard)
library(stargazer)

function(input, output, session) {
  updateTabItems(session, "sidebar", "home")

  data <- reactive({ 
    
    req(input$file1)
    
    inFile <- input$file1 
    
    df <- read.csv(inFile$datapath, header = input$header, sep = input$sep,
                   quote = input$quote)
    
    updateSelectInput(session, inputId = 'xcol', label = 'Variable',
                      choices = names(df), selected = names(df))
    updateSelectInput(session, inputId = 'y1col', label = 'Group',
                      choices = names(df), selected = names(df))
    updateSelectInput(session, inputId = 'y2col', label = 'Categories',
                      choices = names(df), selected = names(df))
    updateSelectInput(session, inputId = 'SelectX',
                      choices = names(df), selected = names(df))
    updateSelectInput(session, inputId = 'SelectY',
                      choices = names(df), selected = names(df))
    
    return(df)
  })  
  df_global1 <- reactive({
      data_mod(data())
    
  })

  #updateSelectInput(session, inputId = 'xcol', label = 'Variable',
  #                  choices = names(data), selected = names(data))

  #table output:
  output$table1 <- renderTable({
    head(data())
  })
  
  output$Summ <-
    renderPrint(
      stargazer(
        data(),
        type = "text",
        title = "Descriptive statistics",
        digits = 1,
        out = "table1.txt"
      )
    )
  output$Summ_old <- renderPrint(summary(data()))
  output$structure <- renderPrint(str(data()))
  
  output$Data <- renderDT({
    data()
  })
  
  #table output:
  output$table2 <- renderTable({
    summary(data())
  })
  
  output$doc_to_display <- renderUI({
    includeMarkdown("www/home.md")
  })

  output$MyPlot <- renderPlot({
    x    <- data()[, input$xcol]
    z <- as.numeric(input$Lambda)
    if (z!=0)
      x=(x^z-1)/z
    if (z==0)
      x=log(x)
    x=data.frame(x)
    
    #hist(x,col = '#2171b5', border = 'white',main = "Histograma")
    ggplot(x,aes(x=x))+
      geom_histogram(aes(y=..density..), position="identity", alpha=1,fill="#2171b5")+
      geom_density(alpha=0.6)+labs(title="Histogram plot")+
      theme_tq(
        panel.background = element_rect(fill='transparent'), #transparent panel bg
        plot.background = element_rect(fill='transparent', color=NA), #transparent plot bg
       # panel.grid.major = element_blank(), #remove major gridlines
      #  panel.grid.minor = element_blank(), #remove minor gridlines
        legend.background = element_rect(fill='transparent'), #transparent legend bg
        legend.box.background = element_rect(fill='transparent') #transparent legend panel
      )
  },bg="transparent",height = 250, width = 500 )
      #geom_histogram(fill="#2171b5")+geom_density(alpha=0.6)
  

  output$MyPlot2 <- renderPlot({
    x    <- data()[, input$xcol]
    z <- as.numeric(input$Lambda)
    if (z!=0)
      x=(x^z-1)/z
    if (z==0)
      x=log(x)
    x=data.frame(x)
    #boxplot(x,col = '#2171b5', border = 'royalblue3',main = "BoxPlot",horizontal=TRUE)
    ggplot(x,aes(x=x))+geom_boxplot(fill="#2171b5")+labs(title="Boxplot")+
      theme(
        panel.background = element_rect(fill='transparent'), #transparent panel bg
        plot.background = element_rect(fill='transparent', color=NA), #transparent plot bg
     #   panel.grid.major = element_blank(), #remove major gridlines
    #    panel.grid.minor = element_blank(), #remove minor gridlines
        legend.background = element_rect(fill='transparent'), #transparent legend bg
        legend.box.background = element_rect(fill='transparent') #transparent legend panel
      )
  },bg="transparent",height = 250, width = 500 )
  output$MyPlot3 <- renderPlot({
    x1   <- data()[, input$y1col]
    x2   <- data()[, input$y2col]
    df=data.frame(cbind(x1,x2))
    names(df)=c(input$y1col,input$y2col)
    #plot(x1,x2)
    #if ((typeof(x1)=="factor") & (typeof(x2)=="factor")){
    ggplot(data = df, aes(x = df[,2], fill = df[,1])) +
      geom_bar()+
      xlab(input$y2col)+
      guides(fill=guide_legend(title=input$y1col))+
      theme(
        panel.background = element_rect(fill='transparent'), #transparent panel bg
        plot.background = element_rect(fill='transparent', color=NA), #transparent plot bg
        #   panel.grid.major = element_blank(), #remove major gridlines
        #    panel.grid.minor = element_blank(), #remove minor gridlines
        legend.background = element_rect(fill='transparent'), #transparent legend bg
        legend.box.background = element_rect(fill='transparent') #transparent legend panel
        
      )
   # }
    },bg="transparent",height = 350, width = 600 )
  
}


