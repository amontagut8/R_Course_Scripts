#===KNN ASSIGNMENT===#

#Use dataset "iris" from ISLR library

library(ISLR)
head(iris)
str(iris)

#Standardize data

iris_standardized <- scale(iris[1:4])

#Check to see if the standardization worked
var(iris_standardized[,1]) 



#Join the standardized data with the response/target/label column
new_iris <- data.frame(iris_standardized, iris$Species)

#Train-test split using catools
library(caTools)
set.seed(101)

sample <- sample.split(new_iris$iris.Species, SplitRatio=0.70)

train <- subset(new_iris, sample==T)
test <- subset(new_iris, sample==F)

#KNN time
library(class)

#Use the knn function to predict Species of the test set. Use k=1
knn.output <- knn(train[1:4],test[1:4],train$iris.Species,k=1)

#What was your misclassification rate?
misclassification_rate <- mean(knn.output != test$iris.Species)
print(misclassification_rate)

#Create a plot of k-values from 1:10

k.value <- 1:10
error.rates <- NULL

for (i in 1:10){
  set.seed(101)
  knn.output <- knn(train[1:4],test[1:4],train$iris.Species,k=i)
  error.rates[i] <- mean(knn.output != test$iris.Species)
}

print(error.rates)

elbow_plot <- cbind("k-value"=k.value, "error"=error.rates)

elbow_plot <- data.frame(elbow_plot)

ggplot(data=elbow_plot, aes(x=k.value, y=error)) + geom_line()

