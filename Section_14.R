#===SECTION 14===#
install.packages('dplyr')
install.packages('nycflights13') #Dataset

library(dplyr)
library(nycflights13)
  
head(flights)
summary(flights)
str(flights)

#---------dplyr functions
#---filter() and slice()
head(filter(flights, month==11, day==3, carrier=="AA"))
#This is used because it's much more simple than using bracket notation

#slice()
slice(flights, 1:10)

#arrange()
head(arrange(flights, year, month, day, arr_time))

#select()
head(select(flights,carrier,arr_time))

#rename()
head(rename(flights, airline_carrier = carrier))

#distinct()
distinct(select(flights, carrier))

#mutate() and transmute()

#summarise() - similar to GROUP BY
summarise(flights, avg_air_time=mean(air_time, na.rm=T))
summarise(flights, count_flight=count(airline_carrier))

#---------Pipe Operator
df <- mtcars

#Nesting
result <- arrange(sample_n(filter(df,mpg>20), size=5),desc(mpg))
result
#This is very hard to read

#Rewrite using multiple assignments

a<- filter(df, mpg > 20)
b<- sample_n(a,size=5)
results <- arrange(b,desc(mpg))

#Rewrite using pipe operator
#Data %>% op1 %>% op2 %>% op3
result <- df %>% filter(mpg>20) %>% sample_n(size=5) %>% arrange(desc(mpg))
result

#----------------tidr
install.packages('tidyr')
install.packages('data.table')

library(tidyr)
library(data.table)

comp <- c(1,1,1,2,2,2,3,3,3)
yr <- c(1998,1999,2000,1998,1999,2000,1998,1999,2000)
q1 <- runif(9, min=0, max=100)
q2 <- runif(9, min=0, max=100)
q3 <- runif(9, min=0, max=100)
q4 <- runif(9, min=0, max=100)

df <- data.frame(comp=comp,year=yr,Qtr1 = q1,Qtr2 = q2,Qtr3 = q3,Qtr4 = q4)

#########tidyr functions
#gather() - similar to pivoting. Collapses multiple columns into one aggregate
gather(df, Quarter, Revenue, Qtr1:Qtr4)

stocks <- data.frame(
  time = as.Date('2009-01-01') + 0:9,
  X = rnorm(10, 0, 1),
  Y = rnorm(10, 0, 2),
  Z = rnorm(10, 0, 4)
)
stocks

stocks.gathered <- stocks %>% gather(stock,price,X:Z)
head(stocks.gathered)
#spread()

#separate() - turns a single character column into multiple columns
df <- data.frame(new.col=c(NA, "a-x", "b-y", "c-z"))
df_sep <- separate(df, new.col, into = c("abc", "xyz"), sep="-")
#by default, separate() tries to separate by non-alphanumeric characters

#unite() - undoes a separate()
unite(df_sep, col=new.joined.col,abc,xyz, sep="---")
