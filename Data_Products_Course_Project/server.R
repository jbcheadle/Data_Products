#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

require(shiny)
require(plotly)
require(quantmod)
require(dplyr)

accumulate_by <- function(dat, var) {
    var <- lazyeval::f_eval(var, dat)
    lvls <- plotly:::getLevels(var)
    dats <- lapply(seq_along(lvls), function(x) {
        cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
    })
    dplyr::bind_rows(dats)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$stockPlot <- renderPlotly({
      
      stock <- input$Stock
      days <- input$Days
      r <- input$R
      g <- input$G
      b <- input$B
      o <- input$Opacity
      
      suppressWarnings(options("getSymbols.warning4.0"=FALSE))
      suppressWarnings(options("getSymbols.yahoo.warning"=FALSE))
      symbol <- invisible(getSymbols(stock,src='yahoo',
                                  warnings = FALSE, auto.assign = FALSE))
      
      df <- data.frame(Date=index(symbol),coredata(symbol))
      df <- tail(df, days)
      df$ID <- seq.int(nrow(df))
      names(df)[5] <- "Close"

      df <- df %>%
          accumulate_by(~ID)

      df %>%
          plot_ly(
              x = ~ID,
              y = ~Close,
              frame = ~frame,
              type = 'scatter',
              mode = 'lines',
              fill = ifelse(input$Fill, 'tozeroy',""),
              fillcolor=ifelse(input$Fill,
                               paste0('rgba(', r, ', ',
                                      b, ', ',
                                      g, ', ',
                                      o, ')'),""),
              line = list(color = paste0('rgb(', r, ', ',
                                         b, ', ',
                                         g, ')')),
              text = ~paste("Day: ", ID, "<br>Close: $", Close),
              hoverinfo = 'text'
          ) %>%
          layout(
              title = paste0(stock,": Last ",days, " Days"),
              yaxis = list(
                  title = "Close Price (USD)",
                  range = c(min(df$Close)-0.1*min(df$Close)
                            ,max(df$Close)+0.1*min(df$Close)),
                  zeroline = F,
                  tickprefix = "$"
              ),
              xaxis = list(
                  title = "Day",
                  range = c(0,days),
                  zeroline = F,
                  showgrid = F
              )
          ) %>%
          animation_opts(
              frame = 100,
              transition = 0,
              redraw = FALSE
          ) %>%
          animation_slider(
              currentvalue = list(
                  prefix = "Day "
              )
          )

    
  })
  
})
