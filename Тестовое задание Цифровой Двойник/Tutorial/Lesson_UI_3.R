#library(shiny)
setwd('C:\\Users\\user\\Interviews\\Тестовое задание Цифровой Двойник\\Tutorial')
ui <- shinyUI(fluidPage(
  headerPanel(title = 'Shiny Tabset Example'),
  sidebarLayout(
    sidebarPanel(
      selectInput('ngear', 'Select the gear number', c('Cylinders' = 'cyl', 'Transmission' = 'am', 'Gears' = 'gear'))
    ),
    mainPanel(
      tabsetPanel(
        type = 'tab',
        tabPanel('Help', #tags$img(src = 'znak_3.png'),
                  HTML(
          '<iframe width="560" height="315"  src="https://www.youtube.com/embed/eQlSvfUuQNs" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'
        )),
        tabPanel('Data', tableOutput('mtcars')))),
        tabPanel('Summary', verbatimTextOutput('sum')),
        tabPanel('Plot', plotOutput('plot'))
      )
    )
  )

server <- shinyServer(
  function(input, output){
    mtreact <- {(
      reactive(mtcars[, c('mpg', input$ngear)])
    )}
   output$mtcars <- {(
     renderTable(mtreact())
   )}
   output$sum <- {(
     renderPrint(
       summary(mtreact())
     )
   )}
   output$plot <- {(
     renderPlot(with(mtreact(), boxplot(mpg~mtreact()[,2])))
   )}
  })
shinyApp(ui, server)
