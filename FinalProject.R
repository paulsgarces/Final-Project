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

ui <- fluidPage(
  navbarPage(
    title = "Squirrel Analysis",
    tabPanel("Introduction", titlePanel("How Do Surroundings and Characteristics Affect Squirrel's Acvitiy Level?"),
             verbatimTextOutput("introText"), tableOutput("CSVsample")),
    tabPanel("Age Analysis", 
             selectInput("ageVariable", "Select Age Group", choices = c("All", unique(newdf$Age))),
             plotOutput("agePlot", width = "55%", height = "550px"), 
             verbatimTextOutput("ageTextOutput")),
    tabPanel("AM and PM Analysis", 
             selectInput("shiftVariable", "Select Shift", choices = c("All", unique(newdf$Shift))),
             plotOutput("shiftPlot", width = "55%", height = "550px"), 
             verbatimTextOutput("shiftTextOutput")),
    tabPanel("Squirrel Location Analysis", 
             selectInput("locationVariable", "Select Location", choices = c("All", unique(newdf$Location))),
             plotOutput("locationPlot", width = "55%", height = "550px"), 
             verbatimTextOutput("locationTextOutput"))
  )
)

server <- function(input, output) {
  output$introText <- renderText({
    "For the final project for the class, I decided to study how do squirrel's surroundings 
    and characteristics influence/affect their activity level?. From the https://data.gov/ website, I used the 
    CSV file called 2018_Central_Park_Squirrel_Census. As for the x variables/inputs for my graphs I decided to
    use the age of the squirrels(Adults and Juveniles ), the shifts they were being studied during (AM and PM), 
    as well as their location the squirrels were at during the observations (Above Ground and Ground Plane). I
    found it fitting to use bar graphs for all graphs, as well as adding a dropdown widget to all graphs, allowing 
    the user to compare side-by-side or individually across graphs.
    Below is a list of sample variables in the CSV file being used:
    - Unique Squirrel ID
    - Hectare	
    - Shift	
    - Date	
    - Hectare 
    - Squirrel Number	
    - Age
    Additionally, there is a sample of 13 columns and 15 rows below demonstrating the CSV file in use."
  })
  
  output$CSVsample <- renderTable({
    head(select(squirrels_df, X,	Y,	Hectare,	Shift,	Date,	Hectare, Running, Chasing, Foraging, Eating,	Age, Kuks,	Quaas,	Moans), 15)
  })
  
  output$agePlot <- renderPlot({
    filtered_df <- filter(newdf, if (input$ageVariable == "All") TRUE 
                          else Age == input$ageVariable)
    agevalues <- filtered_df %>%
      group_by(Age) %>%
      summarize(Running = sum(Running == "true"), Chasing = sum(Chasing == "true"), Climbing = sum(Climbing == "true"), 
                Eating = sum(Eating == "true"), Foraging = sum(Foraging == "true"))
    ageplot <- agevalues %>%
      gather(key = "Activity", value = "Count", -Age)
    
    ggplot(ageplot, aes(x = Age, y = Count, fill = Activity)) + geom_bar(stat = "identity") + 
      theme_minimal(base_size = 16) + theme(text = element_text(face = "bold", size = 20)) + 
      labs(title = paste("Looking at Age and Activity Levels Between Squirrels (", if (input$ageVariable == "All") "All" 
                         else input$ageVariable, ")", sep = ""), 
           x = "Age Group", y = "Total Squirrel Count") +
      scale_fill_manual(
        values = c("Running" = "chartreuse3", "Chasing" = "blue", "Climbing" = "firebrick1", 
                   "Eating" = "orange", "Foraging" = "purple1")
      )
  })
  
  output$ageTextOutput <- renderText({
    if (input$ageVariable == "All") {
      "The above graph shows the count of activities for both both Adults and Juveniles side by side."
    } else {
      paste("The above graph specifically shows the count for squirrels in age group of", input$ageVariable,"'s.")
    }
  })
  
  output$shiftPlot <- renderPlot({
    filtered_df <- filter(newdf, if (input$shiftVariable == "All") TRUE 
                          else Shift == input$shiftVariable)
    shiftvalues <- filtered_df %>%
      group_by(Shift) %>%
      summarize(Running = sum(Running == "true"), Chasing = sum(Chasing == "true"), Climbing = sum(Climbing == "true"), 
                Eating = sum(Eating == "true"), Foraging = sum(Foraging == "true"))
    shiftplot <- shiftvalues %>%
      gather(key = "Activity", value = "Count", -Shift)
    
    shiftplotam <- shiftplot[shiftplot$Shift == "AM", ]
    shiftplotpm <- shiftplot[shiftplot$Shift == "PM", ]
    
    shiftplotamorder <- shiftplotam %>%
      arrange(desc(Count)) %>%
      mutate(Activity = factor(Activity, levels = Activity[order(-Count)]))
    
    shiftplotpmorder <- shiftplotpm %>%
      arrange(desc(Count)) %>%
      mutate(Activity = factor(Activity, levels = Activity[order(-Count)]))
    
    ggplot() +
      geom_bar(data = shiftplotamorder, aes(x = Shift, y = Count, fill = Activity), stat = "identity", position = position_dodge()) +
      geom_bar(data = shiftplotpmorder, aes(x = Shift, y = Count, fill = Activity), stat = "identity", position = position_dodge()) +
      theme_minimal(base_size = 16) + theme(text = element_text(face = "bold", size = 20)) + 
      labs(title = paste("Activity Levels Between Squirrels (", if (input$shiftVariable == "All") "All" 
                         else input$shiftVariable, ")", sep = ""), 
           x = "Shift", y = "Count") +
      scale_fill_manual(values = c("Running" = "chartreuse3", "Chasing" = "blue", "Climbing" = "firebrick1", 
                                   "Eating" = "orange", "Foraging" = "purple1"))
  })
  
  output$shiftTextOutput <- renderText({
    if (input$shiftVariable == "All") {
      "The above graph shows the count of activities for squirrles being observed at either AM or PM side by side."
    } else {
      paste("The above graph specifically shows the count for squirrels that are being observed during", input$shiftVariable, "shift.")
    }
  })
  
  output$locationPlot <- renderPlot({
    filtered_df <- filter(newdf, if (input$locationVariable == "All") TRUE 
                          else Location == input$locationVariable)
    locationvalues <- filtered_df %>%
      group_by(Location) %>%
      summarize(Running = sum(Running == "true"), Chasing = sum(Chasing == "true"), Climbing = sum(Climbing == "true"),
                Eating = sum(Eating == "true"), Foraging = sum(Foraging == "true"))
    locationplot <- locationvalues %>%
      gather(key = "Activity", value = "Count", -Location)
    
    locationplotabove <- locationplot[locationplot$Location == "Above Ground", ]
    locationplotground <- locationplot[locationplot$Location == "Ground Plane", ]
    
    locationplotaboveorder <- locationplotabove %>%
      arrange(desc(Count)) %>%
      mutate(Activity = factor(Activity, levels = Activity[order(-Count)]))
    
    locationplotgroundorder <- locationplotground %>%
      arrange(desc(Count)) %>%
      mutate(Activity = factor(Activity, levels = Activity[order(-Count)]))
    
    ggplot() + 
      geom_bar(data = locationplotaboveorder, aes(x = Location, y = Count, fill = Activity), stat = "identity", position = position_dodge()) + 
      geom_bar(data = locationplotgroundorder, aes(x = Location, y = Count, fill = Activity), stat = "identity", position = position_dodge()) +
      theme_minimal(base_size = 16) + theme(text = element_text(face = "bold", size = 20)) +
      labs(title = paste("Squirrel Activity Levels Based on Location (", if (input$locationVariable == "All") "All" 
                         else input$locationVariable, ")", sep = ""), 
           x = "Location", y = "Count") +
      scale_fill_manual(values = c("Running" = "chartreuse3", "Chasing" = "blue", "Climbing" = "firebrick1", 
                                   "Eating" = "orange", "Foraging" = "purple1"))
  })
  
  output$locationTextOutput <- renderText({
    if (input$locationVariable == "All") {
      "The above graph shows the count of activities for both both Above Ground and Ground Plane side by side."
    } else {
      paste("The above graphs specifically shows the count for squirrels that are", input$locationVariable, "at the point of being observed.")
    }
  })
}

shinyApp(ui = ui, server = server)

                                                           