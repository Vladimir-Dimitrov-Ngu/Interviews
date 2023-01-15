#library(shiny)
#library(shinydashboard)

ui <- shinyUI(
  dashboardPage( title = 'Demo app', skin = 'red',
    dashboardHeader(title = 'This is a header',
                    # динамическое меню
                    dropdownMenuOutput(
                      'msgOutput'
                    ),
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
                    # ),
                    dropdownMenu(type = 'notifications',
                    notificationItem(
                      text = '2 new tabs added to the dashboard',
                      icon = icon('dashboard'),
                      status = 'success'
                    ),
                    notificationItem(
                      text = 'Sever is currently running at 95 load',
                      icon = icon('warning'),
                      status = 'warning'
                    )
                    ),
                    dropdownMenu(
                      type = 'tasks',
                      taskItem(
                      value = 80,
                      color = 'aqua',
                      'Shiny Dashnboard education '
                    ),
                    taskItem(
                      value = 55,
                      color = 'blue',
                      'Shindy Dashboard finnace',
                    )
                    )
                    ),
    
    dashboardSidebar(
    sidebarMenu(
    sidebarSearchForm('searchText', 'buttonSearch', 'Search'),
    menuItem("Dashboard", tabName = 'dashboard', icon=icon('dashboard')),
      menuSubItem('Dashoard finance', tabName = 'finance', icon = icon('database')),
      menuSubItem('Dashoboard economic', tabName = 'sales'),
    menuItem("Deatailed analysis", badgeLabel = 'New', badgeColor = 'green'),
    menuItem("Raw Data"),
    sliderInput('bins', 'Number of Breaks', 1, 100, 50),
    textInput('text_input', 'Search Opportunities', value='123456')
    )),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = 'dashboard',
          fluidRow(
            column(width = 9,
            infoBox(
              'Sales', 100,icon = icon('thumbs-up')
            ),
            infoBox(
              'Conversion %', paste0('20%'), icon = icon('warning')
            ),
            infoBoxOutput(
              'approvedSales', 
          )
          )),
          # value box
          fluidRow(
            valueBox(
              15 * 200, 'Budget for 15 Days', icon = icon('hourglass-3')
            ),
            valueBoxOutput('itemRequested')
          ),
          fluidRow(
            tabBox(
            tabPanel(title = 'Histogram of Faithful',
                status = 'primary',
                solidHeader = T,
                background = 'aqua',
                
                
              plotOutput('histogram'),
          
            ),
            tabPanel(title = 'Control for Dashboard', status = 'warning', solidHeader = T,
                'Use these contols to fine tune your dashboard', br(),
                'Do not use lot of control as it confuses the user',
                sliderInput('bins', 'Number of Breaks', 1, 100, 50),
                textInput('text_input', 'Search Opportunities', value='123456'),
                background = 'red'
                )
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
    msgs <- apply(read.csv("C:\\Users\\user\\Interviews\\Тестовое задание Цифровой Двойник\\Tutorial\\123.csv", sep = ';'), 1, function(row){
      messageItem(from = row[['from']], message = row[['message']])
    })
    dropdownMenu(type = 'messages', .list = msgs)
  })
  
  output$approvedSales <- renderInfoBox({
    infoBox('Approved Sales', '10000', icon = icon('bar-chart-o'))
  })
  output$itemRequested <- renderValueBox({
    valueBox(15 * 300, 'Item requested by employees', icon = icon('flash'), color = 'yellow')
  })
})
shinyApp(ui, server)
