#==============K-MEANS CLUSTERING==================#

#source data
df1 <- read.csv(file.choose(), sep=";") #red
df2 <- read.csv(file.choose(), sep=";") #white

head(df1)
head(df2)

#=========================EDA AND FEATURE ENGINEERING
#Now add a label column to both df1 and df2 indicating a label 'red' or 'white'.

df1$colour = "red"
df2$colour = "white"

#Combine df1/2 into one df called wine
wine <- merge(df1,df2, all=T)
row.names(wine) <- 1:nrow(wine)
nrow(wine)

#Factorize colour
wine$colour <- factor(wine$colour)

#Create a Histogram of residual sugar from the wine data. Color by red and white wines.

ggplot(data=wine) + geom_histogram(aes(x=residual.sugar, fill=colour), colour="black")

#Create a Histogram of citric.acid from the wine data. Color by red and white wines.

ggplot(data=wine) + geom_histogram(aes(x=citric.acid, fill=colour), colour="black")

#Create a Histogram of alcohol from the wine data. Color by red and white wines.
ggplot(data=wine) + geom_histogram(aes(x=alcohol, fill=colour), colour="black")

#Create a scatterplot of residual.sugar versus citric.acid, color by red and white wine.
ggplot(data=wine) + geom_point(aes(x=residual.sugar, y=citric.acid, colour=colour))

#Create a scatterplot of volatile.acidity versus residual.sugar, color by red and white wine.
ggplot(data=wine) + geom_point(aes(x=residual.sugar, y=volatile.acidity, colour=colour))

#ML time
clus.data <- wine
head(clus.data)

#Call the kmeans function on clus.data and assign the results to wine.cluster.
wine.cluster <- kmeans(x=clus.data[,1:12],center=2, nstart=20)

#Print out the wine.cluster Cluster Means and explore the information.
wine.cluster$centers

#Confusion matrix
table(wine$colour, wine.cluster$cluster)
