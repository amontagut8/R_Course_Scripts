#===SECTION 24: KNN===#

#Get the data
install.packages("ISLR")

library(ISLR)
Caravan
str(Caravan)
#The factor of interest is "Purchase": 0,1
#Customer data stored as binaries

summary(Caravan$Purchase)

#Any NA's?
any(is.na(Caravan))

#STANDARDIZE THE X VARIABLES - variable scale is super important
var(Caravan[,1])
var(Caravan[,2])

purchase <- Caravan[,86]

#scale()
standardized.Caravan <- scale(Caravan[,1:85])
print(var(standardized.Caravan[,1]))
print(var(standardized.Caravan[,2]))

#Train-test split
test.index <- 1:1000
test.data <- standardized.Caravan[test.index,]
test.purchase <- purchase[test.index] #Test ground truth

#Train
train.data <- standardized.Caravan[-test.index,]
train.purchase <- purchase[-test.index] #Train ground truth

#====================================KNN MODEL
library(class)
set.seed(101)

predicted.purchase <- knn(train.data,test.data,train.purchase,k=5)
print(head(predicted.purchase))

misclass.error <- mean(test.purchase != predicted.purchase)

print(misclass.error)

#Choosing a k-value
#######"The elbow method"

predicted.purchase <- NULL
error.rate <- NULL

for (i in 1:20){
  set.seed(101)
  predicted.purchase <- knn(train.data, test.data, train.purchase, k=i)
  error.rate[i] <- mean(test.purchase != predicted.purchase)
}

print(error.rate)

#Visualize K elbow method

library(ggplot2)
k.values <- 1:20
error.df <- data.frame(error.rate, k.values)
error.df

ggplot(data=error.df, aes(x=k.values, y=error.rate)) + geom_point() + geom_line(lty="dotted", colour="red")












