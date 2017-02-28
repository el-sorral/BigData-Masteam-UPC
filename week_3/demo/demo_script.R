### install some packages you will need to solve the activity A1

# Show library folder
.libPaths()

# If not writable, try: Tools -> Install Packages -> Create a personal library: Yes

# Or create a new writable personal library for packages
# Ex: "D:/R/win-library/3.3"
# Anf add the folder to the libraries path: 
# .libPaths(c("D:/R/win-library/3.3", .libPaths()))
# .libPaths()

# install packages from Tools -> Install Packages
# or:
install.packages("dplyr")
# Ubuntu users: sudo apt-get install libcurl4-openssl-dev
install.packages("curl")
install.packages("backports")
install.packages("sparklyr")


# Listing 9: Example showing R data types and data manipulation

rm(list = ls()) 	# clear workspace
setwd(".") 	# change current directory


### Working with VECTORS

x <- c(165, 180, 119, 172, 183, 150) 
x

# Some functions
length(x) 
mean(x)
summary(x)

# Subsets of vectors
x[3]      		# 3th elements of vector
x[c(2,4)] 	# 2nd and 4th elements of vector
x[-3]     		# all elements except 3th
x[x >= 180]	
which(x >= 180)


### Working with MATRICES

A <- matrix(1:12, ncol=4)
A

# Subsets of matrices
A[2, 3]
A[, 1]
A[c(1, 3), 2:4]


### Working with LISTS

l <- list(name="Paul", age=23, marks=c(6.7, 8.4, 7.0))
l

# Diferent syntax to identify elements 
l[[2]] 		# 2nd component of the list
l[["marks"]] 	# component named "marks" in list
l$name 	# component named "name" in list

l$name2 = "Anna"


### Working with DATAFRAMES

df1 <- data.frame(name=c("Paul", "Mike", "Rose", "George"), age=c(19, 22, 25, 19), mark=c(7, 9, 5, 7))
df1

# Same structure as a matrix
dim(df1)
ncol(df1)
nrow(df1)
names(df1)
names(df1) <- c('Name', 'Age', 'Mark')
df1$Mark	
df1[, 3]
df1[df1$Name=="Rose",]
df1[df1$Age>20,]
class(df1$Name)
class(df1$Age)

### Reading data from external files
#  Assuming file "table.txt" in current directory with this content:
#   Name	  Age	  Height	Weight
#   Rose	  25	  167	  65
#   Mary	  21	  160	  57
#   Peter	  23	  178	  83
#   Martha	23    163	  65
#   George	19    185	  90

df2 <- read.table("table.txt", header=T)
df2
class(df2)

# Sorting 
df2[order(df2$Age, df2$Height), ]

# Frequency table
table(df2$Age)

# Different ways to merge data frames
merge(df1, df2)
merge(df1, df2, all=T)
merge(df1, df2, all.x=T)
merge(df1, df2, all.y=T)

# Missing values
df3 <- merge(df1, df2, all=T)
df3
is.na(df3)
which(is.na(df3), arr.ind=T)
df3
df3[is.na(df3)] <- 0
df3

# Visualize large datasets
data(iris) 
iris
head(iris)
class(iris)
str(iris)
summary(iris)


### GRAPHS are typically created interactively:

data(mtcars)
plot(mtcars$mpg)
title("Miles/(US) gallon")
plot(mtcars$wt, mtcars$mp)
title("MPG x Weight")

# Simple Histogram
hist(mtcars$mpg)

# Simple Bar Plot
counts <- table(mtcars$gear)
barplot(counts, main="Car Distribution", xlab="Number of Gears") 

# Grouped Bar Plot
counts <- table(mtcars$vs, mtcars$gear)
barplot(counts, main="Car Distribution by Gears and VS",
        xlab="Number of Gears", col=c("darkblue","red"),
        legend = rownames(counts), beside=TRUE)

# Boxplot of MPG by Car Cylinders
boxplot(mpg~cyl,data=mtcars, main="Car Milage Data",
        xlab="Number of Cylinders", ylab="Miles Per Gallon")

