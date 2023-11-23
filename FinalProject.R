library(shiny)
library(ggplot2)
library(tidyr)
library(dplyr)

squirrels_df <- read.csv("2018_Central_Park_Squirrel_Census_-_Squirrel_Data copy.csv")

age_activities <- c("Location", "Shift", "Age", "Running", "Chasing", "Climbing", "Eating", "Foraging")
newdf <- squirrels_df[age_activities]
newdf <- newdf[rowSums(newdf == "" | newdf == "?", na.rm = TRUE) == 0, , drop = FALSE]

agevalues <- newdf %>%
  group_by(Age) %>%
  summarize(Running = sum(Running == "true"), Chasing = sum(Chasing == "true"), Climbing = sum(Climbing == "true"), 
            Eating = sum(Eating == "true"), Foraging = sum(Foraging == "true"))

ageplot <- agevalues %>%
  gather(key = "Activity", value = "Count", -Age)

shiftvalues <- newdf %>%
  group_by(Shift) %>%
  summarize(Running = sum(Running == "true"), Chasing = sum(Chasing == "true"), Climbing = sum(Climbing == "true"), 
            Eating = sum(Eating == "true"), Foraging = sum(Foraging == "true"))

shiftplot <- shiftvalues %>%
  gather(key = "Activity", value = "Count", -Shift)

locationvalues <- newdf %>%
  group_by(Location) %>%
  summarize(Running = sum(Running == "true"), Chasing = sum(Chasing == "true"), Climbing = sum(Climbing == "true"),
            Eating = sum(Eating == "true"),Foraging = sum(Foraging == "true"))

locationplot <- locationvalues %>%
  gather(key = "Activity", value = "Count", -Location)

ui <- fluidPage(
  navbarPage(
    title = "Squirrel Analysis",
    tabPanel("Age Analysis", plotOutput("agePlot", width = "80%", height = "400px"), verbatimTextOutput("ageTextOutput")),
    tabPanel("AM and PM Analysis", plotOutput("shiftPlot", width = "80%", height = "400px"), verbatimTextOutput("shiftTextOutput")),
    tabPanel("Squirrel Location Analysis", plotOutput("locationPlot", width = "80%", height = "400px"), verbatimTextOutput("locationTextOutput"))
  )
)

server <- function(input, output) {
  output$agePlot <- renderPlot({
    ggplot(ageplot, aes(x = Age, y = Count, fill = Activity)) + geom_bar(stat = "identity") + theme_minimal(base_size = 16) + 
      theme(text = element_text(face = "bold")) + 
      labs(title = "Looking at Age and Activity Levels Between Squirrels (Adults & Juveniles)", x = "Age Group", y = "Count") +
      scale_fill_manual(
        values = c("Running" = "chartreuse3", "Chasing" = "blue", "Climbing" = "firebrick1", "Eating" = "orange", "Foraging" = "purple1")
      )})
  
  output$ageTextOutput <- renderText({
    "From the Central Park Squirrel Census CSV from 2018, I explored the relationship between the ages of the squirrels 
    and the level of activities. I specifically used a stacked bar plot because I was considering 4 variables/activities
    which when plotting, would cause too much information being presented on a plot if using another type of visualization.
    In terms of age, squirrels were classified by only two age groups, Adults and Juveniles. Adults being one year plus in 
    age and juveniles being up to six months old. Now in terms of activities I specifically looked at running, chasing, climbing, 
    eating, and foraging. From the stacked bar plot, it can be seen that adult squirrels had higher activity levels compared to
    juvenile squirrels across all the activities that were being factored."
  })
  
  output$shiftPlot <- renderPlot({
    ggplot(shiftplot, aes(x = Shift, y = Count, fill = Activity)) + geom_bar(stat = "identity", position = position_dodge()) +
      theme_minimal(base_size = 16) + theme(text = element_text(face = "bold")) +
      labs(title = "Activity Levels Between Squirrels (AM and PM)", x = "Shift", y = "Count") +
      scale_fill_manual(
        values = c("Running" = "chartreuse3", "Chasing" = "blue", "Climbing" = "firebrick1", "Eating" = "orange", "Foraging" = "purple1")
      )})
  
  output$shiftTextOutput <- renderText({
    "For the second visualization I'm looking at the relationship between the hours at which the squirrels are being observed and 
    the activity level of the squirrels. In order to do this visualization, I needed to group all the AM and PM rows in the dataset
    and then depending on the AM or PM status, I calculated the count for each activity for that specific row. In the visualization
    it can be seen that Foraging, in both the AM and PM hours, is the highest activity for squirrels. However, when looking at the AM
    hours, Climbing was the second highest activity with running behind it, and chasing as the least activity done. Looking at the PM
    hours, Eating is the second highest activity done by the squirrels with Running behind it, while Chasing once again is the least
    activity done."
  })
  
  output$locationPlot <- renderPlot({
    ggplot(locationplot, aes(x = Location, y = Count, fill = Activity)) + geom_bar(stat = "identity", position = "dodge") +
      theme_minimal(base_size = 16) + theme(text = element_text(face = "bold")) +
      labs(title = "Squirrel Activity Levels Based on Location", x = "Location", y = "Count") +
      scale_fill_manual(
        values = c("Running" = "chartreuse3", "Chasing" = "blue", "Climbing" = "firebrick1", "Eating" = "orange", "Foraging" = "purple1")
      )
  })
  
  output$locationTextOutput <- renderText({
    "For the third visualization I'm looking at the relationship between the location at which the squirrels are being located
    and the activity level of the squirrels. In order to do this visualization, I needed to group all the Above Ground and Ground
    PLane rows in the dataset and then depending on the status of these values, I calculated the count for each activity for that 
    specific row/squirrel. In the visualization, when looking at the Above Ground value it can be seen that Climbing was the highest
    activity level with Running and Eating as a close second between squirrels, and Chasing as the lowest activity level between 
    squirrels. When looking at the Ground Plane value under the Location variable, it can be noted that Foraging is the activity
    that squirrels tend to do the most on the ground, with Eating as a close second and running as the third highest activity done by
    squirrels. It must also be noted that Climbing, which was the most done activity above ground, is the lowest activity done when on
    the ground level."
  })
}
shinyApp(ui = ui, server = server)
