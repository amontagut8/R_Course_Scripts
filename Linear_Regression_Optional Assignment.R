install.packages("ggplot2")

library(ggplot2)
library(dplyr)
library(corrgram)
library(corrplot)
library(caTools)

#Obtain the data
bike <- read.csv("C:\\Users\\amontagut\\Desktop\\R\\DataScience_and_ML\\R-Course-HTML-Notes\\R-for-Data-Science-and-Machine-Learning\\Training Exercises\\Machine Learning Projects\\CSV files for ML Projects\\bikeshare.csv")

#Re-factoring the weather, holiday, workingday, and season columns since these are categoricals
bike$season <- factor(bike$season)
bike$holiday <- factor(bike$holiday)
bike$weather <- factor(bike$weather)
bike$workingday <- factor(bike$workingday)

#"datetime" is also considered an integer. Convert it to a datetime
bike$datetime <- as.POSIXct(bike$datetime)


#===========================BUILDING THE MODEL
#Jose suggests using 2011 as training, and 2012 as testing
train <- subset(bike, format(bike$datetime, "%Y")==2011)
test <- subset(bike, format(bike$datetime, "%Y")==2012)

#I am going to omit the "registered" column. This results in performance that is way too good
model <- lm(count~temp+datetime+season+holiday+workingday+weather+temp+atemp+humidity+windspeed+casual, data=train)


summary(model)

count_predict <- predict(model, test)

results <- cbind(count_predict, test$count)
colnames(results) <-c("predicted", "actual")

results <- as.data.frame(results)

#derive RMSE
MSE <- sum((results$actual - results$predicted)^2)

SST <- sum((mean(test$count) - results$actual)^2)

R2 <- 1-(MSE/SST)

#




