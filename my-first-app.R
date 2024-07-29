
# My first shiny App
# 
library(shiny)
library(shinythemes)


ui <- fluidPage(theme = shinytheme("superhero"), 
                navbarPage(
                  "My first App",
                  tabPanel("User Info: ", 
                           sidebarPanel(
                             h3("Input:"),
                             textInput("txt1", "Given Name", ""),
                             textInput("txt2", "Last Name", "")
                           ), # closing side bar
                           mainPanel(
                             h1("Header 1"), 
                             h4("Output"),
                             verbatimTextOutput("textout")
                           ) # closing main page
                           ), # closing first tab
                  tabPanel("Contact Us", "This is left blank intentionally"),
                  tabPanel("About us", "We are here for you")
                  ) # closing nav page
                ) # closing fluid page




server <- function(input, output){
  output$textout <- renderText({
    paste("Hi ", input$txt1, input$txt2, "!, You are an amazing person.")
  })
}




shinyApp(ui = ui, server = server)