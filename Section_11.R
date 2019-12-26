#===SECTION 11===#

#Reading CSVs
write.csv(mtcars, file="example_csv.csv")

x <- read.csv("example_csv.csv")

#Reading Excel files
#To do this we need an external package readxl
install.packages("readxl")

library(readxl)
excel_sheets() #returns sheets
read_excel() #reads a file and the sheet to be read

#to create a list of sheets (as dataframes), we use lapply()
#Arguments are all the sheets in the workbook, function is read_excel, and the function's argument is the path to the workbook
entire.workbook <- lapply(excel_sheets("Sample workbook in local directory", read_excel, path="Sample-Workbook"))

#xlsx package is needed to WRITE xls files
install.packages("xlsx")
install.packages("rJava")
library(xlsx)

write.xlsx() #Same args as write.csv()

#SQL
#How to connect R to a SQL database
#Install library. Installing MySQL because that's what I know

install.packages("RMySQL")
library(RMySQL)

con <- dbConnect(MySQL(),
                 user= 'root',
                 password = 'password',
                 host= 'localhost',
                 dbname = 'world') #Example

dbListTables(con)

#Web scraping
#Skipping for now










