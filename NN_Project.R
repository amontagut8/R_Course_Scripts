#=====================NEURAL NETWORK PROJECT =================================#

#Get data
data =read.csv("C:\\Users\\amontagut\\Desktop\\R\\DataScience_and_ML\\R-Course-HTML-Notes\\R-for-Data-Science-and-Machine-Learning\\Training Exercises\\Machine Learning Projects\\CSV files for ML Projects\\bank_note_data.csv")

head(data)
str(data)

#Data prep

#EDA
#Check for missing values
any(is.na(data))

#Train test split
library(caTools)

sample <- sample.split(data$Class, SplitRatio=0.7)
training <- subset(data, sample==T)
testing <- subset(data, sample==F)

#Building the Neural Net
library(neuralnet)

?neuralnet()

#Use the neuralnet function to train a neural net, set linear.output=FALSe and choose 10 hidden neurons (hidden=10)
nn <- neuralnet(Class ~ Image.Var + Image.Skew + Image.Curt + Entropy, data=training, hidden=10, linear.output=FALSE)

#Use compute() to grab predictions useing your nn model on the test set. 
#Reference the lecture on how to do this.

predicted.values <- compute(nn, testing[1:4])

str(predicted.values)

head(predicted.values)

#Apply the round function to the predicted values so you only 0s and 1s as your predicted classes.
fitted.predictions <- round(predicted.values$net.result)

#Use table() to create a confusion matrix of your predictions versus the real values
confusion_matrix_nn <- table(testing$Class, fitted.predictions)

#Compare it to random forest
#Call the randomForest library
library(randomForest)

#Run the Code below to set the Class column of the data as a factor 
#(randomForest needs it to be a factor, not an int like neural nets did. Then re-do the train/test split

data$Class <- factor(data$Class)

#train/test split again
sample <- sample.split(data$Class, SplitRatio=0.7)
training.rf <- subset(data, sample==T)
testing.rf <- subset(data, sample==F)

#Create a randomForest model with the new adjusted training data.
rand_forest <- randomForest(Class~., data=training.rf, importance=TRUE)

#Use predict() to get the predicted values from your rf model.
RF_predictions <- predict(rand_forest, newdata=testing.rf)

head(RF_predictions)

#Use table() to create the confusion matrix.
confusion_matrix_rf <- table(RF_predictions, testing.rf$Class)

#Calculate mean-squared error for nn
MSE_nn <- (sum(testing$Class - fitted.predictions)^2)/nrow(testing)

