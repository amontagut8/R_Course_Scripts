#==========SECTION 30: K-MEANS CLUSTERING============#
library(ISLR)
library(ggplot2)
#We can't let k-means see our y. It doesn't take in labels, since it's unsupervised. 

head(iris)

ggplot(data=iris)+geom_point(aes(x=Petal.Length, y=Petal.Width, colour=Species),size=2)

set.seed(101)
irisCluster <- kmeans(iris[,1:4],centers=3,nstart=20)
irisCluster

#check it
table(irisCluster$cluster, iris$Species)

#cluster visualization
library(cluster)
clusplot(iris, irisCluster$cluster,color=T, shade=T, labels= 0, lines = 0)
?clusplot()
?kmeans()
