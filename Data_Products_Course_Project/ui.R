#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

require(shiny)
require(plotly)
require(quantmod)
require(dplyr)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Stock Viewer"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        textInput("Stock","Enter Stock Ticker Symbol",value="AMZN"),
        h4("Select Days to Look Back (MAX 100)"),
        sliderInput("Days","Days to Look Back",0,100,1,
                    value=30),
        h4("Enter Plot Color below"),
        sliderInput("R","Select Red for Plot",0,255,1,
                    value=30),
        sliderInput("G","Select Green for Plot",0,255,1,
                    value=90),
        sliderInput("B","Select Blue for Plot",0,255,1,
                    value=160),
        h4("Enter Fill Information"),
        checkboxInput("Fill","Show Fill?", value=FALSE),
        sliderInput("Opacity","Select Fill Opacity",0,1,.01,
                    value=0.5),
        submitButton("Submit")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotlyOutput("stockPlot"),
       h3("How to use this plot:"),
       p("First, enter the stock ticker symbol (e.g. AMZN)"),
       p("Next, enter the last x amount of days for which
         you desire the close price of the stock."),
       p("Manipulate the RGB sliders to change the color of the line."),
       p("Additionally, select whether or not the graph should be filled
         below the trend line, to give the graph a bit more style."),
       p("When you are done tweaking parameters, press the 'Submit' button"),
       p("Press the play button to automatically run the plot or
          drag the slider below the graph to run the plot."),
       p("Zoom in to different areas of the graph by clicking once, 
          holding the mouse click, and dragging a rectangle over the
         desired area.")
       
       
    )
  )
))
