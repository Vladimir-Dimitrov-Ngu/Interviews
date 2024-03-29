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
df <- read.csv('C:\\Users\\user\\Interviews\\�������� ������� �������� �������\\forFBpost.csv', encoding='UTF-8', sep=';')

ui <- fluidPage(
  selectInput(inputId = "�����", 
              label = "�������� �����", 
              choices = unique(unique(df['�����']))), 
  plotOutput("line")
)
ui <- dashboardPage(
  dashboardHeader(title = "�������"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      column(4,
        title = "�����",
        selectInput(inputId = "�����", 
                    label = "�������� �����", 
                    choices = unique(unique(df['�����'])))
      )
  #  box(plotOutput("line", height = 250)),
   # box(plotOutput("line2", height = 250)))
  ),
  box(plotOutput("line", height = 450)),
  box(plotOutput("line2", height = 450))))
server <- function(input, output) {
  output$line <- renderPlot({
    ggplot(df %>% filter(df['�����'] == input$�����), 
           aes(year)) + geom_line(aes(year, ������,colour='model'), alpha=0.5)+
      geom_line(aes(year, fact,colour='fact')) + xlab('��������')})
  output$line2 <- renderPlot({
    ggplot(df %>% filter(df['�����'] == input$�����), 
           aes(year)) + geom_line(aes(year, ������,colour='model'), alpha=0.5)+
      xlab('��������')}+geom_line(aes(year, ������.�������, colour = 'interval'), alpha=0.3)+
      geom_line(aes(year, �������.�������, colour = 'interval'), alpha=0.3) + xlab('��������'))
}
shinyApp(ui, server)

