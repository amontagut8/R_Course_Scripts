#===SECTION 15===#
#Skipping to the exercises since this might be too easy
install.packages(ggthemes)

library(ggplot2)
#library(ggthemes)
head(mpg)

#question 1:Histogram of hwy mpg values:
q1 <- ggplot(data=mpg, aes(x=hwy)) + geom_histogram(fill="pink")
q1

#Question 2: Barplot of car counts per manufacturer with color fill defined by cyl count
q2 <- ggplot(data=mpg) +
      geom_bar(aes(x=manufacturer, colour=factor(cyl), fill=factor(cyl)))

q2

#Switch now to use the txhousing dataset that comes with ggplot2
head(txhousing,n=3)
#Question 3: create a scatterplot of volume versus sales. 
#Afterwards play around with alpha and color arguments to clarify information.

cities_of_interest <- txhousing[txhousing$city=="Abilene" | txhousing$city=="Fort Worth" | txhousing$city =="Wichita Falls",]

q3 <- ggplot(data=txhousing) + geom_point(aes(x=sales, y=volume), na.rm=T)
q3

#Add a smooth fit line to the scatterplot from above. 
#Hint: You may need to look up geom_smooth()

q4 <- q3 + geom_smooth(aes(x=sales, y=volume), colour="red")
q4





