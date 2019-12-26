#===DATA CAPSTONE PROJECT===#
setwd("C:\\Users\\amontagut\\Desktop\\R\\DataScience_and_ML\\R-Course-HTML-Notes\\R-for-Data-Science-and-Machine-Learning\\Training Exercises\\Capstone and Data Viz Projects\\Capstone Project")

#Ignore this
install.packages("plotly")

library(ggplot2)
library(plotly)

pl <- ggplot(data=mtcars, aes(x=mpg, y=wt)) + geom_point()

gpl <- ggplotly(pl)
gpl
#Okay, now the project

#Read data
batting <- read.csv('Batting.csv')
head(batting)

#Call the head() of the first five rows of AB (At Bats) column
head(batting$AB[1:5])

#Call the head of the doubles (X2B) column
head(batting$X2B[1:5])


#-------------------------FEATURE ENGINEERING
#Batting Average
#Derived from hits divided by At Base
batting$BA <- batting$H / batting$AB

#Sludding Percentage (SLG)
#SLG = (Singles + 2*Doubles + 3*Triples + 4*Homeruns) / AB
#Need to derive singles (X1B) - this is the number of hits minus the sum of doubles, triples, and home runs
batting$X1B <- batting$H - (batting$X2B + batting$X3B + batting$HR)
batting$SLG <- (batting$X1B + 2*batting$X2B + 3*batting$X3B + 4*batting$HR) / batting$AB
  
#On Base Percentage (OBP)
#OBP = (H+BB+HBP)/(AB+BB+HBP+SF)
batting$OBP <- (batting$H + batting$BB + batting$HBP) / (batting$AB + batting$BB + batting$HBP + batting$SF)

#Check the structure of your data frame using str()
str(batting)

#-------------------------MERGE SALARY WITH BATTING DATA

#Load data
salary <- read.csv("Salaries.csv")

#Use subset() to reassign batting to only contain data from 1985 and onwards

batting_post1985 <- subset(batting, subset=yearID >= 1985)
distinct(select(batting_post1985, yearID))

summary(batting_post1985)

#Use the merge() function to merge the batting and sal data frames by 
#c('playerID','yearID'). Call the new data frame combo

combo <- merge(x=batting_post1985, y=salary, by=c('playerID', 'yearID'))
str(combo)

#ANALYZING THE LOST PLAYERS
#Lost players IDs were giambja01, damonjo01, saenzol01

#Use the subset() function to get a data frame called lost_players from the combo data frame consisting of those 3 players. 
#Oops I used bracket notation. Bite me.
lost_player_IDs <- c("giambja01", "damonjo01", "saenzol01")

lost_players <-combo[combo$playerID %in% lost_player_IDs,]

#Use subset() again to only grab the rows where the yearID was 2001.
lost_players <- subset(lost_players, yearID==2001)

#Reduce the lost_players data frame to the following columns: playerID,H,X2B,X3B,HR,OBP,SLG,BA,AB
lost_players <- lost_players[,c("playerID","H","X2B","X3B","HR","OBP","SLG","BA","AB")]

#FIND REPLACEMENT PLAYERS GIVEN THESE CONSTRAINTS:
#The total combined salary of the three players can not exceed 15 million dollars.
# combined number of At Bats (AB) needs to be equal to or greater than the lost players.
#Their mean OBP had to equal to or greater than the mean OBP of the lost players

#Okay so let's get our metrics. 
#sum(salary) <= 15000000
#sum(AB) >= sum(lost_players$AB) = 1469
#mean(OBP) >= mean(lost_players$OBP) = 0.3638687

combo_2001 <- combo[combo$yearID==2001,]

#3 players, so salary has to be MAXIMUM 5,000,000 each. Subset out people whose salaries are over that.
#Same logic applies for AB. Each person has to have an AB of about 450 minimum. Subset out people under that
#Then, order the table by OBP to find the top three contenders

options <- subset(combo_2001, salary < 5000000 & OBP > 0 & AB > 500)
options <- arrange(options, desc(OBP))

head(options[c("playerID", "AB", "OBP", "salary")], n=10)


ggplot(data=combo_2001, aes(x=OBP, y=salary))+
  geom_point(size=2)

