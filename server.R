library(shiny)
library(ggvis)
library(ggplot2)
library(readr)

# TODO - change directory read here to relative
SP500 <- read_csv("files/^GSPC.csv", 
              col_types = cols(Date = col_date(format = "%m/%d/%Y")))


# Define server logic required to draw a histogram ----
server <- function(input, output, session) {

  #build matrix of returns
  #ex:
  #[
  #  1%, 3%, -3%
  #  NA, 3%, -1%
  #  NA, NA, -2%%
  #]
  
  
  #plot for above matrix where NA values are colored white, positive values are colored green, and negative values are colored orange. 
  output$plot1 <- renderTable({
    head(SP500)
  })
  
  
  #calculated returns given input values - portfolio value and year. 
  output$n_returns <- renderText({
    input$portfolio_value
  })

  
  #stretch goal is line graph showing rise and fall in portfolio value  
}