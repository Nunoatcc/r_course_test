###############################################
#                                             #
# PART 02                                     #
# Introduction to the tidyverse               #
# Exercises                                   #
#                                             #
###############################################

#==== Pipe ====


#==== Filter ====

#With the gapminder dataset from the {gapminder} package

##Filter only rows where country equals Portugal

##Filter only rows where country equals Portugal AND year is 2007

##Filter only rows where country equals Portugal OR Spain

##Filter for Portugal and Spain with the %in% operator, and plot the results 
###Copy the code from the slides, and change the input values to see what happens


#Using the airquality dataset:

#Filter only observations from
#a) September,
#b) for days that are multiples of five,
#c) where temperature was above 80.


##Keep only rows where Solar.R is missing

#==== Arrange ====

#With the gapminder dataset

##Arrange by year ascending


##Arrange by year descending

#Arrange/sort by continent (descending) and then by lifeExp (ascending)


##Using the gapminder dataset, show a data frame with the most recent 
##year only, ordered by life expectancy (higher to lower)


#With the polyps dataset from the {medicaldata package}

##Filter only rows of female patients, and arrange descending by sex and then by number of polyps at 12m.
###Are all the NAs at the bottom? Why or w-hy not?

#==== Distinct ====

#With the gapminder dataset

##Check how many countries exist with distinct
#Get a list of unique/distinct years


##Get a distinct combination of continent + year


#If we wanted to keep all variables


#==== Count ====

#Using the gapminder dataset

##Count how many observations exist for each combination of continent + year?


#using the fluH7N9_china_2013 from the {outbreaks} package

##Find out how many people died with the help of the count() function


#==== Select ====

#Using the gapminder dataset

##Select ONLY continent and life expectancy


##Select columns BETWEEN continent and lifeExp (inclusive)


##Select columns EXCEPT those between continent and lifeExp (inclusive)


#Select only integer columns


#Select columns that start with the letter "c"



#using the fluH7N9_china_2013 from the {outbreaks} package

##Select only columns of type factor


##Select only columns that contain the text "_of_" in the name
###HINT: use the function contains()


#==== Rename ====

#Using the gapminder dataset

##rename lifeExp to le


#Using the eurostat_geodata_60_2016 dataset from the {eurostat} package

##rename all the columns at the same time with clean_names()

  
#==== Relocate ====

#Using the gapminder dataset

##make continent the first column


#==== mutate ====

#Using the gapminder dataset

##Calculate a column for the pop in millions and other for the total gdp (gpd per capita * pop)


#using the fluH7N9_china_2013 from the {outbreaks} package

##Calculate a column for disease duration (difference between date of outcome and date of onset)
##And then filter only rows that are not NA in the column you just calculated

#==== group_by and summarise ====

#Using the gapminder dataset

## Calculate the mean gdpPercap, by continent


#using the fluH7N9_china_2013 from the {outbreaks} package

##Calculate a column for disease duration (difference between date of outcome and date of onset)
##And then filter only rows that are not NA in the column you just calculated
##Summarise the column you created to get the mean and median disease duration


# ==== left_join ====

#Get the pt_pop_2022 and pt_deaths_2022 data from github

##join the datasets with left_join (using the population dataset as the leftmost table)


##Now change the name of the "year" variable to "YEAR", in the deaths dataset. What impact will that haveon left_join()?
##What do you need to do to solve the issue?
#Rename the year variable to showcase this scenario


##Check if any NAs were introduced with the joining operation. Why did this happen?


#==== pivot_longer ====

#Creating a dataset to test pivot_longer
indometh_wide <- medicaldata::indometh %>% 
  pivot_wider(names_from = "time", values_from = "conc") %>% 
  rename_with(~str_c("t",.),-Subject)

#Using the dataset above, convert it to a tidy tibble


#How could you remove the extra "t" from the time column you just created?


#==== pivot_wider ====

#Using the indometh dataset from the {medicaldata} package

##Convert the Subjects variable into WIDE format
