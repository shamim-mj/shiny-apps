
# Squar Root and Histogram
# 

library(shiny)
library(shinythemes)
library(ggplot2)


ui <-  fluidPage(theme = shinytheme("united"),
  titlePanel("A simple App showing the second power and his"),
                 sidebarLayout(
                   sidebarPanel(h2("Number Input"), 
                                numericInput("num",  "Enter a number:", value = 1),
                                numericInput("mean", "Enter a mean value:", value = 1),
                                numericInput("vals", "Enter the number of obs:", value = 1),
                                sliderInput("bins", "Select bins for the plot!", 
                                            min = 1, max = 1000, value = 30, step = 5),
                                actionButton('submit', "Submit")
                 ),
                 
                 mainPanel(
                   h1("The second power of your number and the plot"),
                   textOutput("square"), 
                   plotOutput("hist")
                 )
                 
                 )
)




server <- function(input, output, session){
  square_number <-  eventReactive(input$submit, {
    input$num^2
  })
  
  obs_number <- eventReactive(input$submit, {
    input$vals})
  
  output$square <- renderText({
    if(input$submit > 0) {
    paste("The square of", input$num, "is", square_number())
    } else {
      return('The app is ready for calculation!')
    }
  })
  
  output$hist <-renderPlot({
    if(input$submit > 0 ) {
    ggplot()+
      geom_histogram(aes(x = rnorm(obs_number(), mean = input$mean)), fill = 'red', bins = input$bins, stat = 'bin')
    } else {
      return("Ready to dash!")
    }
  })
}


shinyApp(ui = ui, server = server)