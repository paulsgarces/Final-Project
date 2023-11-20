library(ggplot2)
library(tidyverse)
library(dplyr)
library(stats)
library(shiny)

squirrels_df <- read.csv("2018_Central_Park_Squirrel_Census_-_Squirrel_Data copy.csv")

age_activities <- c("Age", "Running", "Chasing", "Climbing", "Eating", "Foraging")
newdf <- squirrels_df[age_activities]
newdf <- newdf[rowSums(newdf == "" | newdf == "?", na.rm = TRUE) == 0, , drop = FALSE]


truevalues <- newdf %>%
  group_by(Age) %>%
  summarize(
    Running = sum(Running == "true"),
    Chasing = sum(Chasing == "true"),
    Climbing = sum(Climbing == "true"),
    Eating = sum(Eating == "true"),
    Foraging = sum(Foraging == "true")
  )

values_plot <- truevalues %>%
  gather(key = "Activity", value = "Count", -Age)

ui <- fluidPage(
  titlePanel("How Do Characteristics of Squirrels Affect Their Activity Levels?"),
  plotOutput("squirrelPlot", width = "80%", height = "400px"),
  verbatimTextOutput("textOutput")
)

server <- function(input, output) {
  output$squirrelPlot <- renderPlot({
    ggplot(values_plot, aes(x = Age, y = Count, fill = Activity)) +
      geom_bar(stat = "identity") +
      theme_minimal(base_size = 16) + 
      theme(
        text = element_text(face = "bold") 
      ) +
      labs(
        title = "Looking at Age and Activity Levels Between Squirrels. (Adults & Juveniles)",
        x = "Age Group",
        y = "Count"
      ) +
      scale_fill_manual(
        values = c("Running" = "chartreuse3", "Chasing" = "blue", "Climbing" = "firebrick1", "Eating" = "orange", "Foraging" = "purple1")
      )
  })

  output$textOutput <- renderText({
    "From the Central Park Squirrel Census CSV from 2018, I explored the relationship between the ages of the squirrels 
    and the level of activities. I specifically used a stacked bar plot because I was considering 4 varibales/activites
    which when plotting, would cause too much information being presnted on a plot if using another type of visualization
    In terms of age, squirrels were classified by only two age groups, Adults and Juveniles. Adults being one year plus in 
    age and juveniles being up to six months old. Now in terms of activities I specifically looked at running, chasing, climbing, 
    eating, and foraging. From the stacked bar plot, it can be seen that adult squirrels had higher activity levels compared to
    juvenile squirrels across all the activities that were being factored."
  })
}

shinyApp(ui = ui, server = server)
