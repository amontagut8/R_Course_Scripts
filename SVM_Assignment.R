#=======SVM PROJECT========#

#Read data

loans <- read.csv(file.choose())

#=====================================EDA
head(loans)
#credit.policy -> did customer get the loan? 1=yes, 0=no
str(loans)
summary(loans)

loans$credit.policy <- factor(loans$credit.policy)

#Convert inq.last.6mths, delinq.2yrs, pub.rec, not.full.paid to factors

loans$inq.last.6mths <- factor(loans$inq.last.6mths)
loans$delinq.2yrs <- factor(loans$delinq.2yrs)
loans$pub.rec <- factor(loans$pub.rec)
loans$not.fully.paid <- factor(loans$not.fully.paid)

#Create a histogram of fico scores colored by not.fully.paid

ggplot(data=loans) + geom_histogram(aes(x=fico, fill=not.fully.paid), colour="black")

#Create a barplot of purpose counts, colored by not.fully.paid. Use position=dodge in the geom_bar argument
ggplot(data=loans) + geom_bar(aes(x=factor(purpose), fill=not.fully.paid), position="dodge")

#Create a scatterplot of fico score versus int.rate. Does the trend make sense? Play around with the color scheme if you want.

ggplot(data=loans) + geom_point(aes(x=fico, y=int.rate, colour=not.fully.paid, alpha=log.annual.inc))

#================================BUILDING THE MODEL
#Train/test split

library(caTools)

sample <- sample.split(loans, SplitRatio=0.7)
train <- subset(loans, sample ==T)
test <- subset(loans, sample==F)

#Call the e1071 library as shown in the lecture.
library(e1071)

#Now use the svm() function to train a model on your training set.
svm.model <- svm(not.fully.paid~., data=train, cost=0.5, gamma=2)

#Summary
summary(svm.model)

#Use predict to predict new values from the test set using your model. Refer to the lecture on how to do this if you don't remember :)
svm_predictions <- predict(svm.model, newdata=test)

#Confusion matrix time
table(svm_predictions, test$not.fully.paid)

#Model tuning time
tune.results <- tune(svm, train.x=not.fully.paid~., data=train, kernel="radial",
                     ranges=list(cost=c(0.5,1,1.5)),
                                 gamma=c(1,2)) #This takes a very very very long time


