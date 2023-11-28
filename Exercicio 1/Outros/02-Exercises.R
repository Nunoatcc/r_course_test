###############################################
#                                             #
# PART 02                                     #
# Introduction to the tidyverse               #
# Exercises                                   #
#                                             #
###############################################

#==== Pipe ====

library(tidyverse)
library(gapminder)
library(outbreaks)
library (medicaldata)

glimpse(gapminder)
gapminder %>% glimpse
gapminder %>% glimpse(width = 30)
gapminder %>% view


#==== Filter ====

#With the gapminder dataset from the {gapminder} package

##Filter only rows where country equals Portugal
gapminder %>% 
  filter(country == "Portugal")

##Filter only rows where country equals Portugal AND year is 2007
gapminder %>% 
  filter(country == "Portugal" & year == 2007)


##Filter only rows where country equals Portugal OR Spain
gapminder %>% 
  filter(country == "Portugal" | country == "Spain") %>% 
  print(n=24)

##Filter for Portugal and Spain with the %in% operator, and plot the results 
countries <- c("Portugal", "Spain")

gapminder %>% 
  filter(country %in% countries,
         year == 2007)

###Copy the code from the slides, and change the input values to see what happens


#Using the airquality dataset:

#Filter only observations from
#a) September,
airquality %>% 
  filter(Month == 9)

#b) for days that are multiples of five,
airquality %>% 
  filter(Month == 9, Day %in% seq(0,30,5)) # o %in% signfica que a sequencia de numeros multiplos de 5 têm que estar "in" no Mes nº9(setembro)

#c) where temperature was above 80.
airquality %>% 
  filter(Month ==9,
         Day %in% seq(0,30,5),
         Temp >80)

##Keep only rows where Solar.R is missing
airquality %>% 
  filter(is.na(Solar.R))

#==== Arrange ====

#With the gapminder dataset

##Arrange by year ascending
gapminder %>% 
  arrange(year)

##Arrange by year descending
gapminder %>% 
  arrange(desc(year))

#Arrange/sort by continent (descending) and then by lifeExp (ascending)
gapminder %>% 
  arrange(desc(continent), lifeExp)

##Using the gapminder dataset, show a data frame with the most recent 
##year only, ordered by life expectancy (higher to lower)
gapminder %>% 
  filter(year == 2007) %>% 
  arrange(desc(lifeExp))

# OU
gapminder %>% 
  filter(year == max(year)) %>% 
  arrange(desc(lifeExp))

#With the polyps dataset from the {medicaldata package}

##Filter only rows of female patients, and arrange descending by sex and then by number of polyps at 12m.
polyps %>% 
  filter(sex == "female") %>% 
  arrange(desc(number12m))

###Are all the NAs at the bottom? Why or w-hy not?

#==== Distinct ====

#With the gapminder dataset

##Check how many countries exist with distinct
gapminder %>% 
  distinct(country)

#Get a list of unique/distinct years
gapminder %>% 
  distinct(year)

##Get a distinct combination of continent + year
gapminder %>% 
  distinct(continent, year)

#If we wanted to keep all variables
gapminder %>% 
  distinct(continent, year, 
           .keep_all = T)

#==== Count ====

#Using the gapminder dataset

##Count how many observations exist for each combination of continent + year?
gapminder %>% 
  count(continent, year)

#using the fluH7N9_china_2013 from the {outbreaks} package

##Find out how many people died with the help of the count() function
fluH7N9_china_2013 %>% 
  count(outcome)

#==== Select ====

#Using the gapminder dataset

##Select ONLY continent and life expectancy
gapminder %>% 
  select(continent, lifeExp)

##Select columns BETWEEN continent and lifeExp (inclusive)
gapminder %>% 
  select(continent:lifeExp)

##Select columns EXCEPT those between continent and lifeExp (inclusive)
gapminder %>% 
  select(!continent:lifeExp)

#Select only integer columns
gapminder %>% 
  select (where(is.integer)) %>% 
  glimpse()

#Select columns that start with the letter "c"
gapminder %>% 
  select(starts_with("c")) %>% 
  glimpse



#using the fluH7N9_china_2013 from the {outbreaks} package

##Select only columns of type factor

fluH7N9_china_2013 %>% 
  select(where(is.factor)) %>% 
  glimpse()

##Select only columns that contain the text "_of_" in the name
fluH7N9_china_2013 %>% 
  select(contains("_of_")) %>% 
  glimpse()

###HINT: use the function contains()

fluH7N9_china_2013 %>%
  view()

#==== Rename ====

#Using the gapminder dataset

##rename lifeExp to le
gapminder %>% 
  rename(le = lifeExp) %>% 
  glimpse()

#Using the eurostat_geodata_60_2016 dataset from the {eurostat} package

##rename all the columns at the same time with clean_names()
gapminder_crazy_names <- gapminder %>% 
  rename(ÇOUNTRY = country,
         Continent = continent,
         LifeExp = lifeExp,
         Ýear = year,
         PÔP = pop,
         GDPPercap = gdpPercap)

colnames(gapminder_crazy_names)

gapminder_crazy_names %>% 
  janitor::clean_names() %>% 
  colnames()
  
#==== Relocate ====

#Using the gapminder dataset

##make continent the first column


#==== mutate ====

#Using the gapminder dataset

##Calculate a column for the pop in millions and other for the total gdp (gpd per capita * pop)
gapminder %>% 
  mutate(pop_millions = pop / 1e6,
         total_gdp = gdpPercap+pop) %>% 
  head(5)

#using the fluH7N9_china_2013 from the {outbreaks} package

##Calculate a column for disease duration (difference between date of outcome and date of onset)

##And then filter only rows that are not NA in the column you just calculated
fluH7N9_china_2013 %>% 
  mutate(dis_dur = date_of_outcome - date_of_onset) %>% 
  filter(!is.na(dis_dur))


#==== group_by and summarise ====

#Using the gapminder dataset

## Calculate the mean gdpPercap, by continent
gapminder %>% 
  group_by(continent) %>% 
  summarise(mean_gdp = mean(gdpPercap))

#using the fluH7N9_china_2013 from the {outbreaks} package

##Calculate a column for disease duration (difference between date of outcome and date of onset)
##And then filter only rows that are not NA in the column you just calculated
##Summarise the column you created to get the mean and median disease duration

fluH7N9_china_2013 %>% 
  mutate(disease_duration = date_of_outcome - date_of_onset) %>% 
  filter(!is.na(disease_duration)) %>% 
  summarise(mean_dd = mean(disease_duration),
            median_dd = median(disease_duration))


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
