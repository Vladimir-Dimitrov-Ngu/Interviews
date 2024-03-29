# library(shiny)
# library(shinydashboard)
# library(dplyr)
#library(ggplot2)
# df <- read.csv('C:\\Users\\user\\Interviews\\�������� ������� �������� �������\\forFBpost.csv', encoding='UTF-8', sep=';')
ui <- shinyUI(
  dashboardPage(title = '�������� �������', skin = 'blue',
                dashboardHeader(
                  title = '�������� �������', 
                  # ��� ���� �����������
                  dropdownMenu(type='notification'),
                  dropdownMenu(type = 'tasks'),
                  dropdownMenu(type = 'message')
                  
                ),
                dashboardSidebar(
                  sidebarMenu(
                    selectInput(inputId = "city", 
                                label = "�������� �����", 
                                choices = unique(unique(df['�����']))),
                    sliderInput('year', '�������� ����', min(df['year']), max(df['year']), value = c(min(df['year']), min(df['year']) + 15)),
                    menuItem('������', tabName = 'data', icon = icon('database')),
                    menuItem('������������ ����������', tabName = 'stat', icon = icon('braille')),
                    menuItem('�������� ������', tabName = 'lplot1', icon = icon('line-chart')),
                    menuItem('�������� ������ � ��', tabName = 'lplot2', icon = icon('area-chart')),
                    menuItem('�������� ���������', tabname = 'pplot', icon = icon('pie-chart')),
                    menuItem('���������� ���������', tabname = 'bplot', icon = icon('bar-chart'))
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
                      h2('�������� ������'),
                      tabName = 'lplot1',
                      plotOutput('line1')
                    ),
                    tabItem(
                      h2('�������� ������ � ������������� ����������'),
                      tabName = 'lplot2',
                      plotOutput('line2')
                    )
                 )
                )
  )
)
server <- shinyServer(function(input, output){
  dfnew <- {(
    reactive(df%>% filter(df['�����'] == input$city & df['year'] >= input$year[1] & df['year'] <= input$year[2]))
  )}
  output$data <- {(
    renderTable(head(dfnew(), 10))
  )}
  output$sum <- {(
    renderPrint(summary(dfnew()))
  )}
  output$line1 <- renderPlot({
    ggplot(dfnew(), 
           aes(year)) + geom_line(aes(year, ������,colour='model'), alpha=0.5)+
      geom_line(aes(year, fact,colour='fact')) + xlab('���') + ylab('�������� ������')
      })
  output$line2 <- renderPlot({
    ggplot(dfnew(), 
           aes(year)) + geom_line(aes(year, ������,colour='model'), alpha=0.5)+
      xlab('��������')}+geom_line(aes(year, ������.�������, colour = 'interval'), alpha=0.3)+
      geom_line(aes(year, �������.�������, colour = 'interval'), alpha=0.3) + xlab('���')  + ylab('�������� ������'))
  output$year <- {(
    renderText(input$year[2])
  )}
  
})
shinyApp(ui, server)
