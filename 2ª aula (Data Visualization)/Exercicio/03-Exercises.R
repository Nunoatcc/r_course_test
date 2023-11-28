###############################################
#                                             #
# PART 03                                     #
# Exploratory Data Analysis (EDA)             #
# Exercises                                   #
#                                             #
###############################################

#Load packages
library(tidyverse) #ggplot is part of the tidyverse
library(crosstable)
library(gapminder)
library(medicaldata)

# ==== UNIVARIATE NON-GRAPHICAL ====
#===================================

# CATEGORICAL DATA

#Using the polyps dataset, from the {medicaldata} package, do:

#Crosstabulation with the tidyverse, showing absolute and relative frequencies

## For sex



#Crosstabulation with {crosstable}

## For sex

## For treatment


# What are the advantages and disadvantages of using each approach?



# QUANTITATIVE DATA


#Using the gapminder dataset, from the {gapminder} package, do:

#BASE R: Summary statistics 

##All the quantiles of life expectancy, in 1% increments


#TIDYVERSE: Summary statistics

##Max, Min, Mean, median, IQR, standard deviation


#CROSSTABLE: Summary statistics

#For life expectancy

#For all variables except country



#Using the polyps dataset, from the {medicaldata} package, do:

#TIDYVERSE: Summary statistics (Mean, Median, SD) for the number of polyps at 12m~ - What happened and why?


#What is the mean and standard deviation of GDP per capita in the most recent year, by continent?



# ==== UNIVARIATE GRAPHICAL ====
#===============================

#With the gapminder dataset, and using {ggplot2}

# Histogram of life expectancy


# Density plot of life expectancy, filled by continent


# Density of life expectancy, filled by continent, faceted


# Quantile-quantile plot


#==== MULTIVARIATE NON-GRAPHICAL ====
#====================================

# CATEGORICAL DATA

#Using the polyps dataset, from the {medicaldata} package, do:

#crosstable of treatment over sex

#crosstable of treatment and age over sex

#crosstable of all other variables, except paticipant_id, over sex


#QUANTITATIVE DATA

#Using the gapminder dataset, from the {gapminder} package, do:

#Correlation of life expectancy and gdp per capita using cor()

#Covariance of life expectancy and gdp per capita using cov()

#Correlation of life expectancy and population with gdp per capita using crosstable



#Using the polyps dataset, from the {medicaldata} package, do:

#Correlation of polyps at baseline with polyps at 12m. 
##What happens? Try to explore the function help file with F1 or ? and solve the problem 

#Confirm the results above with crosstable

#==== MULTIVARIATE GRAPHICAL ====
#================================

#Using the polyps dataset, from the {medicaldata} package, do:

#Bar chart of mean number of polyps at 3M for placebo vs sulindac

#Was this the best approach to the problem? 
#What bias can be present in using the mean number of polyps? How could we improve on that?



#Stacked bar chart of mean number of polyps at 3M for placebo vs sulindac, BY SEX



#Using the gapminder dataset, from the {gapminder} package, do:

# A scatter plot of life expectancy and gdp per capita for all the available data



#In some places the point density is so high that it's difficult to understand 
#if some regions of space are denser than others. How to improve? HINT: Change the alpha (aka, transparency)


#Bubble chart, with the size of the bubble proportional to population size


#Violin plot with the distribution of life expectancy by continent


