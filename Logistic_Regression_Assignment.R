#===LOGISTIC REGRESSION PROJECT===#
#Libraries
install.packages("ggplot2")

library(ggplot2)
library(dplyr)
library(corrgram)
library(corrplot)
library(caTools)
library(Amelia)

#We will be working with the UCI adult dataset
###Predict whether someone makes >50k (1) or <50k (0) per year. 

#Get the data
adult <- read.csv("C:\\Users\\amontagut\\Desktop\\R\\DataScience_and_ML\\R-Course-HTML-Notes\\R-for-Data-Science-and-Machine-Learning\\Training Exercises\\Machine Learning Projects\\CSV files for ML Projects\\adult_sal.csv")

#==========================EDA
head(adult)
str(adult)
levels(adult$relationship)
levels(adult$type_employer)
summary(adult)

#Column X can go. We should also bin income into 0s and 1s
adult$X <- NULL

adult$income <- ifelse(adult$income == "<=50K",0,1)
adult$income <- factor(adult$income)

#Look where our missing values are:
missmap(adult) #Everything looks gucci.

#========================Assignment EDA
####type_employer
table(adult$type_employer)
#There are no NULL values, but there are 1836 rows with "?" as an employer type.
#Two-smallest groups are never-worked and without-pay

#Combine these two smallest groups into a single group called "Unemployed"
#Hint: convert this column to characters and then use sapply with a custom function
adult$type_employer <- as.character(adult$type_employer)

convert_to_unemployed <- function(x)  {
  if (x=="Never-worked" | x=="Without-pay"){
    x = "Unemployed"
  }
  return(x)
}

adult$type_employer <- sapply(adult$type_employer, convert_to_unemployed)

#return to factors
adult$type_employer <- factor(adult$type_employer)
table(adult$type_employer)

#Combine State and Local gov jobs into a category called SL-gov 
#combine self-employed jobs into a category called self-emp.

##first de-factorize type_employer
adult$type_employer <- as.character(adult$type_employer)

#Now define our function
convertor_2 <- function(x)  {
  if (x=="State-gov" | x=="Local-gov"){
    x = "SL-gov"
  } else if (x=="Self-emp-inc" | x=="Self-emp-not-inc"){
    x = "self-emp"
  }
  return(x)
}

#Apply that shit
adult$type_employer <- sapply(adult$type_employer, convertor_2)
adult$type_employer <- factor(adult$type_employer)

table(adult$type_employer)

#MARITAL COLUMN
#Reduce this to three groups - married, not married, never married

adult$marital <- as.character(adult$marital)

marital_convertor <- function(x)  {
  if (x=="Married-AF-spouse" | x=="Married-civ-spouse" | x=="Married-spouse-absent"){
    x = "married"
  } else if (x=="Widowed" | x=="Divorced" | x=="Separated"){
    x = "not married"
  }
  return(x)
}

adult$marital <- sapply(adult$marital, marital_convertor)
adult$marital <- factor(adult$marital)

#Country
Asia_ME <- c("Cambodia", "China", "Hong", "Laos","Taiwan", "Thailand", "Vietnam", "Japan", "India", "Iran", "Philippines")

North_America <- c("Canada", "Mexico", "Outlying-US(Guam-USVI-etc)", "United-States")

Carribean <- c("Cuba", "Haiti","Dominican-Republic", "Jamaica", "Puerto-Rico", "Trinadad&Tobago")

South_Central_America <- c("El-Salvador", "Columbia", "Honduras", "Guatemala", "Nicaragua", "Peru")

Europe <- c("England", "Germany", "Greece", "Holand-Netherlands", "Hungary", "Ireland", "Italy", "Poland", "Portugal", "Scotland", "Yugoslavia")

Other <- c("South", "?")

continent_convertor <- function(x) {
  if (x %in% Asia_ME){
    x= "Asia/MidEast"
    } else if (x %in% Carribean){
    x="Carribean"  
    } else if (x %in% Europe){
    x="Europe"  
    } else if (x %in% North_America) {
    x="North America"
    } else if (x %in% South_Central_America){
    x="South/Central America"  
    } else {
    x="Other"  
    }
  
}

adult$country <- as.character(adult$country)
adult$country <- sapply(adult$country, continent_convertor)
adult$country <- factor(adult$country)

#Missing data
missmap(adult)

#Convert any cell with a '?' or a ' ?' value to a NA value. 
#Type_employer and occupation are the only columns with ? values


adult[adult$type_employer =="?","type_employer"] <- NA
adult[adult$occupation =="?","occupation"] <- NA

#Play around with the missmap function from the Amelia package. Can you figure out what its doing and how to use it?
missmap(adult)

#Use na.omit() to omit NA data from the adult data frame. 
adult <- na.omit(adult)

#Although we've cleaned the data, we still have explored it using visualization.
str(adult)

#Use ggplot2 to create a histogram of ages, colored by income.
ggplot(data=adult) + geom_histogram(aes(x=age, fill=income), colour="black", binwidth=1)

#Plot a histogram of hours worked per week
ggplot(data=adult) + geom_histogram(aes(x=hr_per_week))

#Rename the country column to region column to better reflect the factor levels.
names(adult)[names(adult)=="country"] <- "region"

#Create a barplot of region with the fill color defined by income class. Optional: Figure out how rotate the x axis text for readability
ggplot(data=adult) + geom_bar(aes(x=region, fill=income), colour="black")

#==================================MODEL TIME

head(adult)

#Train/Test Split
split <- sample.split(adult, SplitRatio=0.7)
train <- subset(adult, split==TRUE)
test <- subset(adult, split==FALSE)

#Train the model
logistic_model <- glm(income~., family=binomial(link=logit), data=train)

#Model summary
summary(logistic_model)

#step() uses AIC to try and remove non-informative features
new_log_model <- step(logistic_model)
summary(new_log_model)

#Create a confusion matrix using predict()

results <- predict(logistic_model, newdata=test, type="response")

table(test$income, results> 0.5)



