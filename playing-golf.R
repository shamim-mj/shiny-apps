# Playing golf game App

library(shiny)
library(shinythemes)
library(data.table)
library(RCurl)
library(randomForest)


weather <- read.csv(text = getURL("https://raw.githubusercontent.com/dataprofessor/data/master/weather-weka.csv"))

weather <- weather |>
  mutate(play = ifelse(play =="yes", 1, 0))
weather$outlook <- factor(weather$outlook,levels = c("overcast", "rainy", "sunny"))
weather$play <- factor(weather$play, levels = c(1,0))


model <- randomForest(play ~ ., data = weather, ntree = 500, mtry = 4, importance = TRUE)

#predict(model, newdata = data.frame(outlook = "sunny", temperature = 60, humidity = 50, windy = FALSE))
#
#saving model to RDS file
#saveRDS(model, "model.rds")


#reading the model from RDS file
#model <- readRDS(model, 'model.rds')



ui <- fluidPage(theme = shinytheme("superhero"), 
                
                headerPanel("Play Golf?"), 
                
                sidebarPanel(
                  HTML("<h3>Input Parameters<h3>"), 
                  selectInput("outlook", label = "Outlook:",
                              choices = list("Sunny" = "sunny",
                                             "Overcast" = "overcast", 
                                             "Rainy" = "rainy"), 
                              selected = "Rainy"), 
                  sliderInput("temperature", "Temperature:", 
                              min = 64, max = 86, value = 70), 
                  sliderInput('humidity', label = "Humidity:",
                              min = 65, max = 96, value = 85),
                  selectInput('windy', label = "Windy:", 
                              choices = list("Yes" = "TRUE", "No" = "FALSE"), 
                              selected = "TRUE"), 
                  actionButton("submitbutton", "Submit", class = "btn btn-primary")
                ), 
                
                
                mainPanel(
                  tags$label(h3('Status/Output')), # Status/Output Text Box
                  verbatimTextOutput('contents'), 
                  tableOutput('tabledata')
                )
                )


server <- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({  
    
    # outlook,temperature,humidity,windy,play
    df <- data.frame("outlook" = input$outlook,
                     "temperature"= input$temperature,
                     "humidity"= input$humidity,
                     "windy" = input$windy)
    
    # play <- "play"
    # df <- rbind(df, play)
    # input <- transpose(df)
    # write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    # 
    # test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
    
    df$outlook <- factor(df$outlook, levels = c("overcast", "rainy", "sunny"))
    
    
    Output <- data.frame(Probability=predict(model,df))
    Output <- Output |>
              mutate(Results = ifelse(Probability == 1 , "️Yes, We play it🏌️","No, we don't⛔"))
    print(Output)
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}

####################################
# Create the shiny app             #
####################################
shinyApp(ui = ui, server = server)