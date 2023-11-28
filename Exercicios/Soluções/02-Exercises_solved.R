###############################################
#                                             #
# PART 02                                     #
# Introduction to the tidyverse               #
# Exercises                                   #
#                                             #
###############################################

#Load packages
library(tidyverse)
library(gapminder)
library(medicaldata)
library(outbreaks)
library(eurostat)
library(rio)

#==== Pipe ====

##All the below are equivalent
glimpse(airquality)
airquality %>% glimpse
airquality %>% glimpse()
airquality %>% glimpse(.)
airquality %>% glimpse(x = .)

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
  filter(country == "Portugal" | country == "Spain")

##Filter for Portugal and Spain with the %in% operator, and plot the results 
gapminder %>% 
  filter(country %in% c("Portugal","Spain"))

###Copy the code from the slides, and change the input values to see what happens
countries <- "Portugal"

#No need to change the chart code! Just the input fields above
gapminder %>% 
  filter(country %in% countries) %>% 
  ggplot(aes(x = year,
             y = lifeExp, 
             color = country)) +
  geom_line()

#Using the airquality dataset:

#Filter only observations from
#a) September,
#b) for days that are multiples of five,
#c) where temperature was above 80.
airquality %>% 
  filter(Month == 9,
         Day %in% seq(5,30,5),
         Temp > 80)


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

#With the polyps dataset from the {medicaldata package}

##Arrange descending by sex and then by number of polyps at 12m.
###Are all the NAs at the bottom? Why or why not?
polyps %>%
  arrange(desc(sex), number12m)
#NAs are at the bottom of each group, not the entire dataset

#==== Distinct ====

#With the gapminder dataset

##Check how many countries exist with distinct
#Get a list of unique/distinct years
gapminder %>% 
  distinct(country)

##Get a distinct combination of continent + year
gapminder %>% 
  distinct(continent, year)

#If we wanted to keep all variables
gapminder %>% 
  distinct(continent, year, .keep_all = T)

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
  select(where(is.integer))

#Select columns that start with the letter "c"
gapminder %>% 
  select(starts_with("c"))


#using the fluH7N9_china_2013 from the {outbreaks} package

##Select only columns of type factor
fluH7N9_china_2013 %>% 
  select(where(is.factor))

##Select only columns that contain the text "_of_" in the name
###HINT: use the function contains()
fluH7N9_china_2013 %>% 
  select(contains("_of_")) %>% 
  glimpse()

#==== Rename ====

#Using the gapminder dataset

##rename lifeExp to le
gapminder %>% 
  rename(le = lifeExp) %>% 
  glimpse()


#Using the eurostat_geodata_60_2016 dataset from the {eurostat} package

##rename all the columns at the same time with clean_names()
eurostat_geodata_60_2016 %>% 
  janitor::clean_names() %>% 
  glimpse()
  
#==== Relocate ====

#Using the gapminder dataset

##make continent the first column
gapminder %>% 
  relocate(continent, .before = country) %>% #by var NAME 
  colnames()

gapminder %>% 
  relocate(continent, .before = 1) %>% #by var INDEX 
  colnames()

#==== mutate ====

#Using the gapminder dataset

##Calculate a column for the pop in millions and other for the total gdp (gpd per capita * pop)
gapminder %>% 
  mutate(pop_millions = pop / 1e6,
         total_gdp = gdpPercap * pop) %>%
  head(5)

#using the fluH7N9_china_2013 from the {outbreaks} package

##Calculate a column for disease duration (difference between date of outcome and date of onset)
##And then filter only rows that are not NA in the column you just calculated
fluH7N9_china_2013 %>% 
  mutate(disease_duration = date_of_outcome - date_of_onset) %>% 
  filter(!is.na(disease_duration))

#==== group_by and summarise ====

#Using the gapminder dataset

## Calculate the mean gdpPercap, by continent
gapminder %>% 
  group_by(continent) %>% 
  summarise(n = n(), #counts the number of rows
            mean_gdp = mean(gdpPercap),
            median_pop = median(pop))


#using the fluH7N9_china_2013 from the {outbreaks} package

##Calculate a column for disease duration (difference between date of outcome and date of onset)
##And then filter only rows that are not NA in the column you just calculated
##Summarise the column you created to get the mean and median disease duration
fluH7N9_china_2013 %>% 
  mutate(disease_duration = date_of_outcome - date_of_onset) %>% 
  filter(!is.na(disease_duration)) %>% 
  summarise(n = n(), #counts the number of rows
            mean_gdp = mean(disease_duration),
            median_pop = median(disease_duration))


# ==== left_join ====

#Get the pt_pop_2022 and pt_deaths_2022 data from github
pt_population <- rio::import("https://github.com/c-matos/Intro-R4Heads/raw/main/materials/data/pt_pop_2022.csv")
pt_deaths <- rio::import("https://github.com/c-matos/Intro-R4Heads/raw/main/materials/data/pt_deaths_2022.csv")

##join the datasets with left_join (using the population dataset as the leftmost table)
pt_population %>% 
  left_join(x = .,
            y = pt_deaths,
            by = c("age")) %>% #join by age
  head(5)

pt_population %>% 
  left_join(x = .,
            y = pt_deaths,
            by = c("age","year")) %>% #join by age and year
  head(5)

##Now change the name of the "year" variable to "YEAR", in the deaths dataset. What impact will that have on left_join()?
##What do you need to do to solve the issue?
#Rename the year variable to showcase this scenario
pt_deaths <- pt_deaths %>% 
  rename(YEAR = year)

colnames(pt_deaths)

pt_full_data <- pt_population %>% 
  left_join(x = .,
            y = pt_deaths,
            by = c("age","year" = "YEAR")) #Need to specify here the name of the column in x and y that are equivalent

#Note that since "age" is named the same way in both datasets, we can pass only the name of the variable
#For the variables that have different names, we need to specify "NAME_IN_X" = "NAME_IN_Y"

##Check if any NAs were introduced with the joining operation. Why did this happen?
pt_full_data %>% 
  filter(if_any(everything(), is.na))

#Answer: Age groups that do not exist in the "deaths" dataset become NA, 
#in the deaths values, because no value was found for them

#==== pivot_longer ====

#Creating a dataset to test pivot_longer
indometh_wide <- medicaldata::indometh %>% 
  pivot_wider(names_from = "time", values_from = "conc") %>% 
  rename_with(~str_c("t",.),-Subject)

#Using the dataset above, convert it to a tidy tibble
indometh_wide %>% 
  pivot_longer(
    cols = -Subject, #All except Subject
    names_to = "time", 
    values_to = "plasma_conc"
  )

#Alternatively
alt <- indometh_wide %>% 
  pivot_longer(
    cols = starts_with("t"), #All that start with letter "t"
    names_to = "time", 
    values_to = "plasma_conc"
  )

#How could you remove the extra "t" from the time column you just created?
indometh_wide %>% 
  pivot_longer(
    cols = -Subject,
    names_to = "time", 
    values_to = "plasma_conc"
  ) %>% 
  mutate(time = parse_number(time))

#==== pivot_wider ====

#Using the indometh dataset from the {medicaldata} package

##Convert the Subjects variable into WIDE format
Indometh %>% 
  pivot_wider(names_from = Subject,
              values_from = conc)


#BONUS: Displayingwith kableExtra
library(kableExtra)

Indometh %>% 
  pivot_wider(names_from = Subject,
              values_from = conc) %>% 
  kableExtra::kbl() %>% 
  kableExtra::kable_styling(c("condensed","hover")) 
