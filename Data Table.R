install.packages("data.table") 

#load required library
library(data.table)

mydata = read.csv("C:/Users/ABHIC6/Documents/flights_2014.csv")

View(mydata)

nrow(mydata)   #No of Rows

ncol(mydata)   #No of Columns

names(mydata)  #Return Columnnames


