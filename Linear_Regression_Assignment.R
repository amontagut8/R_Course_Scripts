###===LINEAR REGRESSION ASSIGNMENT===#
install.packages("ggplot2")

library(ggplot2)
library(dplyr)
library(corrgram)
library(corrplot)
library(caTools)

#Obtain the data
bike <- read.csv("C:\\Users\\amontagut\\Desktop\\R\\DataScience_and_ML\\R-Course-HTML-Notes\\R-for-Data-Science-and-Machine-Learning\\Training Exercises\\Machine Learning Projects\\CSV files for ML Projects\\bikeshare.csv")

#Explore the data a little
head(bike)
str(bike)
summary(bike)

#=======================================EDA
#Re-factoring the weather, holiday, workingday, and season columns since these are categoricals
bike$season <- factor(bike$season)
bike$holiday <- factor(bike$holiday)
bike$weather <- factor(bike$weather)
bike$workingday <- factor(bike$workingday)

#"datetime" is also considered an integer. Convert it to a datetime
bike$datetime <- as.POSIXct(bike$datetime)

#bike$datetime <- as.POSIXct(strptime(bike$datetime,format="%Y-%m-%d %H-%M-%S"))

summary(bike)
str(bike)

#From Kaggle: "You must predict the total count of bikes rented during each hour covered 
#by the test set, using only information available prior to the rental period."
#The training set is comprised of the first 19 days of each month, while the test set is the 20th to the end of the month

#Create a scatter plot of count vs temp. Set a good alpha value.
p<- ggplot(data=bike, aes(x=temp, y=count, colour=temp), alpha=0.3) + geom_point()
p

#Plot count versus datetime as a scatterplot with a color gradient based on temperature. 
#You'll need to convert the datetime column into POSIXct before plotting.
#Already did so skipping that

print(ggplot(bike,aes(x=datetime,y=count)) + geom_point(aes(color=temp),alpha=0.5)+
          scale_color_continuous(low='#55D8CE',high='#FF6E2E'))

#What is the correlation between temp and count?
#Create boolean is.numeric() function
numeric_cols <- sapply(bike, is.numeric)
cor_table <- cor(bike[, numeric_cols])
cor_table["temp", "count"] #<------this gives us our answer

#Let's explore the season data. 
#Create a boxplot, with the y axis indicating count and the x axis being a box for each season.
q<- ggplot(data=bike, aes(x=season, y=count)) + 
    geom_boxplot(aes(colour=season)) 
    
#========================FEATURE ENGINEERING

#Create an "hour" column that takes the hour from the datetime column. 
#You'll probably need to apply some function to the entire datetime column and reassign it.


bike$hour <- format(bike$datetime, "%H")

#Now create a scatterplot of count versus hour, with color scale based on temp. 
#Only use bike data where workingday==1.

print(ggplot(data=bike[bike$workingday==1,], aes(x=hour,y=count, colour=temp))+geom_point())

#Optional additions: Use the additional layer: scale_color_gradientn(colors=c('color1',color2,etc..)) where the colors argument is a vector gradient of colors you choose, not just high and low.

print(ggplot(data=bike[bike$workingday==1,], aes(x=hour,y=count, colour=temp))+ 
      geom_point()) +
      scale_color_gradientn(colors=c("red", "pink", "maroon", "orange", "green"))

#Use position=position_jitter(w=1, h=0) inside of geom_point() and check out what it does.
print(ggplot(data=bike[bike$workingday==1,], aes(x=hour,y=count, colour=temp))+ 
        geom_point(position=position_jitter(w=1, h=0))) +
  scale_color_gradientn(colors=c("red", "pink", "maroon", "orange", "green"))

#Now create the same plot for non working days:
print(ggplot(data=bike[bike$workingday==0,], aes(x=hour,y=count, colour=temp))+ 
        geom_point(position=position_jitter(w=1, h=0))) +
  scale_color_gradientn(colors=c("red", "pink", "maroon", "orange", "green"))

#===========================BUILDING THE MODEL
#Use lm() to build a model that predicts count based solely on the temp feature, name it temp.model

temp.model <- lm(count~temp, data=bike)

#Get the summary of the temp.model
summary(temp.model)

#How many bike rentals would we predict if the temperature was 25 degrees Celsius? Calculate this two ways:
##Using the values we just got above
####Our linear model is basically y=9.1705x + 6.0462
9.1705*25+6.0462

##Using the predict() function. This is how to predict one value using our model
temp.test <- data.frame(temp=c(25))
predict(temp.model, temp.test)

#Use sapply() and as.numeric to change the hour column to a column of numeric values.

bike$hour <- sapply(bike$hour, as.numeric)

#Finally build a model that attempts to predict count based off of the following features. Figure out if theres a way to not have to pass/write all these variables into the lm() function. 
#Hint: StackOverflow or Google may be quicker than the documentation.
#######Vars:season
# holiday
# workingday
# weather
# temp
# humidity
# windspeed
# hour (factor)



#We use a subset of the data where we select NOT atemp, casual, registered, and datetime, aka -c()
new.model<- lm(count~., data=subset(bike, select=-c(atemp, casual, registered,datetime)))

#get summary
summary(new.model)

#Optional: See how well you can predict for future data points by creating a train/test split. 
#But instead of a random split, your split should be "future" data for test, "previous" data for train.


train <- subset(bike, format(bike$datetime, "%Y")<2012)
test <- subset(bike, format(bike$datetime, "%Y")>=2012)

future_predictor <- lm(count~., data=train)
summary(future_predictor)

count_predictions <- predict(future_predictor, test)

comparison <- cbind(count_predictions, test$count)
colnames(comparison) <- c("predicted", "actual")
comparison <- as.data.frame(comparison)


