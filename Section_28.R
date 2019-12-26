#====SECTION 28: SVMs===#
#Use iris
library(ISLR)
head(iris)

install.packages("e1071")
library(e1071)

?svm()

#svm() lets you specify the type of kernel, and various coefficients for
#the hyperplane, including degree (for polynomial), gamma, and coefficients
#default is radial-basis

model <- svm(Species~., data=iris)
summary(model)


pred.value <- predict(model, data=iris[1:4])
table(pred.value, iris$Species)

#Tuning our SVM
tune.results <- tune(svm, train.x=iris[1:4], train.y=iris[,5],kernel='radial',ranges=list(cost=10^(-1:2), gamma=c(0.5,1,2)))


summary(tune.results)

tuned.svm <- svm(Species~., data=iris, kernel="radial", cost=1.5, gamma=0.1)
summary(tuned.svm)
