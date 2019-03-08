library(shiny)
library(shinythemes)
library(ggvis)

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

fluidPage(
  titlePanel("Market Matrix"),
  fluidRow(
    column(3,
           wellPanel(
             h4("Filter"),
             textInput("portfolio_value", "Portfolio value in USD"),
             sliderInput("year", "Year Invested", 1950, 2019, value = c(1950, 2019),
                         sep = "")
           )
    ),
    column(9,
           tableOutput("plot1"),
           wellPanel(
             span("Returns over selected period",
                  textOutput("n_returns")
             )
           )
    )
  )
)