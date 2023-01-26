# load the necessary libraries
library(shiny)
library(ggplot2)
library(DT)
library(readr)
#Importing my data

US_Police_shootings_15_22 <- read_csv("~/dmclark/dmclark_hw1/US Police shootings in from 2015-22.csv")

# create a basic shiny app
ui <- fluidPage(
  
  # add a title
  titlePanel("Basic Shiny App"),
  
  # add a side panel for the inputs
  sidebarLayout(
    sidebarPanel(
      
      # create a drop-down menu for the variable
      selectInput("variable", "Select a variable:", 
                  choices = colnames(US_Police_shootings_15_22)),
      
      # create a numeric input for the threshold value
      numericInput("threshold", "Enter threshold value:", 
                   min = 0, max = 100, value = 50),
      
      # create a download button
      downloadButton("downloadData", "Download Data")
    ),
    
    # add a main panel for the outputs
    mainPanel(
      
      # create a tabset for the plots and table
      tabsetPanel(
        
        # create a tab for the line plot
        tabPanel("Line Plot", plotOutput("linePlot")),
        
        # create a tab for the bar plot
        tabPanel("Bar Plot", plotOutput("barPlot")),
        
        # create a tab for the data table
        tabPanel("Data Table", DT::dataTableOutput("dataTable"))
      )
    )
  )
)

server <- function(input, output) {
  
  
  output$linePlot <- renderPlot({
    ggplot(US_Police_shootings_15_22, aes_string(x = "date" , y = "age")) +
      geom_line()
    
  })
  
  # create the bar plot
  output$barPlot <- renderPlot({
    ggplot(US_Police_shootings_15_22, aes_string(x = 'age', fill = "race")) +
      geom_bar(position = "dodge")
  })
  
  # create the data table
  output$dataTable <- DT::renderDataTable({
    DT::datatable(subset(US_Police_shootings_15_22, US_Police_shootings_15_22$race > input$threshold))
  })
  
  # create the download handler
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(US_Police_shootings_15_22, file)
    }
  )
}

# run the shiny app
shinyApp(ui = ui, server = server)

