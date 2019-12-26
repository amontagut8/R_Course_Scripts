#===========RANDOM FOREST PROJECT=============#
library(ISLR)
library(ggplot2)

install.packages("ggplot2")

head(College)

df <- College

#===============================================EDA
#=====================================
#============================
#===========================
#Create a scatterplot of Grad.Rate versus Room.Board, colored by the Private column.

ggplot(data=df)+geom_point(aes(x=Room.Board, y=Grad.Rate, colour=Private))

#Create a histogram of full time undergrad students, color by Private.
ggplot(data=df)+geom_histogram(aes(x=F.Undergrad, fill=Private), colour="black")

#Create a histogram of Grad.Rate colored by Private. You should see something odd here.
ggplot(data=df)+geom_histogram(aes(x=Grad.Rate, fill=Private), colour="black")

#What college had a Graduation Rate of above 100% ?
df[df$Grad.Rate > 100,"Grad.Rate"] <- 100

#Split your data into training and testing sets 70/30. Use the caTools library to do this.
library(caTools)

sample <- sample.split(df$Grad.Rate, SplitRatio=0.70)
training <- subset(df, sample==T)
testing <- subset(df, sample==F)

#Use the rpart library to build a decision tree to predict whether or not a school is Private. 
#Remember to only build your tree off the training data.

private_tree <- rpart(Private ~., method='class', data=training)

#Use predict() to predict the Private label on the test data.

private_predict <- predict(private_tree, newdata=testing)

#Check the Head of the predicted values. 
#You should notice that you actually have two columns with the probabilities.
head(private_predict)




#Turn these two columns into one column to match the original Yes/No Label for a Private column.
df_predictions <- data.frame(private_predict)

df_predictions$Fitted_Result <- ifelse(df_predictions$Yes>df_predictions$No, "Yes", "No")

#Now use table() to create a confusion matrix of your tree model.
table(df_predictions$Fitted_Result, testing$Private)

#Use the rpart.plot library and the prp() function to plot out your tree model.
rpart.plot(private_tree)
prp(private_tree)


#Random Forest
library(randomForest)

#Use randomForest() to build a private predictor
rf.private <- randomForest(Private~., data=training, importance=TRUE)

#Confusion Matrix
rf.private$confusion

#Feature importance
rf.private$importance

#Now predict on the test set

rf_private_predict <- predict(rf.private, newdata=testing)


#Now let's see a confusion matrix
table(rf_private_predict, testing$Private)
