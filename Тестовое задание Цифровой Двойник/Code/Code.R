library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(glue)
df <- read.csv('C:\\Users\\user\\Interviews\\Тестовое задание Цифровой Двойник\\forFBpost.csv', encoding='UTF-8', sep=';')

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
                    menuItem('Гипотезы', tabName = 'Hypothesis', icon = icon('question')),
                    menuItem('Описательные статистики', tabName = 'stat', icon = icon('braille')),
                    menuItem('Описание данных', tabName = 'narrative', icon = icon('align-justify')),
                    menuItem('Годовые темпы прироста', tabName = 'growth', icon = icon('arrow-up')),
                    menuItem('Линейный график', tabName = 'lplot1', icon = icon('line-chart')),
                    menuItem('Линейный график с ДИ', tabName = 'lplot2', icon = icon('area-chart')),
                    menuItem('Столбчатая диаграмма', tabName = 'bplot', icon = icon('bar-chart')),
                    menuItem('Динамика населения', tabName = 'dplot', icon = icon('caret-square-o-up')),
                    menuItem('Метрика качества', tabName = 'error', icon = icon('calculator')),
                    menuItem('Выводы', tabName ='conclusion', icon = icon('certificate'))
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
                      h2('Гипотезы'),
                      h4('1) Темп прироста городского населения в целом стабильный'),
                      h4('2) Численность населения за весь рассматриваемый период не выходит на плато'),
                      h4('3) Общая численность населения не имеет экспонециального роста'),
                      h4('4) Дисперсионный разброс в данных минимален'),
                      h4('5) Полученные величины остаются в рамках экономической логики'),
                      h4('6) Ошибка на фактических данных минимальна'),
                      
                    ),
                    tabItem(
                      tabName = 'stat',
                      verbatimTextOutput('sum')
                    ),
                    tabItem(
                      tabName = 'narrative',
                      h3('Описание данных'),
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
                      h2('Линейный график'),
                      tabName = 'lplot1',
                      plotOutput('line1')
                    ),
                    tabItem(
                      h2('Линейный график с доверительным интервалом'),
                      tabName = 'lplot2',
                      plotOutput('line2')
                    ),
                    tabItem(
                      h2('Столбчатый график'),
                      tabName = 'bplot',
                      plotOutput('bar')
                    ),
                    tabItem(
                      h2('Общая динамика численности населения'),
                      tabName = 'dplot',
                      plotOutput('line3')
                    ),
                    tabItem(
                      h3('Метрики качества модели'),
                      tabName = 'error', 
                      textOutput('mse'),
                      textOutput('rmse')
                      
                    ),
                    tabItem(
                      h3('Выводы'),
                      tabName = 'conclusion',
                      textOutput('conclusion1'),
                      textOutput('conclusion2'),
                      glue('Общая численность населения за весь рассматриваемый период времени имеет экспонециальный рост, в некоторых промежутках выходящих на плато.'),
                      textOutput('conclusion3'),
                      textOutput('conclusion4'),
                      h4('1) Увеличить инвестиции в инфраструктурные постройки'),
                      h4('2) Увеличить подвоз продовольствия в данные регионы'),
                      h4('3) Увеличить социальное обеспечение граждан'),
                      h4('4) Расширить кредитования малого и среднего бизнеса'),
                      h4('5) Рассмотреть меры поддержки трудоустройства')
                           
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
    renderTable(head(dfnew(), 150))
  )}
  output$sum <- {(
    renderPrint(summary(dfnew()))
  )}
  output$descr <- {(
   renderText(
     glue('Данные получены за {input$year[1]}-{input$year[2]} года для города {input$city}.')
   )
  )}
  output$descr2 <- {(
    renderText(glue('Фактическое население за {input$year[1]}:  {ifelse(is.na(dfnew() %>% filter(year == input$year[1])%>% select(fact))==T, "не дано", dfnew() %>% filter(year == input$year[1])%>% select(fact))}.
                    Фактическое население за {input$year[2]}:  {ifelse(is.na(dfnew() %>% filter(year == input$year[2])%>% select(fact))==T, "не дано", dfnew() %>% filter(year == input$year[2])%>% select(fact))}.'))  )}
  output$descr3 <- {(
    renderText(glue('Население за {input$year[1]} по предсказаниям модели составляет {dfnew() %>% filter(year == input$year[1])%>% select(Модель)}.
                    Население за {input$year[2]} по предсказаниям модели составляет {dfnew() %>% filter(year == input$year[2])%>% select(Модель)}.'))
  )}
  output$descr4 <- {(
    renderText(glue('Средняя численность населения за этот период: {dfnew() %>% summarise(n = mean(Модель))}'))
  )}
  output$descr5 <- {(
    renderText(glue('Дисперсионный разброс населения за этот период: {dfnew() %>% summarise(n = sd(Модель)) %>% mutate(n = as.integer(n))}'))
  )}
  
  output$rate <- {(
    renderTable(dfnew() %>% mutate(growth = 100 * (Модель - lag(Модель))/lag(Модель)) %>% select(year,growth_percent = growth))
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

  output$bar <- renderPlot({
    ggplot(data = dfnew(), aes(x = year , y = Модель)) + geom_bar(stat='identity', fill = 'steelblue', ) + theme_minimal()+scale_x_continuous(breaks=seq(2000, 2125, 5))+ theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  })
  output$line3 <- renderPlot({
    df %>% 
      filter(df['year'] >= input$year[1] & df['year'] <= input$year[2]) %>% 
      group_by(year) %>%
      summarise(n = sum(Модель)) %>%
      ggplot(aes(x = year)) + geom_line(aes(year, n), color = 'blue') + ylab('Численность населения') + xlab('Года')  + theme_minimal() + geom_point(aes(year, n),alpha=0.4,  color = 'red')
  })
  output$mse <- ({
    renderText(glue('MSE : {sum((dfnew()["fact"] - dfnew()["Модель"])^2, na.rm = T) / nrow(dfnew()["fact"])}'))
  })
  output$rmse <- ({
    renderText(glue('RMSE : {(sum((dfnew()["fact"] - dfnew()["Модель"])^2, na.rm = T)/ nrow(dfnew()["fact"]))^0.5}'))
  })
  
  output$conclusion1 <- ({

    renderText(glue('Средний темп прироста равен: {dfnew() %>% mutate(growth = 100 * (Модель - lag(Модель))/lag(Модель)) %>% select(growth) %>% summarise(n = mean(growth, na.rm = T))}'))
  })
  
  output$conclusion2 <- ({
    renderText(ifelse(dfnew() %>% mutate(growth = 100 * (Модель - lag(Модель))/lag(Модель)) %>% select(growth) %>% summarise(n = mean(growth, na.rm = T)) > 0, 'Положительный темп роста населения может быть следствием благоприятных социально-экономических факторов',
                      'Отрицательный темп роста населения может  свидетельствовать о неблагоприятных соципально-экономических факторов'))
  })
  output$conclusion3 <- ({
    
    renderText(glue('Стандартное отклонение  за рассматриваемый промежуток времени: {dfnew() %>% summarise(n = (sd(Модель)))}'))
  })
  
  output$conclusion4 <- ({
    renderText(glue('Общий темп роста населения за все время подчиняется экспонециальному росту. Как следствие этого факта, необходимо предпринять следующие меры:'))
  })
  
  output$year <- {(
    renderText(input$year[2])
  )}

})
shinyApp(ui, server)
