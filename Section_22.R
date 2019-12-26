#===SECTION 22===#

#Logistic Regression
#Load the data
df.train <- read.csv("C:\\Users\\amontagut\\Desktop\\R\\DataScience_and_ML\\R-Course-HTML-Notes\\R-for-Data-Science-and-Machine-Learning\\Machine Learning with R\\titanic_train.csv")
df.test <- read.csv("C:\\Users\\amontagut\\Desktop\\R\\DataScience_and_ML\\R-Course-HTML-Notes\\R-for-Data-Science-and-Machine-Learning\\Machine Learning with R\\titanic_test.csv")

#========================EDA
head(df.train)
str(df.train)

#How much missing data do we have?
install.packages("Amelia")
library(Amelia)

#use missing maps
?missmap()

missmap(df.train, main= "Missing Map", col=c("red","blue"))

ggplot(data=df.train,aes(x=Sex))+geom_bar(aes(fill=factor(Sex)))

ggplot(data=df.train, aes(Age)) + geom_histogram(bins=20, alpha=0.5, fill="blue")

ggplot(data=df.train, aes(Parch))+geom_bar()

ggplot(data=df.train, aes(Fare))+geom_histogram(fill="blue", colour="black", alpha=0.5)

#We need to do some data cleaning
####Impute with mean age by passenger class

ggplot(df.train, aes(x=Pclass, y=Age)) + 
       geom_boxplot(aes(group=Pclass,fill=factor(Pclass)),alpha=0.4) 
     
#Impute age based on mean age of Pclass 
####Pclass1 
df.train[is.na(df.train$Age)==T & df.train$Pclass==1,"Age"] <- mean(df.train[df.train$Pclass==1,]$Age, na.rm=T)

####Pclass 2
df.train[is.na(df.train$Age)==T & df.train$Pclass==2,"Age"] <- mean(df.train[df.train$Pclass==2,]$Age, na.rm=T)

####Pclass 3
df.train[is.na(df.train$Age)==T & df.train$Pclass==3,"Age"] <- mean(df.train[df.train$Pclass==3,]$Age, na.rm=T)

#Check for missing data
missmap(df.train, main="Imputation Check", col = c("white", "black"))

#===============================PART 2
str(df.train) #Lots of fields we don't care about, since we want to predict survivor or not

library(ggplot2)
library(dplyr)
library(corrgram)
library(corrplot)
library(caTools)

df.train <- select(df.train, -PassengerId, -Name, -Ticket, -Cabin)
#survived and Pclass should be factors

df.train$Survived <- factor(df.train$Survived)
df.train$Pclass <-factor(df.train$Pclass)
df.train$SibSp <- factor(df.train$SibSp)
df.train$Parch <- factor(df.train$Parch)

#Create and run model
log.model <- glm(Survived ~. , family=binomial(link = 'logit'), data= df.train)
summary(log.model)

#Split up our training set
library(caTools)
set.seed(101)

split = sample.split(df.train$Survived, SplitRatio = 0.70)

final.train = subset(df.train, split == TRUE)
final.test = subset(df.train, split == FALSE)

#Rerun the model using our split training set
final.log.model <- glm(formula=Survived ~ . , family = binomial(link='logit'),data = final.train)

summary(final.log.model)

#Predict

fitted.probabilities <- predict(final.log.model,newdata=final.test,type='response')

fitted.results <- ifelse(fitted.probabilities > 0.5,1,0)
#Bin the probabilities based on being bigger than 0.5

misClasificError <- mean(fitted.results != final.test$Survived)
print(paste('Accuracy',1-misClasificError)) #accuracy

#Create confusion matrix
table(final.test$Survived, fitted.probabilities > 0.5)

#Clean titanic.test and predict off of it afterwards

#Test data wrangling
missmap(df.test)

#Impute age (we don't care about the missing fare)
df.test[is.na(df.test$Age)==T & df.test$Pclass==1,"Age"] <- mean(df.test[df.test$Pclass==1,]$Age, na.rm=T)

####Pclass 2
df.test[is.na(df.test$Age)==T & df.test$Pclass==2,"Age"] <- mean(df.test[df.test$Pclass==2,]$Age, na.rm=T)

####Pclass 3
df.test[is.na(df.test$Age)==T & df.test$Pclass==3,"Age"] <- mean(df.test[df.test$Pclass==3,]$Age, na.rm=T)

#Drop the columns we don't care about in our test set

df.test <- select(df.test, -PassengerId, -Name, -Ticket, -Cabin)

#Factorize the columns of interest
df.test$Pclass <-factor(df.test$Pclass)
df.test$SibSp <- factor(df.test$SibSp)
df.test$Parch <- factor(df.test$Parch)

#Predict
survivor_predict <- predict(log.model, data=df.test, type="response")
fitted_test_predicts <- ifelse(survivor_predict>0.5, 1, 0)

#Measure our misclassification rate
###Test set doesn't have y? 












