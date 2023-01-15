#library(shiny)
ui <- shinyUI(fluidPage(
  headerPanel(
    title = 'Text input Shiny widget'
  ),
  sidebarLayout(
    sidebarPanel(
      # вставка окна для ввода данных
      textInput('projcode', 'Enter your project code'),
      textInput('projname', 'Enter your the project name'),
      textInput('tech', 'Technology you are using?'),
      radioButtons('loc', 'What is your location', choices = c('Off-site', 'on-site')),
      sliderInput('ndaysspend', 'Number of days spent', 0, 100, 20, step = 5, ),
      selectInput('dept', 'What is your department', choices = c('Marketing', 'Finance', 'Sales', 'IT'), multiple = T)
      
    ),
    mainPanel(
      textOutput('project_code'),
      textOutput('project_name'),
      textOutput('technology_used'),
      textOutput('location'),
      textOutput('no_of_days_spend'),
      textOutput('department')
    )
  )
)
)

server <- shinyServer(
  function(input, output){
    output$project_code <- {(
      renderText(input$projcode)
    )}
    output$project_name <- {(
      renderText(input$projname)
    )}
    output$technology_used <-{(
      renderText(input$tech)
    )}
    output$location <-{(
      renderText(input$loc)
    )}
    output$no_of_days_spend <- {(
      renderText(
        input$ndaysspend
      )
    )}
    output$department <- {(
      renderText(input$dept)
    )}
  }
)


shinyApp(ui, server)