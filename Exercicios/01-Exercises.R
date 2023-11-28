###############################################
#                                             #
# PART 01                                     #
# Introduction to R for Health Data Science   #
# Exercises                                   #
#                                             #
###############################################

#Check R version

#Install a package

#Install multiple packages

#Load a package

#See what the working directory is

#Change the working directory
#IMPORTANT: R uses forward slashes '/' for folder paths, instead of '\'

#Explore the sum() function with F1 or ?sum

#Create a few strings

#Create a few numbers

#Create a few logical values

#Find out the data type of different values with typeof()

#Do some operation with different data types that returns an error

#Coerce the following vector to logical and see what happens
charvec <- c("FALSE", "F", "False", "false",    "fAlse", "0",
             "TRUE",  "T", "True",  "true",     "tRue",  "1")

#Create a list with list()

#Create a data frame with data.frame()

#Create some vectors

##Manually

##From a sequence

##From random sampling a normal distribution

#Create a number vector, with one of the elements being a character

##What happens when we see the data type with typeof()?

##What happens when we coerce the vector to number?

#Create a named vector

#Create a vector without names, and give each value a different name with names()

#Create a long vector

##Explore the vector with head and tail

##Subset the vector by index

##Subset the vector by a subsetting vector with multiple indices

##Subset the vector by a sequence

##Subset the vector by excluding one index

##Subset the vector by excluding a sequence of indices

#Create a named vector. It can be the one created above

##Subset the vector by the name of a value

#With the following vector
yet_another_vector <- c(9,5,8,1,NA,7,1,NA,3,3)
yet_another_vector

##Subset the vector to keep only the NA values

##Subset the vector to exclude all NA values

##Subset the vector to show only values smaller than or equal to five

##Subset the vector to show only values that are equal to one

##Change the value of the fourth index to 7

##Change the value of index 101 to 2. What happened?


#Create a list where the first element is a numeric vector, the second is a single character, and the third is a list
#where the first element of that nested list is the value TRUE, and the second is the vector 4:6

##Access the first element of the list with []

##Access the first element of the list with [[]]. What's the difference?

#Check out the named list below with glimpse
julius_caesar <- list(id_numbers = list(id = 123456789,
                                        health_insurance = NA),
                      name = "Julius Caesar",
                      addresses = list(child_home = "Slums of Subura",
                                       roman_homes = c("Roman Palace 1", "Roman Palace 2"),
                                       epigtian_homes = "Cleopatra's Palace"),
                      website = "www.venividivici.com")

#Get the names of all the Roman Homes using the $ syntax


#Statistical models output lists in R. Check out the output below
#HINT: use the object explorer to visually explore the output
some_model_output <- lm(lifeExp ~ gdpPercap, data = gapminder::gapminder)

#Select the coefficient associated with gdpPercap

#Check out the following data.frame
amazing_tibble <- data.frame(col1 = c(1:26),
                         col2 = letters,
                         col3 = rnorm(26))

##Get the value from the row 17, column 2

##get all the cols from row 5

##get all the rows from col3 using [], and using $amazing_tibble["col3"]

##NOTE: we will have different values due to random sampling


#Check out the gapminder dataset with glimpse()
library(gapminder)
gapminder

## select the top 20% rows with slice_head

## select the bottom 5 rows with slice_tail

## Select a 10% sample with slice_sample, weighted in such a way that smaller countries are most likely to be selected
