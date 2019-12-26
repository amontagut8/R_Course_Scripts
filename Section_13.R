#===SECTION 13===#
#Functions of interest here:
#seq() : creates a sequence

seq(0,10,by=10)

#sort(): sorts a vector

a <- c(runif(20))
a_sort <- sort(a)

a
a_sort
#If we have a vector of characters, sort() sorts in alphabetical order


#rev(): reverses the elements in an object

a <- c(1:10)
a_r <- rev(a)

a
a_r


#str(): shows the structure of an object
#append(): Merges objects (vectors or lists) together

append(a, a_r)

#checking and converting between data types
is.vector(a)
is.data.frame(a)
#is.TYPE checks data type

##as. converts one data type to another

##Anonymous functions

v <- 1:5
sapply(v, function(num){num*2})

#-------------------MATH FUNCTIONS
##abs() - absolute value
##sum() - returns the sum of all elements of a vector
##mean()
##round() - argument is number of decimal values
#Look for r reference card

#-------------------REGULAR EXPRESSIONS
#grepl(pattern, target)
#grep(pattern, target)

#-------------------DATES AND TIMESTAMPS

#Use the following functions:
strptime()
as.Date()
as.POSIXct()



