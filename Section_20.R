#===SECTION 20===#

#sample code
model <- lm(y ~ x1 + x2 + x3 + x4, #...
              data=data_train)

dtest$y_predict <- predict(model, newdata=data_test)

#Start the section
setwd("C:\\Users\\amontagut\\Desktop\\R\\DataScience_and_ML\\R-Course-HTML-Notes\\R-for-Data-Science-and-Machine-Learning\\Machine Learning with R")

#Get data
df <- read.csv('student-mat.csv', sep = ";")

#Trying to predict G1, G2, G3

head(df)
summary(df)

#-------------------------------------EDA
#Check for NANs
any(is.na(df))
#Check to make sure categoricals are factors
str(df)

#Discrete integer variables CAN be factorized, but generally are in the right order (e.g 0 is lowest, 5 is highest)

library(ggplot2)
library(dplyr)

#Let's create a plot that examines the correlations between features
##For example, a correlation plot
#Num only

num.cols <- sapply(df, is.numeric)
# Filter numeric columns for correlation
cor.data <- cor(df[,num.cols==T])

# cor() computes correlation coefficients between object(s) x (and y, sometimes). 
#In this case, we pass a dataframe of all our numeric data. 
#cor() calculates the correlation of each column with every other column

#Now plot the coefficients
install.packages("corrgram")
library(corrgram)

install.packages("corrplot")
library(corrplot)

#Using corrplot
#Corrplot requires you to parse your own df for numeric columns and generate a cor chart
print(corrplot(cor.data, method= "color"))

#Using corrgram
#Don't need to filter for numeric columns or generate a cor chart
corrgram(df)

#Make it sexier
#lower.panel, upper.panel, text.panel are all FUNCTIONS that bring in something under, over, and inside the diagnoal panes
corrgram(df, order=TRUE, lower.panel=panel.shade,
         upper.panel=panel.pie, text.panel=panel.txt)

#We want to predict G3 so let's plot it
print(ggplot(df,aes(x=G3))+geom_histogram(bins=20, alpha=0.5, fill="blue"))

#-------------------------------------MODEL BUILDING
#Split data into training and testing
install.packages("caTools")
library(caTools)

#Set a seed
set.seed(101)
#Split up sample
sample <- sample.split(df$G3, SplitRatio=0.7)
#This creates a boolean column on df that is TRUE for train and FALSE for test 
train <- subset(df,sample==TRUE)
test <- subset(df,sample==FALSE)

#BUILD THE MODEL AND TRAIN IT
model <- lm(G3~., data=train)

#RUN THE MODEL

#Interpret the model
print(summary(model))

#Plot residuals
res <- residuals(model)

#Model plotting
plot(model)

#-------------------------PREDICTIONS
G3.predictions <- predict(model, test)

results <- cbind(G3.predictions, test$G3)
colnames(results) <- c("predicted", "actual")
results <- as.data.frame(results)

print(head(results))

#Convert negative predicted values to 0
to_zero <- function(x){
  if(x<0){
    return(0)
  } else {
    return(x)
  }
  
}
#apply this to our predicted values
results$predicted <- sapply(results$predicted, to_zero)

#Get RMSE
mse <- mean((results$actual - results$predicted)^2)
rmse <- mse^0.5

paste("MSE: ", mse, " RMSE: ", rmse)

###Get R^2 for our predictions

SSE <- sum((results$predicted - results$actual)^2)
SST <- sum((mean(df$G3) - results$actual)^2)

R2 <- 1-(SSE/SST)

paste("R^2: ", R2)
