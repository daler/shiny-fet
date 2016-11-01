
library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
      # Application title
      fluidRow(
        column(
          2,
          wellPanel(
            h3('FET demo. See github.com/daler/shiny-fet.'),
            numericInput("genes",
                        "total genes assayed",
                        min = 1,
                        max = 25000,
                        value = 15000,
                        step=100
                        ),
            numericInput("genes_with_peak",
                        "total genes with a peak",
                        min = 1,
                        max = 10000,
                        value = 2130,
                        step=10),
            numericInput("upregulated",
                        "total upregulated genes",
                        min = 1,
                        max = 10000,
                        value = 930,
                        step=10
                        ),
            numericInput("interesting",
                        "upregulated AND peak",
                        min = 1,
                        max = 5000,
                        value = 130,
                        step=5),
               sliderInput("xmax",
                           "xmax",
                           min=1,
                           max=5000,
                           value=300)
            )
          ),
          column(
            5,
            wellPanel(
                      h3(textOutput("pval")),
                      h3(textOutput("or")),
                      h3(textOutput("results"))
            ),
            wellPanel(
                h4(tableOutput("counts"))
            ),
                      tableOutput("rowperc"),
                      tableOutput("colperc")
           ),

          column(
            5,
                      plotOutput("mosaicplot"),
                      plotOutput("distPlot")
          )
      )
  )
)
