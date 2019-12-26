#=============SECTION 33: NEURAL NETS=================#

#Use MASS
install.packages("MASS")
install.packages("seriation")
library(MASS)

head(Boston)

#Goal of this exercise is to predict the medv value - so it's a REGRESSION exercise
str(Boston)

#Check for missing data
any(is.na(Boston))

data <- Boston

#Need to preprocess data and reinstal a neural net library


#=======================================================DATA PREPROCESSING
######################Good practice is to normalize data


maxs <- apply(data,2, max) #2 specifies the columns of data
maxs

mins <- apply(data,2, min)
mins


#Normalize using these values
data.scaled <- scale(data, center=mins, scale=maxs-mins)

#Scale() returns a matrix
data.scaled <- data.frame(data.scaled)

head(data.scaled)

#Train Test Split
library(caTools)

split <- sample.split(data.scaled$medv, SplitRatio=0.7)
training <- subset(data.scaled, split==T)
testing <- subset(data.scaled, split==F)

head(training)


#Install the package
install.packages("neuralnet")
library(neuralnet)

n <- names(data.scaled) #
f <- as.formula(paste("medv~", paste(n[n != "medv"], collapse = " +")))

#Create the NN
nn <- neuralnet(f, data=training, hidden=c(5,3), linear.output=T)

plot(nn)

#Prediction
predicted.nn.values <- compute(nn, testing[1:13])

str(predicted.nn.values)

#Undo the apply() function we used to normalize data earlier
true.predictions <- predicted.nn.values$net.result * (max(data$medv) - min(data$medv)) + min(data$medv)

unscaled.test <- testing$medv * (max(data$medv) - min(data$medv)) + min(data$medv)

MSE.nn <- ((sum(unscaled.test - true.predictions))^2)/nrow(testing)

error.df <- data.frame(unscaled.test, true.predictions)
head(error.df)

#Visualize

ggplot(data=error.df, aes(x=unscaled.test, y=true.predictions)) + geom_point() + stat_smooth()

library(ggplot2)
