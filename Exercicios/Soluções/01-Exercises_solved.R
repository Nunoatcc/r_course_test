###############################################
#                                             #
# PART 01                                     #
# Introduction to R for Health Data Science   #
# Exercises                                   #
#                                             #
###############################################

#Check R version
sessionInfo()

#Install a package
install.packages("tidyverse")

#Load a package
library(tidyverse)

#See what the working directory is
getwd()

#Change the working directory
#IMPORTANT: R uses forward slashes '/' for folder paths, instead of '\'
setwd("Your_path_goes_here")

#Explore the sum() function with F1 or ?sum
?sum

#Create a few strings
"abc"
c("a","b","c")

#Create a few numbers
1
c(1,2,5) #vector of numbers 1, 2 and 5
1:3 #vector of numbers one to three
seq(1,10,2) #sequence of number from onte to ten, increasing by two
1.5
c(1,2.5)

#Create a few logical values
T
TRUE
c(TRUE, FALSE)

#Find out the data type of different values with typeof()
typeof("abc")
typeof(1)
typeof(c(TRUE,FALSE))

#Do some operation with different data types that returns an error
1 + "A"

#Coerce the following vector to logical and see what happens
charvec <- c("FALSE", "F", "False", "false",    "fAlse", "0",
             "TRUE",  "T", "True",  "true",     "tRue",  "1")

as.logical(charvec)

#Create a list with list()
list("A",1:3,c(TRUE, FALSE), list(1:3))

#Create a data frame with data.frame()
data.frame(col1 = c(1,2,3),
           cols = c("A","B","C"))

#Create some vectors

##Manually
c("a","b","c")
c(1,2,3)
c(TRUE, FALSE)

##From a sequence
1:10

##From random sampling a normal distribution
rnorm(10)

#Create a number vector, with one of the elements being a character
my_vec <- c(1990, 1991, "1992a")

##What happens when we see the data type with typeof()?
typeof(my_vec)

##What happens when we coerce the vector to number?
as.integer(my_vec)

#Create a named vector
my_named_vec = c(name1 = "value1", name2 = "value2")

#Create a vector without names, and give each value a different name with names()
some_vec <- c("value1", "value2")
names(some_vec) <- c("name1","name2")

#Create a long vector
long_vec <- seq(0.01,1, 0.01)

##Explore the vector with head and tail
head(long_vec)

##Subset the vector by index
long_vec[5]

##Subset the vector by a subsetting vector with multiple indices
long_vec[c(5,11)]

##Subset the vector by a sequence
long_vec[5:15]

##Subset the vector by excluding one index
long_vec[-10]

##Subset the vector by excluding a sequence of indices
long_vec[-(1:10)]

#Create a named vector. It can be the one created above

##Subset the vector by the name of a value
my_named_vec["name1"]

#With the following vector
yet_another_vector <- c(9,5,8,1,NA,7,1,NA,3,3)
yet_another_vector

##Subset the vector to keep only the NA values
yet_another_vector[is.na(yet_another_vector)]

##Subset the vector to exclude all NA values
yet_another_vector[!is.na(yet_another_vector)]

##Subset the vector to show only values smaller than or equal to five
yet_another_vector[yet_another_vector<=5]

##Subset the vector to show only values that are equal to one
yet_another_vector[yet_another_vector==1]

##Change the value of the fourth index to 7
yet_another_vector[4] <- 7

##Change the value of index 101 to 2. What happened?
yet_another_vector[101] <- 2

#Create a list where the first element is a numeric vector, the second is a single character, and the third is a list
#where the first element of that nested list is the value TRUE, and the second is the vector 4:6
ll <- list(1:3,"A",list(TRUE,4:6))

##Access the first element of the list with []
ll[1]

##Access the first element of the list with [[]]. What's the difference?
ll[[1]]

#Check out the named list below with glimpse
julius_caesar <- list(id_numbers = list(id = 123456789,
                                        health_insurance = NA),
                      name = "Julius Caesar",
                      addresses = list(child_home = "Slums of Subura",
                                       roman_homes = c("Roman Palace 1", "Roman Palace 2"),
                                       epigtian_homes = "Cleopatra's Palace"),
                      website = "www.venividivici.com")

#Get the names of all the Roman Homes using the $ syntax
julius_caesar$addresses$roman_homes

#Statistical models output lists in R. Check out the output below
#HINT: use the object explorer to visually explore the output
some_model_output <- lm(lifeExp ~ gdpPercap, data = gapminder::gapminder)

#Select the coefficient associated with gdpPercap
some_model_output$coefficients["gdpPercap"]

#Check out the following data.frame
amazing_tibble <- data.frame(col1 = c(1:26),
                             col2 = letters,
                             col3 = rnorm(26))

##Get the value from the row 17, column 2
amazing_tibble[17, 2]

##get all the cols from row 5
amazing_tibble[5,]

##get all the rows from col3 using [], and using amazing_tibble["col3"]
amazing_tibble[,3]

##NOTE: we will have different values due to random sampling


#Check out the gapminder dataset with glimpse()
library(gapminder)
gapminder

## select the top 20% rows with slice_head
gapminder %>% slice_head(prop = .2)

## select the bottom 5 rows with slice_tail
gapminder %>% slice_tail(n = 5)

## Select a 10% sample with slice_sample, weighted in such a way that smaller countries are most likely to be selected
gapminder %>% slice_sample(prop = .1)
