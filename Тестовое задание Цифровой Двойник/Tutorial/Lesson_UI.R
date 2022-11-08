library(shiny)
library(shinydashboard)

ui <- shinyUI(
  dashboardPage(
    dashboardHeader(title = 'This is a header',
                    dropdownMenuOutput(
                      'msgOutput'
                    )
                    # dropdownMenu(
                    #   type = 'message',
                    #   messageItem(
                    #     from = 'Finance update',
                    #     message = 'we are on treshold',
                    #   ),
                    #   messageItem(
                    #     from = 'Sales Update',
                    #     message = 'Sales are at 55 %',
                    #     icon = icon('bar-chart'),
                    #     time = '22:00'
                    #   ),
                    #   messageItem(
                    #     from = 'Sales Update',
                    #     message = 'Sales meeting at 6 PM on Monday',
                    #     icon = icon('handshake-o'),
                    #     time = '12-12-2022'
                    #   )
                    # )
                    
                    
                    ),
    dashboardSidebar(
    sliderInput('bins', 'Number of Breaks', 1, 100, 50),
    sidebarMenu(
    menuItem("Dashboard", tabName = 'dashboard', icon=icon('dashboard')),
      menuSubItem('Dashoard finance', tabName = 'finance', icon = icon('database')),
      menuSubItem('Dashoboard economic', tabName = 'sales'),
    menuItem("Deatailed analysis"),
    menuItem("Raw Data")
    )),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = 'dashboard',
          fluidRow(
            box(
              plotOutput('histogram')
            )
        )
      ),
      tabItem(
        tabName = 'finance',
        h1('Finance Dashboard')
      ),
      tabItem(
        tabName = 'sales',
        h2('Sales Dashboard')
      )

      )
    )
  )
)
server <- shinyServer(function(input, output){
  output$histogram <- renderPlot({
    hist(faithful$eruptions, breaks=input$bins)
  })
  
  output$msgOutput <- renderMenu({
    msgs <- apply(read.csv(''))
  })
})
shinyApp(ui, server)
