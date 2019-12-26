#===SECTION 14 EXERCISES===#
library(dplyr)

df<- mtcars
head(mtcars, n=5)

#Return rows of cars that have an mpg value greater than 20 and 6 cylinders.
filter(df, mpg>20, cyl==6)

#Reorder the Data Frame by cyl first, then by descending wt.
head(arrange(df, cyl, desc(wt)))

#Select the columns mpg and hp
head(select(df, mpg, hp))

#Select the distinct values of the gear column.
distinct(select(df, gear))

#Create a new column called "Performance" which is calculated by hp divided by wt.
head(mutate(df, performance=hp/wt))

#Find the mean mpg value using dplyr.
summarise(df, mean_mpg=mean(mpg))

#Use pipe operators to get the mean hp value for cars with 6 cylinders.

mean_hp_value <- df %>% filter(cyl==6) %>% summarize(mean_hp = mean(hp))
mean_hp_value








