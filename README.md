# Final-Project
For the final project for the class, I decided to switch my initial idea of looking at returns in the market
and instead focus on squirrels. The main question I aim to study is, "How do Squirrel's surroundings and
characteristics influence/affect their activity level?". From the https://data.gov/ link, I will be using a
CSV file called 2018_Central_Park_Squirrel_Census, which includes many columns/variables such as the X and Y
coordinates of the squirrel, their fur color, age, and what activities they were doing at the moment of being
studied. The list of activities includes eating, foraging, running, chasing, and climbing. 

For my first visualization, I decided to explore the relationship between age and activities and created a
stacked bar plot. In the dataset, squirrels have an age of either adult or juvenile. Adult means that they are
a year old and older, while a juvenile means that a squirrel is up to six months old. I then collected 
information on the activity that was being done. By looking at the stacked bar plot, it can be noted that adult
squirrels had higher activity levels across the board when compared to juvenile squirrels, who had very 
little activity. This can be attributed to the fact that juvenile squirrels are too young to be doing activities
such as foraging and climbing. 

For the second visualization I'm looking at the relationship between the hours at which the squirrels are being observed and 
the activity level of the squirrels. In order to do this visualization, I needed to group all the AM and PM rows in the dataset
and then depending on the AM or PM status, I calculated the count for each activity for that specific row. In the visualization
it can be seen that Foraging, in both the AM and PM hours, is the highest activity for squirrels. However, when looking at the AM
hours, Climbing was the second highest activity with running behind it, and chasing as the least activity done. Looking at the PM
hours, Eating is the second highest activity done by the squirrels with Running behind it, while Chasing once again is the least
activity done.

For the third visualization I'm looking at the relationship between the location at which the squirrels are being located
and the activity level of the squirrels. In order to do this visualization, I needed to group all the Above Ground and Ground
PLane rows in the dataset and then depending on the status of these values, I calculated the count for each activity for that 
specific row/squirrel. In the visualization, when looking at the Above Ground value it can be seen that Climbing was the highest
activity level with Running and Eating as a close second between squirrels, and Chasing as the lowest activity level between 
squirrels. When looking at the Ground Plane value under the Location variable, it can be noted that Foraging is the activity
that squirrels tend to do the most on the ground, with Eating as a close second and running as the third highest activity done by
squirrels. It must also be noted that Climbing, which was the most done activity above ground, is the lowest activity done when on
the ground level.

Link to download CSV: 
https://catalog.data.gov/dataset/2018-central-park-squirrel-census-squirrel-data
