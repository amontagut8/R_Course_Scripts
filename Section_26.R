#===SECTION 26: TREES===#

install.packages('rpart')
library(rpart)
#Source data
#function of use is rpart()

str(kyphosis)
head(kyphosis)

tree <- rpart(Kyphosis ~., method='class', data=kyphosis)

#Functions that allow you to examine the tree model:
# printcp() - display cp table
# plotcp() - plot cross-validation results
# rsq.rpart() - plot approximate R-squared and relative error for splits
# print() - results
# summary() - detailed results
# plot() - plot the decision tree
# text() - label
# post(x, file=y) - create postscript plot of decision tree

printcp(tree)
plot(tree, uniform=T, main="tree")


install.packages("rpart.plot")
library(rpart.plot)
prp(tree)



#=====================RANDOM FORESTS
install.packages("randomForest")
library(randomForest)

rf.model <- randomForest(Kyphosis ~., data=kyphosis)
print(rf.model)

rf.model$confusion
