#install.packages("shinydashboard")
library(shinydashboard)
library(shiny)
library(ggplot2)
library(dplyr)
dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)
df <- read.csv('C:\\Users\\user\\Interviews\\Тестовое задание Цифровой Двойник\\forFBpost.csv', encoding='UTF-8', sep=';')

ui <- fluidPage(
  selectInput(inputId = "Город", 
              label = "Выберете город", 
              choices = unique(unique(df['Город']))), 
  plotOutput("line")
)
ui <- dashboardPage(
  dashboardHeader(title = "Дашборд"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      column(4,
        title = "Город",
        selectInput(inputId = "Город", 
                    label = "Выберете город", 
                    choices = unique(unique(df['Город'])))
      )
  #  box(plotOutput("line", height = 250)),
   # box(plotOutput("line2", height = 250)))
  ),
  box(plotOutput("line", height = 450)),
  box(plotOutput("line2", height = 450))))
server <- function(input, output) {
  output$line <- renderPlot({
    ggplot(df %>% filter(df['Город'] == input$Город), 
           aes(year)) + geom_line(aes(year, Модель,colour='model'), alpha=0.5)+
      geom_line(aes(year, fact,colour='fact')) + xlab('Значение')})
  output$line2 <- renderPlot({
    ggplot(df %>% filter(df['Город'] == input$Город), 
           aes(year)) + geom_line(aes(year, Модель,colour='model'), alpha=0.5)+
      xlab('Значение')}+geom_line(aes(year, Нижняя.граница, colour = 'interval'), alpha=0.3)+
      geom_line(aes(year, Верхняя.граница, colour = 'interval'), alpha=0.3) + xlab('Значение'))
}
shinyApp(ui, server)

