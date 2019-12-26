#===SECTION 12===#

#Skipping to exercises to see if this is too easy
#Ex 1: Write a script that will print "Even Number" if the variable 
#x is an even number, otherwise print "Not Even":

test <- 3

if (test%%2 == 0){
  print("Even number")
}  else {
  print("Not even")
}

#Ex 2: Write a script that will print 'Is a Matrix' if the variable x is a matrix, otherwise print "Not a Matrix".
input <- list(1:10)  

if (is.matrix(input)==T){
  print("Is a matrix")
} else{
  print("Not a matrix")
}

#Create a script that given a numeric vector x with a length 3, 
#will print out the elements in order from high to low. 
#You must use if,else if, and else statements for your logic. 

x <- c(210, 4, 0.5)
output<-c(0,0,0)
for(i in 1:3){
  if(x[i] == max(x)) {
    output[3] = x[i]
    } else if (x[i] ==min(x)){
      output[1] = x[i]
      } else {
        output[2] = x[i]
      }
}

#Ex 4: Write a script that uses if,else if, and else statements to print 
#the max element in a numeric vector with 3 elements.

input_vector <- c(0.5, 4, 210)
for (i in length(input_vector)){
  if (input_vector[i]==max(input_vector)) {
    print(input_vector[i])
  } else {
    i <- i+1
  }
}

#Example of a while loop
while (x<10){
  print(x)
  x<- x+1
  
  if (x==10){
    print("X is now 10. Loop broken")
    break #Break keyword ends a loop
  }

}













