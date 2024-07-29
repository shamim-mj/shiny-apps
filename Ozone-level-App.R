
# Ozone level histogram
# 
library(shiny)
library(shinythemes)
data("airquality")
library(ggplot2)
library(dplyr)

ui <- fluidPage(theme = shinytheme("superhero"),
  titlePanel("Ozone Level Histogram"), # choose the title name
  # side bar layout
  sidebarLayout(
    # slide panel
    sidebarPanel(
      #slider
      sliderInput(inputId = "bins", 
                  label = "Number of bins", 
                  min = 1,
                  max = 50, 
                  value = 21
                  )
    ), 
    mainPanel(
      plotOutput(outputId = "distPlot")
    )
  )
)


server <- function(input, output){
  
  output$distPlot <- renderPlot({
    # x <- airquality$Ozone
    # x <- na.omit(x)
    # bins <- seq(min(x), max(x), length.out = input$bins+1)
    # hist(x, breaks = bins, col = "red", border = "black", 
    #      xlab = "Ozone Level", 
    #      main = " Histogram of Ozone level")
    airquality |>
      filter(!is.na(Ozone)) |>
      ggplot()+
      geom_histogram(aes(x = Ozone), bins = input$bins, color = "red", stat = "bin")+
      labs(
        x <- "Ozone Level", 
        title = " Histogram of Ozone Level", 
        subtitle = "More data is coming from the low Ozone levels",
        caption = "Shiny App tutorial"
      )+
      theme_classic()+
      theme(
        text = element_text(size = 18, family = "serif", face = "bold", color = "black"), 
        title = element_text(size = 16, family = "serif", face = "bold", color = "black"), 
        plot.title.position = "plot", 
        
      )
  })
}


shinyApp(ui = ui, server = server)
