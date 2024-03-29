library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(glue)
df <- read.csv('C:\\Users\\user\\Interviews\\�������� ������� �������� �������\\forFBpost.csv', encoding='UTF-8', sep=';')

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
                    menuItem('��������', tabName = 'Hypothesis', icon = icon('question')),
                    menuItem('������������ ����������', tabName = 'stat', icon = icon('braille')),
                    menuItem('�������� ������', tabName = 'narrative', icon = icon('align-justify')),
                    menuItem('������� ����� ��������', tabName = 'growth', icon = icon('arrow-up')),
                    menuItem('�������� ������', tabName = 'lplot1', icon = icon('line-chart')),
                    menuItem('�������� ������ � ��', tabName = 'lplot2', icon = icon('area-chart')),
                    menuItem('���������� ���������', tabName = 'bplot', icon = icon('bar-chart')),
                    menuItem('�������� ���������', tabName = 'dplot', icon = icon('caret-square-o-up')),
                    menuItem('������� ��������', tabName = 'error', icon = icon('calculator')),
                    menuItem('������', tabName ='conclusion', icon = icon('certificate'))
                  )
                ),
                dashboardBody(
                  tabItems(
                    tabItem(
                      tabName = 'data',
                      tableOutput('data')
                      ),
                    tabItem(
                      tabName = 'Hypothesis',
                      h2('��������'),
                      h4('1) ���� �������� ���������� ��������� � ����� ����������'),
                      h4('2) ����������� ��������� �� ���� ��������������� ������ �� ������� �� �����'),
                      h4('3) ����� ����������� ��������� �� ����� ���������������� �����'),
                      h4('4) ������������� ������� � ������ ���������'),
                      h4('5) ���������� �������� �������� � ������ ������������� ������'),
                      h4('6) ������ �� ����������� ������ ����������'),
                      
                    ),
                    tabItem(
                      tabName = 'stat',
                      verbatimTextOutput('sum')
                    ),
                    tabItem(
                      tabName = 'narrative',
                      h3('�������� ������'),
                      textOutput('descr'),
                      textOutput('descr2'),
                      textOutput('descr3'),
                      textOutput('descr4'),
                      textOutput('descr5')
                    ),
                    tabItem(
                      tabName = 'growth',
                      tableOutput('rate')
                      
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
                    ),
                    tabItem(
                      h2('���������� ������'),
                      tabName = 'bplot',
                      plotOutput('bar')
                    ),
                    tabItem(
                      h2('����� �������� ����������� ���������'),
                      tabName = 'dplot',
                      plotOutput('line3')
                    ),
                    tabItem(
                      h3('������� �������� ������'),
                      tabName = 'error', 
                      textOutput('mse'),
                      textOutput('rmse')
                      
                    ),
                    tabItem(
                      h3('������'),
                      tabName = 'conclusion',
                      textOutput('conclusion1'),
                      textOutput('conclusion2'),
                      glue('����� ����������� ��������� �� ���� ��������������� ������ ������� ����� ��������������� ����, � ��������� ����������� ��������� �� �����.'),
                      textOutput('conclusion3'),
                      textOutput('conclusion4'),
                      h4('1) ��������� ���������� � ���������������� ���������'),
                      h4('2) ��������� ������ �������������� � ������ �������'),
                      h4('3) ��������� ���������� ����������� �������'),
                      h4('4) ��������� ������������ ������ � �������� �������'),
                      h4('5) ����������� ���� ��������� ���������������')
                           
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
    renderTable(head(dfnew(), 150))
  )}
  output$sum <- {(
    renderPrint(summary(dfnew()))
  )}
  output$descr <- {(
   renderText(
     glue('������ �������� �� {input$year[1]}-{input$year[2]} ���� ��� ������ {input$city}.')
   )
  )}
  output$descr2 <- {(
    renderText(glue('����������� ��������� �� {input$year[1]}:  {ifelse(is.na(dfnew() %>% filter(year == input$year[1])%>% select(fact))==T, "�� ����", dfnew() %>% filter(year == input$year[1])%>% select(fact))}.
                    ����������� ��������� �� {input$year[2]}:  {ifelse(is.na(dfnew() %>% filter(year == input$year[2])%>% select(fact))==T, "�� ����", dfnew() %>% filter(year == input$year[2])%>% select(fact))}.'))  )}
  output$descr3 <- {(
    renderText(glue('��������� �� {input$year[1]} �� ������������� ������ ���������� {dfnew() %>% filter(year == input$year[1])%>% select(������)}.
                    ��������� �� {input$year[2]} �� ������������� ������ ���������� {dfnew() %>% filter(year == input$year[2])%>% select(������)}.'))
  )}
  output$descr4 <- {(
    renderText(glue('������� ����������� ��������� �� ���� ������: {dfnew() %>% summarise(n = mean(������))}'))
  )}
  output$descr5 <- {(
    renderText(glue('������������� ������� ��������� �� ���� ������: {dfnew() %>% summarise(n = sd(������)) %>% mutate(n = as.integer(n))}'))
  )}
  
  output$rate <- {(
    renderTable(dfnew() %>% mutate(growth = 100 * (������ - lag(������))/lag(������)) %>% select(year,growth_percent = growth))
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

  output$bar <- renderPlot({
    ggplot(data = dfnew(), aes(x = year , y = ������)) + geom_bar(stat='identity', fill = 'steelblue', ) + theme_minimal()+scale_x_continuous(breaks=seq(2000, 2125, 5))+ theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  })
  output$line3 <- renderPlot({
    df %>% 
      filter(df['year'] >= input$year[1] & df['year'] <= input$year[2]) %>% 
      group_by(year) %>%
      summarise(n = sum(������)) %>%
      ggplot(aes(x = year)) + geom_line(aes(year, n), color = 'blue') + ylab('����������� ���������') + xlab('����')  + theme_minimal() + geom_point(aes(year, n),alpha=0.4,  color = 'red')
  })
  output$mse <- ({
    renderText(glue('MSE : {sum((dfnew()["fact"] - dfnew()["������"])^2, na.rm = T) / nrow(dfnew()["fact"])}'))
  })
  output$rmse <- ({
    renderText(glue('RMSE : {(sum((dfnew()["fact"] - dfnew()["������"])^2, na.rm = T)/ nrow(dfnew()["fact"]))^0.5}'))
  })
  
  output$conclusion1 <- ({

    renderText(glue('������� ���� �������� �����: {dfnew() %>% mutate(growth = 100 * (������ - lag(������))/lag(������)) %>% select(growth) %>% summarise(n = mean(growth, na.rm = T))}'))
  })
  
  output$conclusion2 <- ({
    renderText(ifelse(dfnew() %>% mutate(growth = 100 * (������ - lag(������))/lag(������)) %>% select(growth) %>% summarise(n = mean(growth, na.rm = T)) > 0, '������������� ���� ����� ��������� ����� ���� ���������� ������������� ���������-������������� ��������',
                      '������������� ���� ����� ��������� �����  ����������������� � ��������������� ����������-������������� ��������'))
  })
  output$conclusion3 <- ({
    
    renderText(glue('����������� ����������  �� ��������������� ���������� �������: {dfnew() %>% summarise(n = (sd(������)))}'))
  })
  
  output$conclusion4 <- ({
    renderText(glue('����� ���� ����� ��������� �� ��� ����� ����������� ���������������� �����. ��� ��������� ����� �����, ���������� ����������� ��������� ����:'))
  })
  
  output$year <- {(
    renderText(input$year[2])
  )}

})
shinyApp(ui, server)
