# library(shiny)
# library(shinydashboard)
# library(dplyr)
#library(ggplot2)
# df <- read.csv('C:\\Users\\user\\Interviews\\Тестовое задание Цифровой Двойник\\forFBpost.csv', encoding='UTF-8', sep=';')
ui <- shinyUI(
  dashboardPage(title = 'Тестовое задание', skin = 'blue',
                dashboardHeader(
                  title = 'Тестовое задание', 
                  # все типы уведомлений
                  dropdownMenu(type='notification'),
                  dropdownMenu(type = 'tasks'),
                  dropdownMenu(type = 'message')
                  
                ),
                dashboardSidebar(
                  sidebarMenu(
                    selectInput(inputId = "city", 
                                label = "Выберете город", 
                                choices = unique(unique(df['Город']))),
                    sliderInput('year', 'Выберите года', min(df['year']), max(df['year']), value = c(min(df['year']), min(df['year']) + 15)),
                    menuItem('Данные', tabName = 'data', icon = icon('database')),
                    menuItem('Описательные статистики', tabName = 'stat', icon = icon('braille')),
                    menuItem('Линейный график', tabName = 'lplot1', icon = icon('line-chart')),
                    menuItem('Линейный график с ДИ', tabName = 'lplot2', icon = icon('area-chart')),
                    menuItem('Круговая диаграмма', tabname = 'pplot', icon = icon('pie-chart')),
                    menuItem('Столбчатая диаграмма', tabname = 'bplot', icon = icon('bar-chart'))
                  )
                ),
                dashboardBody(
                  tabItems(
                    tabItem(
                      tabName = 'data',
                      tableOutput('data')
                      ),
                    tabItem(
                      tabName = 'stat',
                      verbatimTextOutput('sum')
                    ),
                    tabItem(
                      h2('Линейный график'),
                      tabName = 'lplot1',
                      plotOutput('line1')
                    ),
                    tabItem(
                      h2('Линейный график с доверительным интервалом'),
                      tabName = 'lplot2',
                      plotOutput('line2')
                    )
                 )
                )
  )
)
server <- shinyServer(function(input, output){
  dfnew <- {(
    reactive(df%>% filter(df['Город'] == input$city & df['year'] >= input$year[1] & df['year'] <= input$year[2]))
  )}
  output$data <- {(
    renderTable(head(dfnew(), 10))
  )}
  output$sum <- {(
    renderPrint(summary(dfnew()))
  )}
  output$line1 <- renderPlot({
    ggplot(dfnew(), 
           aes(year)) + geom_line(aes(year, Модель,colour='model'), alpha=0.5)+
      geom_line(aes(year, fact,colour='fact')) + xlab('Год') + ylab('Значение модели')
      })
  output$line2 <- renderPlot({
    ggplot(dfnew(), 
           aes(year)) + geom_line(aes(year, Модель,colour='model'), alpha=0.5)+
      xlab('Значение')}+geom_line(aes(year, Нижняя.граница, colour = 'interval'), alpha=0.3)+
      geom_line(aes(year, Верхняя.граница, colour = 'interval'), alpha=0.3) + xlab('Год')  + ylab('Значение модели'))
  output$year <- {(
    renderText(input$year[2])
  )}
  
})
shinyApp(ui, server)
